#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#ifdef CS333_P2
#include "uproc.h"
#endif


//P4
#ifdef CS333_P3P4
#define TICKS_TO_PROMOTE 100
#endif

#ifdef CS333_P3P4
struct StateLists {
  struct proc * ready[MAX + 1];
  struct proc * free;
  struct proc * sleep;
  struct proc * zombie;
  struct proc * running;
  struct proc * embryo;
};
#endif

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
#ifdef CS333_P3P4
  struct StateLists pLists;
  uint PromoteAtTime;
#endif
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);
#ifdef CS333_P3P4
static void assertState(struct proc *, enum procstate);
static int remove_from_list(struct proc **, struct proc *);
//static int tail_add(struct proc **, struct proc **);
static int tail_add(struct proc **);
static struct proc * pop(struct proc**);
static struct proc * pid_search(struct proc *, int);
static struct proc * ready_pid_search(int);
static void pass_to_init(struct proc **, struct proc *);
static void ready_pass_to_init(struct proc *);
static int have_kids(struct proc * list, struct proc *);
static int ready_have_kids(struct proc *);
static void budget_calc(struct proc **);
static void promote_list(struct proc **);
static char *states[]; 
#endif

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;
  acquire(&ptable.lock);
#ifndef CS333_P3P4
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
#else
  if((p = ptable.pLists.free))
    goto found;
#endif
  release(&ptable.lock);
  return 0;

found:
#ifdef CS333_P3P4
  ptable.pLists.free = p->next;
  assertState(p, UNUSED);
  p->state = EMBRYO;
  p->next = ptable.pLists.embryo;
  ptable.pLists.embryo = p;
  assertState(p, EMBRYO);
#else
  p->state = EMBRYO;
#endif
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
#ifdef CS333_P3P4
    acquire(&ptable.lock);
    if(!remove_from_list(&ptable.pLists.embryo, p)){
      panic("Failed to allocate kernel stack and unable to locate proc in EMBRYO\n");
    }
    assertState(p, EMBRYO);
    p->state = UNUSED;
    p->next = ptable.pLists.free;
    ptable.pLists.free->next = p;
    assertState(p, UNUSED);
    release(&ptable.lock);
#else
    p->state = UNUSED;
#endif
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

#ifdef CS333_P1
  p->start_ticks = ticks;
#endif
#ifdef CS333_P2
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
#endif
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

#ifdef CS333_P3P4
  struct proc * x;
  acquire(&ptable.lock);
  for (x = ptable.proc; x < ptable.proc + NPROC - 1; x++){
    x->state = UNUSED;
    x->next = x + 1;
  }
  x->next= NULL;
  x->state = UNUSED;
  ptable.pLists.free = ptable.proc;
  //ptable.pLists.ready = NULL; P3
  ptable.pLists.sleep = NULL;
  ptable.pLists.zombie = NULL;
  ptable.pLists.running = NULL;
  ptable.pLists.embryo = NULL;
  // P4
  int i;
  for (i = 0; i <= MAX; i++){
    ptable.pLists.ready[i] = NULL;
  }
  ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
  release(&ptable.lock);
#endif
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

#ifdef CS333_P2
  p->uid = DEFUID;
  p->gid = DEFGID;
#endif
#ifdef CS333_P3P4
  p->budget = BUDGET;
  p->priority = 0;
  acquire(&ptable.lock);
  if (remove_from_list(&ptable.pLists.embryo, p) == 0)
    panic("Failure to locate embryo");
  assertState(p, EMBRYO);
  p->state = RUNNABLE;
  ptable.pLists.ready[0] = p; // P4
  p->next = NULL;
  /*if (tail_add(&ptable.pLists.ready, &p) == 0)
    panic("P is NULL\n");*/
  assertState(p, RUNNABLE);
  release(&ptable.lock);
#else
  p->state = RUNNABLE;
#endif
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
#ifdef CS333_P3P4
    acquire(&ptable.lock);
    if (!remove_from_list(&ptable.pLists.embryo, np)){
      panic("unable to locate process in embryo list\n");
    }
    assertState(np, EMBRYO);
    np->state = UNUSED;
    np->next = ptable.pLists.free;
    ptable.pLists.free = np;
    assertState(np, UNUSED);
    release(&ptable.lock);
#else
    np->state = UNUSED;
#endif
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
#ifdef CS333_P2
  np->gid = proc->gid;
  np->uid = proc->uid;
#endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
#ifdef CS333_P3P4
    if (!remove_from_list(&ptable.pLists.embryo, np)){
      panic("unable to locate process in embryo list\n");
    }
    assertState(np, EMBRYO);
    np->state = RUNNABLE; 
    //tail_add(&ptable.pLists.ready, &np);
    tail_add(&np);
    assertState(np, RUNNABLE);
#else
  np->state = RUNNABLE;
#endif
  release(&ptable.lock);
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  //struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  ready_pass_to_init(proc);
  pass_to_init(&ptable.pLists.embryo, proc);
  pass_to_init(&ptable.pLists.running, proc);
  pass_to_init(&ptable.pLists.zombie, proc);
  pass_to_init(&ptable.pLists.sleep, proc);

  remove_from_list(&ptable.pLists.running, proc);
  assertState(proc, RUNNING);
  proc->state = ZOMBIE;
  proc->next = ptable.pLists.zombie;
  ptable.pLists.zombie = proc;
  assertState(proc,ZOMBIE);
  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");

}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    p = ptable.pLists.zombie;
    if (!p){
     struct proc * temp = proc;
     havekids = ready_have_kids(temp);
     if (!havekids)
       havekids = have_kids(ptable.pLists.sleep, temp);
     if (!havekids)
       havekids = have_kids(ptable.pLists.running, temp);
     if (!havekids)
       havekids = have_kids(ptable.pLists.embryo, temp);
    }
    else{
      while(p){
        if (p->parent == proc){
          pid = p->pid;
          kfree(p->kstack);
          p->kstack = 0;
          freevm(p->pgdir);
          remove_from_list(&ptable.pLists.zombie, p);
          assertState(p, ZOMBIE);
          p->state = UNUSED;
          p->next = ptable.pLists.free;
          ptable.pLists.free = p;
          assertState(p, UNUSED);
          p->pid = 0;
          p->parent = 0;
          p->name[0] = 0;
          p->killed = 0;
          release(&ptable.lock);
          return pid;
        } 
        p = p->next;
      }
    }
    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
#ifdef CS333_P2
    p->cpu_ticks_in = ticks;
#endif
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}

#else
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
    int priority;
    priority = 0;
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    // P4
    if (ptable.PromoteAtTime >= ticks && MAX){
      // promote
      int n;
      n = 0;
      while (n < MAX){
        if(n || ptable.pLists.ready[0] == NULL){
          ptable.pLists.ready[n] = ptable.pLists.ready[n+1];
          promote_list(&ptable.pLists.ready[n+1]);
        }
        else{
          struct proc * current = ptable.pLists.ready[0];
          while(current->next)
            current = current->next;
          current->next = ptable.pLists.ready[1];
          promote_list(&ptable.pLists.ready[1]);
        }
        n++;
      }
      ptable.pLists.ready[MAX] = NULL;
      promote_list(&ptable.pLists.running);
      promote_list(&ptable.pLists.sleep);
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
    }
    while(priority <= MAX){
      if ((p = pop(&ptable.pLists.ready[priority]))) // p4
      {
        assertState(p, RUNNABLE);
        idle = 0;  // not idle this timeslice
        proc = p;
        switchuvm(p);
        p->state = RUNNING;
        p->next = ptable.pLists.running;
        ptable.pLists.running = p;
        assertState(p, RUNNING);
        p->cpu_ticks_in = ticks;
        swtch(&cpu->scheduler, proc->context);
        switchkvm();

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0;
      }
      else{
        priority++;
      }
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
#ifdef CS333_P2
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in;
#endif
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;
  struct proc * p = proc;
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  budget_calc(&p);
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
#ifdef CS333_P3P4
  struct proc * p = proc;
  if(!remove_from_list(&ptable.pLists.running, p)){
    panic("yielding process not in running list!");
  }
  assertState(p, RUNNING);
  proc->state = RUNNABLE;
  //if(!tail_add(&ptable.pLists.ready, &p))
  if(!tail_add(&p))
    panic("unable to add to ready list!");
  assertState(p, RUNNABLE);
#else
  proc->state = RUNNABLE;
#endif
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
#if CS333_P3P4
  struct proc * p = proc;
  if (remove_from_list(&ptable.pLists.running, p)){
    assertState(p, RUNNING);
    proc->state = SLEEPING;
    proc->next = ptable.pLists.sleep;
    ptable.pLists.sleep = proc;
    assertState(p,SLEEPING); 
  }
#else
  proc->state = SLEEPING;
#endif
  
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

//PAGEBREAK!
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc *p, * next;
  p = ptable.pLists.sleep;
  while(p){
    next = p->next;
    if(p->chan == chan){
      if (!remove_from_list(&ptable.pLists.sleep, p))
        panic("cannot locate sleeping proc in sleep list\n");
      assertState(p, SLEEPING);
      p->state = RUNNABLE;
      //tail_add(&ptable.pLists.ready, &p);
      tail_add(&p);
      assertState(p, RUNNABLE);
    }
    p = next;
  }
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock); // p4
  if ((p = ready_pid_search(pid)) || (p = pid_search(ptable.pLists.running, pid))
      || (p = pid_search(ptable.pLists.sleep, pid)) || (p = pid_search(ptable.pLists.zombie, pid))
      || (p = pid_search(ptable.pLists.embryo, pid))) {
    p->killed = 1;
    if(p->state == SLEEPING){
      if(!remove_from_list(&ptable.pLists.sleep, p))
        panic("kill failed to find process in sleep list");
      assertState(p, SLEEPING);
      p->state = RUNNABLE;
      //tail_add(&ptable.pLists.ready, &p);
      tail_add(&p);
      assertState(p, RUNNABLE);
    }
    release(&ptable.lock);
    return 0;
  }
  release(&ptable.lock);
  return -1;
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};

#ifdef CS333_P2
// helper function to output fractional numbers
void
zeropad(uint x)
{
  int miliseconds;
  miliseconds = x % 1000;
  cprintf("%d.", x / 1000);
  if (miliseconds >= 100)
    cprintf("%d", miliseconds);
  else if (miliseconds >=10)
    cprintf("0%d", miliseconds);
  else
    cprintf("00%d", miliseconds);
};
#endif

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
#ifndef CS333_P2
#ifdef CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t  PCs\n");
#endif
#else
  cprintf("\nPID\tName\t\tUID\tGID\tPPID\tElapsed\t\tCPU\tState\tSize\tPCs\n");
#endif
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state == UNUSED)
        continue;
      if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
        state = states[p->state];
      else
        state = "???";
#ifndef CS333_P2
#ifdef CS333_P1
      cprintf("%d\t%s\t%s", p->pid, state, p->name);
#else
      cprintf("%d %s %s", p->pid, state, p->name);
#endif
#ifdef CS333_P1
      int p_elapsed;
      int p_second;
      int p_milisecond;
      p_elapsed = ticks - p->start_ticks;
      p_second = p_elapsed / 1000;
      p_milisecond = p_elapsed % 1000;
      if (p_milisecond >= 100)
        cprintf("\t%d.%d\t  ", p_second, p_milisecond);
      else if (p_milisecond >= 10)
        cprintf("\t%d.0%d\t  ", p_second, p_milisecond);
      else
        cprintf("\t%d.00%d\t  ", p_second, p_milisecond);
#endif
      if(p->state == SLEEPING){
        getcallerpcs((uint*)p->context->ebp+2, pc);
        for(i=0; i<10 && pc[i] != 0; i++)
#ifdef CS333_P1
          cprintf("%p ", pc[i]);
#else
        cprintf(" %p", pc[i]);
#endif
#else
      cprintf("%d\t%s\t\t%d\t%d\t", p->pid, p->name, p->uid, p->gid);
      if (p->pid == 1)
        cprintf("%d\t", 1);
      else
        cprintf("%d\t", p->parent->pid);
      zeropad(ticks - p->start_ticks);
      cprintf("\t\t");
      zeropad(p->cpu_ticks_total);
      cprintf("\t%s\t%d\t%d\t", state, p->sz, p->sz);
      if(p->state == SLEEPING){
        getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf("%p ", pc[i]);
#endif
    }
    cprintf("\n");
  }
}

#ifdef CS333_P2
int
getprocs(uint max, struct uproc * table)
{
  int i, j;
  acquire(&ptable.lock);
  for (i = 0, j = 0; i < max; ++i){
    if (ptable.proc[i].state != UNUSED && ptable.proc[i].state != EMBRYO){
      table[j].pid = ptable.proc[i].pid;
      table[j].uid = ptable.proc[i].uid;
      table[j].gid = ptable.proc[i].gid;
      if (ptable.proc[i].pid == 1)
        table[j].ppid = 1;
      else
        table[j].ppid = ptable.proc[i].parent->pid;
      table[j].elapsed_ticks = ticks - ptable.proc[i].start_ticks;
      table[j].CPU_total_ticks = ptable.proc[i].cpu_ticks_total;
      table[j].size = ptable.proc[i].sz;
      safestrcpy(table[j].name, ptable.proc[i].name, sizeof(ptable.proc[i].name));
      safestrcpy(table[j].state, states[ptable.proc[i].state], 8);
      ++j;
    }
  }
  release(&ptable.lock);
  return j;
}
#endif

#ifdef CS333_P3P4
// keyboard interrupts
void
freedump()
{
  int count;
  struct proc * current;
  count = 0;
  current = ptable.pLists.free;
  while(current){
    count++;
    current = current->next;
  }
  cprintf("Free List Size: %d processes\n", count);
}
// P4
void
readydump()
{
  struct proc * current;
  int i;
  cprintf("Ready List Processes %d:\n", MAX);
  for (i = 0; i <= MAX; i++){
    current = ptable.pLists.ready[i];
    cprintf("%d: ", i);
    if (!current){
      cprintf("empty list\n");
      continue;
    }
    while(current && current->next){
      cprintf("(%d, %d)->", current->pid, current->budget);
      current = current->next;
    }
    cprintf("(%d, %d)\n", current->pid, current->budget);
  }
}

void
sleepdump()
{
  struct proc * current;
  current = ptable.pLists.sleep;
  cprintf("Sleep List Processes:\n");
  if (!current){
    cprintf("empty list\n");
    return;
  }
  while(current && current->next){
    cprintf("%d->", current->pid);
    current = current->next;
  }
  cprintf("%d\n", current->pid);
}

void
zombiedump()
{
  struct proc * current;
  current = ptable.pLists.zombie;
  cprintf("Zombie List Processes:\n");
  if (!current){
    cprintf("empty list\n");
    return;
  }
  while(current && current->next){
    cprintf("(%d, %d)->", current->pid, current->parent->pid);
    current = current->next;
  }
    cprintf("(%d, %d)\n", current->pid, current->parent->pid);
}

// state list functions
static void
assertState(struct proc * p, enum procstate state)
{
  if(!holding(&ptable.lock))
    panic("table not locked!");
  if (!p)
    panic("Proccess is NULL!\n");
  if (p->state != state){
    cprintf("expected %s, was %s. ", states[state], states[p->state]);
    panic("caused big problem!\n");
  }
}
/*
static int
tail_add(struct proc ** sList, struct proc ** p)
{
  struct proc * current;
  if(!*p){
    return 0;
  }
  current = *sList;
  if (!current){
    (*p)->next = NULL;
    *sList = *p;
    return 1;
  }
  while(current->next){
    current = current->next;
  }
  current->next = *p;
  (*p)->next = NULL;
  return 1;
}*/
static int
tail_add(struct proc ** p)
{
  struct proc * current;
  if (!*p)
    return 0;
  if ((*p)->budget == 0){
    (*p)->budget = BUDGET;
    if ((*p)->priority == MAX)
      (*p)->priority++;
  }
  current = ptable.pLists.ready[(*p)->priority];
  if (!current){
    (*p)->next = NULL;
    ptable.pLists.ready[(*p)->priority] = *p;
    return 1;
  }
  while(current->next)
    current = current->next;
  current->next = *p;
  (*p)->next = NULL;
  return 1;
}

static int
remove_from_list(struct proc ** sList, struct proc * p)
{
  struct proc * current, * previous;
  if (!*sList)
    return 0;
  if (*sList == p){
    *sList = (*sList)->next;
    return 1;
  }
  previous = current = *sList; // set previous and current to head
  while(current){
    if (current == p){
      previous->next = current->next;
      return 1;
    }
    previous = current;
    current = current->next;
  }
    return 0;
}

static struct proc *
pop(struct proc ** sList)
{
  struct proc * x;
  if (!*sList)
    return NULL;
  x = *sList;
  *sList = (*sList)->next;
  return x;
}

static struct proc *
pid_search(struct proc * sList, int pid)
{
  struct proc * current = sList;
  if (!sList)
    return NULL;
  while(current){
    if (current->pid == pid)
      return current;
    current = current->next;
  }
  return NULL;
}

static struct proc *
ready_pid_search(int pid)
{
  struct proc * p;
  int i;
  p = NULL;
  for (i = 0; i <= MAX; i++){
    if ((p = pid_search(ptable.pLists.ready[i], pid)))
      return p;
  }
  return NULL;
}

static int
have_kids(struct proc * list, struct proc * p)
{
  int havekids;
  struct proc * current;
  havekids = 0;
  current = list;
  while (current && !havekids){
    if (current->parent == p)
      havekids = 1;
    current = current->next;
  }
  return havekids;
}

static int
ready_have_kids(struct proc * p)
{
  int i;
  for (i = 0; i <= MAX; i++){
    if(have_kids(ptable.pLists.ready[i], p))
        return 1;
  }
  return 0;
}


static void
pass_to_init(struct proc ** list, struct proc * p)
{
  struct proc * current = *list;
  if (!current)
    return;
  while(current){
    if(current->parent == p){
      current->parent = initproc;
      if(current->state == ZOMBIE)
        wakeup1(initproc);
    }
    current = current->next;
  }
}

static void
ready_pass_to_init(struct proc * p)
{
  int i;
  for (i = 0; i <= MAX; i++)
    pass_to_init(&ptable.pLists.ready[i], p);
}

static void
budget_calc(struct proc ** p)
{
  (*p)->budget = (*p)->budget - (ticks - (*p)->cpu_ticks_in);
  if ((*p)->budget >= BUDGET)
    (*p)->budget = 0;
}

static void
promote_list(struct proc ** sList)
{
  struct proc * current;
  current = *sList;
  while (current){
    if(current->priority != 0)
      current->priority--;
    current = current->next;
  }
}

int
setpriority(int pid, int priority)
{
  struct proc * p;
  int i;
  p = NULL;
  for (i = 0; i <= MAX; i++){
    if ((p = pid_search(ptable.pLists.ready[i], pid))){
      remove_from_list(&ptable.pLists.ready[i], p);
      p->priority = priority;
      p->budget = BUDGET; 
      tail_add(&p);
      return 1;
    }
  }
  if ((p = pid_search(ptable.pLists.embryo, pid))){
    remove_from_list(&ptable.pLists.embryo, p);
    p->priority = priority;
    p->budget = BUDGET; 
    tail_add(&p);
    return 1;
  }
  if ((p = pid_search(ptable.pLists.running, pid))){
    remove_from_list(&ptable.pLists.running, p);
    p->priority = priority;
    p->budget = BUDGET; 
    tail_add(&p);
    return 1;
  }
  if ((p = pid_search(ptable.pLists.sleep, pid))){
    remove_from_list(&ptable.pLists.sleep, p);
    p->priority = priority;
    p->budget = BUDGET; 
    tail_add(&p);
    return 1;
  }
  return 0;
}
#endif
