CC = gcc
FLAGS = -g -Wall -fno-stack-protector -z execstack -pthread
easy: src/driver.c src/config.h src/server_thread.c src/server_thread.h
	$(CC) ${FLAGS} -o easy src/driver.c src/config.h src/server_thread.c src/server_thread.h

clean:
	rm easy
