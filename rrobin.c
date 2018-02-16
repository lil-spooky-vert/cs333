#ifdef CS333_P3P4
#include "types.h"
#include "user.h"

int
main(int argc, char * argv[])
{
  int pid;
  switch(argc){
    case 1:
      pid = fork();
      if (!pid){
        char * args[] = {"rrobin", "1"};
        exec("rrobin", args);
      }
      //sleep(100);
      pid = fork();
      if (!pid){
        char * args[] = {"rrobin", "1", "1"};
        exec("rrobin", args);
      }
      //sleep(100);
      pid = fork();
      if (!pid){
        char * args[] = {"rrobin", "1", "1",  "1"};
        exec("rrobin", args);
      }
      wait();wait();wait();
      exit();
      break;
    case 2:
      printf(1, "A...");
      sleep(3000);
      printf(1, "A...\n");
      exit();
      break;
    case 3:
      printf(1, "B...");
      sleep(2000);
      printf(1, "B...");
      exit();
      break;
   case 4:
      printf(1, "C...");
      sleep(1000);
      printf(1, "C...");
      exit();
      break;
    default:
    break;
  } 
  exit();
}
#endif
