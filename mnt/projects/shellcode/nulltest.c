#include "name.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

char ltest[256] = {0};
int main() {
  strncpy((char*)&ltest, (char*)&shellcode, 255);
  int cpylen = strlen((char*)&ltest);
  printf("Strcpy finds length of: %d\n", cpylen);
  printf("Actual length is: %d\n", sizeof(shellcode) / sizeof(shellcode[0]) - 1);
  exit(!(cpylen == sizeof(shellcode) / sizeof(shellcode[0]) - 1));
}
