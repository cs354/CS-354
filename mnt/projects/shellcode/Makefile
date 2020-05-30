all:
	gcc -g -z execstack -fno-stack-protector -o name name.c
	gcc -o nulltest nulltest.c
clean: 
	rm -f name nulltest
