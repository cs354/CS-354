#include "server_thread.h"
#include "config.h"
#include <netinet/in.h>
#include <netinet/ip.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

int main(int argc, char* argv[]) {
  if (argc < 2) {
    fprintf(stderr, "Usage: %s <port>\n", argv[0]);
    exit(1);
  }

  unsigned int port = atoi(argv[1]);
  if (!port || port > 65535) {
   ABORT("Bad port");
  }

  signal(SIGPIPE, SIG_IGN);

  int sfd = socket(AF_INET, SOCK_STREAM, 0);

  if (sfd < 0) {
    ABORT("Socket: bad file descriptor");
  }

  struct sockaddr_in sa = {.sin_family = AF_INET,
                           .sin_port = htons(port),
                           .sin_addr.s_addr = INADDR_ANY};

  if (bind(sfd, (struct sockaddr*)&sa, sizeof(sa))) {
    ABORT("Failed to bind");
  }
  if (listen(sfd, 5)) {
    ABORT("Failed to listen");
  }

  struct sockaddr_in ca;
  socklen_t calen = sizeof(ca);

  for (;;) {
    int cfd = accept(sfd, (struct sockaddr*)&ca, &calen);
    if (cfd > 0) {
        if (fork() == 0) {
            run(cfd);
        }
    }
    usleep(1000);
  }
  exit(0);
}
