#ifdef CS333_P2
#include "types.h"
#include "user.h"

int
main(int argc, char * argv[])
{
  int pid;
  if ((pid = fork()) != 0){
    sleep(3000);
    printf(1, "3 seconds passed, hit ctrl-p\n");
    sleep(1500);
    kill(pid);
    exit();
  }
  while(1);
  exit();
}

#endif
