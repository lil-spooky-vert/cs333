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
    printf(1, "PID  Name\tPID  Name\tPID  Name\tPID  Name\n");
    for (i = 0; i < table_size; i += 4){
      for (j = 0; j < 4 && i+j < table_size; j++){
        printf(1, "%d  %s\t\t", table[i+j].pid, table[i+j].name);
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
  int pid;
  while((pid = fork()) != -1)
  {
    if (pid != 0)
    {
      wait();
      kill(pid);
      exit();
    }
  }
  testgetproc(1);
  testgetproc(16);
  testgetproc(64);
  testgetproc(72);
  sleep(10000);
  exit();
}
#endif
