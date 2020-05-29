#include "server.h"
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <unistd.h>
#include <signal.h>

#define BUF_SZ 0x1000

void overwrite(char* buf);
void tutorial(int cfd, char* buf);

void* run(int cfd) {
  printf("Starting session %d\n", cfd);
  char buf[BUF_SZ];
  int r = read(cfd, buf, BUF_SZ);
  if (r > 0) {
    printf("RECV %s\n",buf);
    overwrite(buf);
  }
  printf("Ending session %d\n", cfd);
  shutdown(cfd, SHUT_RDWR);
  return NULL;
}

void overwrite(char* buf) {
// Sometimes 'long* ret' ends up in odd places on the stack
// so we make sure we overwrite RET like this.
  long* ret;
  ret = (long*)&ret + 1;
  (*ret) = (long)buf;
  ret = (long*)&ret + 2;
  (*ret) = (long)buf;
  ret = (long*)&ret + 3;
  (*ret) = (long)buf;
  ret = (long*)&ret + 4;
  (*ret) = (long)buf;
  return NULL;
}