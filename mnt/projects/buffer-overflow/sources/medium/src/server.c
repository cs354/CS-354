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

void medium(int cfd);

void *run(int cfd) {
    printf("Starting session %d\n", cfd);
    medium(cfd);
    printf("Ending session %d\n", cfd);
    shutdown(cfd, SHUT_RDWR);
    return NULL;
}

void medium(int cfd) {
    char fight_song[256] = "Spread far the fame of our fair ";
    char recv[256];
    dprintf(cfd,"Finish this line: \n Spread far the fame of our fair \n");
    read(cfd, recv, 511);
    strcat(fight_song,recv);
    dprintf(cfd, fight_song);
}

