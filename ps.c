#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"
#define PMAX 64 // maximum number of rows to return
int
main(void)
{
  //printf(1, "Not imlpemented yet.\n");
  uint table_size;
  struct uproc * table;
  table = malloc(PMAX * sizeof(struct uproc));
  table_size = getprocs(PMAX, table);
  if (table_size >= 1)
  {
    int i;
    printf(2, "\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
    for (i = 0; i < table_size; ++i)
    {
      printf(2, "%d\t%s\t%d\t%d\t%d\t%d\t%d\t%s\t%d\n", table[i].pid, table[i].name, table[i].uid,
          table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].state,
          table[i].size);
    }
  }
  else
    printf(1, "something didn't happen %d\n", table_size);
  free(table);
  exit();
}
#endif
