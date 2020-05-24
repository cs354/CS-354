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
#include <sys/syscall.h>
#include <time.h>

void hard(int cfd);

void *run(int cfd) {
    printf("Starting session %d\n", cfd);
    hard(cfd);
    printf("Ending session %d\n", cfd);
    shutdown(cfd, SHUT_RDWR);
    return NULL;
}

unsigned long timeish() {
    size_t buflen = sizeof(int);
    char rand[buflen];
    syscall(SYS_getrandom, (void*) rand, buflen, 0b11);
    int offset = (int) rand[0];
    unsigned long ourtime = (unsigned long) time(NULL);
    return  ourtime + offset;
}

void hard(int cfd) {
    int a;
    int b; // buf b a limit
    char buf[8] = {0,0,0,0,0,0,0,0};
    unsigned long our_time = timeish();
    a = 0;
    b = 8;
    while (a < b && a < 27) {
        read(cfd, &buf[++a], 1);
    }
    srand(our_time);
    printf("Read %ld bytes\n",read(cfd, &buf[0], b-a));
    if ((rand() & 0xFFFFF) == 1337) {
        return; // what are the odds!
    }
    exit(1);
}