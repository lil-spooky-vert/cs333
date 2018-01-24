#ifdef CS333_P2
#include "types.h"
#include "user.h"
int
main(int argc, char *argv[])
{
  int start_time, end_time;
  uint pid;
  if (argc == 1)
  {
    printf(1, "ran in 0.00 seconds\n");
    exit();
  }
  start_time = uptime();
  if ((pid = fork()) == 0){
      if(exec(argv[1], &argv[1]) < 0)
      {
        printf(1, "exec error!\n");
      }
  }
  wait();
  kill(pid);
  end_time = uptime();
  printf(1,"%s ran in %d seconds\n", argv[1], end_time - start_time);
  exit();
}

#endif
