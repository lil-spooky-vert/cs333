#ifdef CS333_P2
#include "types.h"
#include "user.h"
int
main(int argc, char * argv[])
{
  printf(1, "Waiting 30 seconds...");
  sleep(30000);
  printf(1, "Done waiting\n");
  exit();
}
#endif
