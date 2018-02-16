#ifdef CS333_P3P4
#include "types.h"
#include "user.h"
#include "param.h"

int
main(void)
{
 
  int count, pid, i;
  count = 0;
  printf(1, "Maximum number of processes is: %d\n", NPROC);
  while ((pid = fork()) != -1){
    if (!pid)
      exit();
    count++;
  }
  printf(1, "Forked %d procs, sleeping 10 seconds\n", count);
  sleep(10000);
  //int temp, i;
  while((i = wait()) != -1){
    printf(1, "killed: %d; ", i);
  }
  //int pid, i;
  /*for (i = 0; i < 10; i++){
    pid = fork();
    if (!pid)
      for (;;);
    printf(1, "killable pid: %d\n", pid);
  }
  while (wait() != -1);
  int pid = fork();
  if (!pid)
    for(;;);
  wait();*/
 exit();
}
#endif
