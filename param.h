#define NPROC        64  // maximum number of processes
#define KSTACKSIZE 4096  // size of per-process kernel stack
#define NCPU          8  // maximum number of CPUs
#define NOFILE       16  // open files per process
#define NFILE       100  // open files per system
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define MAXOPBLOCKS  10  // max # of blocks any FS op writes
#define LOGSIZE      (MAXOPBLOCKS*3)  // max data blocks in on-disk log
#define NBUF         (MAXOPBLOCKS*3)  // size of disk block cache
// #define FSSIZE       1000  // size of file system in blocks
#define FSSIZE       2000  // size of file system in blocks  // CS333 requires a larger FS.
#ifdef CS333_P2
#define DEFUID        1  // default UID for init
#define DEFGID        1  // default GID for init
#define MAXUID    32767  // max UID
#define MAXGID   MAXUID  // max GID
#endif
#ifdef CS333_P3P4
#define NULL          0  // sets NULL value
#define MAX           9 // max priority value P4
#define BUDGET        100000 // tick budget P4
#define TICKS_TO_PROMOTE 300000
#endif
