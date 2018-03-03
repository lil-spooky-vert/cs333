#include "types.h"
#include "user.h"

int
main (int argc, char * argv[])
{
  if (argc != 3){
    printf(1, "setpriority use is $pid $priority\n");
    exit();
  }
  int rc = setpriority(atoi(argv[1]), atoi(argv[2]));
    printf(1, "rc is %d\n", rc);
  exit();
}
