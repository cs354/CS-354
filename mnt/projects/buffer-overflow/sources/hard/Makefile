CC = gcc
FLAGS = -g -Wall -fno-stack-protector -z execstack -pthread
hard: src/driver.c src/config.h src/server.c src/server.h
	$(CC) ${FLAGS} -o hard src/driver.c src/config.h src/server.c src/server.h

clean:
	rm hard