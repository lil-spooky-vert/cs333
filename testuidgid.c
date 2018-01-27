#ifdef CS333_P2
#include "types.h"
#include "user.h"

int
testuidgid(void)
{
  uint uid, gid, ppid;
  uid = getuid();
  printf(2, "Current UID is: %d\n", uid);

  printf(2, "Setting UID to 100\n");
  if (setuid(100) < 0){
    printf(2, "Error setting UID\n");
    return -1;
  }
  if((uid = getuid()) != 100){
    printf(2, "Error: UID was not preserved\n");
    return -1;
  }
  printf(2, "Current UID is: %d\n", uid);
  printf(2, "Attempting to set UID to -1\n");
  if(setuid(-1) == 0){
    printf(2, "UID was set to negative number\n");
    return -1;
  }
  printf(2, "Failed to set UID to -1\n");
  if((uid = getuid()) != 100){
    printf(2, "Error: UID was not preserved\n");
    return -1;
  }
  printf(2, "UID is %d\n", uid);
  printf(2, "Attempting to set UID to 32768\n");
  if (setuid(32768) == 0){
    printf(2, "UID was set to number outside the maximum value\n");
    return -1;
  }
  if ((uid = getuid()) != 100){
    printf(2, "Error: UID was not preserved\n");
    return -1;
  }
  printf(2, "Failed to set UID to 32768\n");
  printf(2, "UID is %d\n", uid);
  printf(2, "Failed to set UID to 32768\n");
  
  gid = getgid();
  printf(2, "Current GID is: %d\n", gid);

  printf(2, "Setting GID to 100\n");
  if (setgid(100) < 0){
    printf(2, "Error setting GID\n");
    return -1;
  }
  if((gid = getgid()) != 100){
    printf(2, "Error: GID was not preserved\n");
    return -1;
  }
  printf(2, "Current GID is: %d\n", gid);
  printf(2, "Attempting to set GID to -1\n");
  if(setgid(-1) == 0){
    printf(2, "GID was set to negative number\n");
    return -1;
  }
  printf(2, "Failed to set GID to -1\n");
  if((gid = getgid()) != 100){
    printf(2, "Error: GID was not preserved\n");
    return -1;
  }
  printf(2, "GID is %d\n", gid);
  printf(2, "Attempting to set GID to 32768\n");
  if (setgid(32768) == 0){
    printf(2, "GID was set to number outside the maximum value\n");
    return -1;
  }
  if ((gid = getgid()) != 100){
    printf(2, "Error: GID was not preserved\n");
    return -1;
  }
  printf(2, "Failed to set GID to 32768\n");
  printf(2, "GID is %d\n", gid);
  printf(2, "Failed to set GID to 32768\n");
  
  ppid = getppid();
  printf(2, "My parent process is: %d\n", ppid);
  printf(2, "Done!\n");
  return 0;
}

int
main (int argc, char * argv[])
{
  if (!testuidgid())
    printf(1, "All tests passed\n");
  else
    printf(1, "Test failed!\n");
  exit();
}

#endif
