CC = gcc
FLAGS = -g -Wall -fno-stack-protector -z execstack -pthread
vulnerable: src/driver.c src/config.h src/server.c src/server.h
	$(CC) ${FLAGS} -o vulnerable src/driver.c src/config.h src/server.c src/server.h

clean:
	rm tutorial
