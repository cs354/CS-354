CC = gcc
FLAGS = -g -Wall -fno-stack-protector -z execstack -pthread
tutorial: src/driver.c src/config.h src/server.c src/server.h
	$(CC) ${FLAGS} -o tutorial src/driver.c src/config.h src/server.c src/server.h

clean:
	rm tutorial
