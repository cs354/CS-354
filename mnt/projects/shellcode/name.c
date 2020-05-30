#include "name.h"

void run() {
   long* ret;
   ret = (long*)&ret + 4;
   (*ret) = (long)shellcode;
}

int main() {
   run();
   return 0;
}

