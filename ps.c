#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"
#define PMAX 64 // maximum number of rows to return
int
main(void)
{
  int table_size;
  struct uproc * table;
  table = malloc(PMAX * sizeof(struct uproc));
  table_size = getprocs(PMAX, table);
  if (table_size >= 1){
    int i;
#ifndef CS333_P3P4
    printf(1, "\nPID\tName\t\tUID\tGID\tPPID\tElapsed\t\tCPU\tState\tSize\n");
#else
    printf(1, "\nPID\tName\t\tUID\tGID\tPPID\tPrio\tElapsed\t\tCPU\tState\tSize\n");
#endif
    for (i = 0; i < table_size; ++i){
#ifndef CS333_P3P4
      printf(1, "%d\t%s\t\t%d\t%d\t%d\t", table[i].pid, table[i].name, table[i].uid, table[i].gid, table[i].ppid);
#else
      printf(1, "%d\t%s\t\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name, table[i].uid, table[i].gid, table[i].ppid, table[i].prio);
#endif
      zeropad(table[i].elapsed_ticks);
      printf(1, "\t\t");
      zeropad(table[i].CPU_total_ticks);
      printf(1, "\t%s\t%d\n", table[i].state, table[i].size);
    }
  free(table);
  }
  else
    printf(2, "There was an error!\n");
  free(table);
  exit();
}
#endif
