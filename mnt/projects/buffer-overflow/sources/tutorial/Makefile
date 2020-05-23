CC = gcc
FLAGS = -g -Wall -fno-stack-protector -z execstack -pthread
tutorial: src/driver.c src/config.h src/server_thread.c src/server_thread.h
	$(CC) ${FLAGS} -o tutorial src/driver.c src/config.h src/server_thread.c src/server_thread.h

clean:
	rm tutorial