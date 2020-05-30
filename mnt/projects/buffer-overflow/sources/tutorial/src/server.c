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


void tutorial(int cfd, char* buf);

void* run(int cfd) {
  printf("Starting session %d\n", cfd);
  char buf[BUF_SZ];
  int r = read(cfd, buf, BUF_SZ);
  if (r > 0) {
    tutorial(cfd, buf);
    bzero(buf, BUF_SZ);
  }
  printf("Ending session %d\n", cfd);
  shutdown(cfd, SHUT_RDWR);
  return NULL;
}

void tutorial(int cfd, char* buf) {
    char local_buf[512];
    printf("%p\n", local_buf);
    dprintf (cfd, "This is what you sent me:\n%s\n", buf );
    strcpy(local_buf, buf);
}
