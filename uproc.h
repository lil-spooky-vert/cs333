#define STRMAX 32

struct urpoc {
    uint pid;
    uint uid;
    uint gid;
    uint ppid;
    uint elapsed_ticks;
    uint CPU_total_ticks;
    char state[STRMAX];
    uint size;
    char name[STRMAX];
};
