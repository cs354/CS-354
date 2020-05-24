CC = gcc
FLAGS = -g -Wall -fno-stack-protector -z execstack -pthread
medium: src/driver.c src/config.h src/server.c src/server.h
	$(CC) ${FLAGS} -o medium src/driver.c src/config.h src/server.c src/server.h

clean:
	rm medium
