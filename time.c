#ifdef CS333_P2
#include "types.h"
#include "user.h"
int
main(int argc, char *argv[])
{
  int start_time, end_time, fd[2], n;
  n = 0;
  uint pid;
  if (argc == 1)
  {
    printf(1, "ran in 0.000 seconds\n");
    exit();
  }
  pipe(fd); //TODO: check error
  start_time = uptime();
  if ((pid = fork()) == 0){
      if(exec(argv[1], &argv[1]) < 0)
      {
        close(fd[0]);
        n = -1;
        write(fd[1], &n, sizeof(int));
        printf(1, "exec error!\n");
        exit();
      }
  }
  wait();
  kill(pid);
  end_time = uptime();
  close(fd[1]);
  read(fd[0], &n, sizeof(int));  // check for errors
  if (n < 0)
  {
    close(fd[0]);
    printf(1, "ran in ");
    zeropad(end_time - start_time);
    printf(1, " seconds\n");
    exit();
  }
  close(fd[0]);
  printf(1,"%s ran in ", argv[1]);
  zeropad(end_time - start_time);
  printf(1, " seconds\n");
  exit();
}

#endif
