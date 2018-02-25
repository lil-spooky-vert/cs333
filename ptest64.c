#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"

int
testgetproc(uint size)
{
  int table_size;
  struct uproc * table;
  table = malloc(sizeof(struct uproc) * size);
  table_size = getprocs(size, table);
  if (table_size >= 1){
    int i, j;
    printf(1, "PID\tName\t\tPID\tName\t\tPID\tName\t\tPID\tName\n");
    for (i = 0; i < table_size; i += 4){
      for (j = 0; j < 4 && i+j < table_size; j++){
        printf(1, "%d\t%s\t\t", table[i+j].pid, table[i+j].name);
      }
      printf(1, "\n");
    }
  }
  free(table);
  return table_size;
};

int
main (int argc, char * argv[])
{
  int pid, i;
  int tests[] = {1, 16, 64, 72};
  while((pid = fork()) != -1)
  {
    if (pid != 0)
    {
      wait();
      kill(pid);
      exit();
    }
  setpriority(getpid(), 2);
  }
  for (i = 0; i < 4; ++i){
    int result;
    printf(1, "Table size %d\n", tests[i]);
    result = testgetproc(tests[i]);
    printf(1, "Received %d processes\n", result);
  }
  sleep(3000);
  exit();
}
#endif
