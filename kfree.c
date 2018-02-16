#ifdef CS333_P3P4
#include "types.h"
#include "user.h"


int
main(void)
{
  int pid = fork();
  if (!pid)
    for(;;);
  printf(1, "kill pid %d\nsleeping for 10 seconds", pid);
  sleep(10000);
  wait();
  exit();
}
#endif
