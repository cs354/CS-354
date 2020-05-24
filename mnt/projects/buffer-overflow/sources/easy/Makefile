CC = gcc
FLAGS = -g -Wall -fno-stack-protector -z execstack -pthread
easy: src/driver.c src/config.h src/server.c src/server.h
	$(CC) ${FLAGS} -o easy src/driver.c src/config.h src/server.c src/server.h

clean:
	rm easy