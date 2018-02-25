#define STRMAX 32

struct uproc {
    uint pid;
    uint uid;
    uint gid;
    uint ppid;
#ifdef CS333_P3P4
    uint prio;
#endif
    uint elapsed_ticks;
    uint CPU_total_ticks;
    char state[STRMAX];
    uint size;
    char name[STRMAX];
};
