PROG_NAME := easy
CC := gcc

SRC_DIR := ./src
OBJ_DIR := ./obj

LD_FLAGS = -static -z execstack
CC_FLAGS = -I$(SRC_DIR) -O0 -g3 -Wall -Wextra -pedantic -fno-stack-protector -pthread -static

SRC_FILES := $(wildcard $(SRC_DIR)/*.c)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC_FILES))

all: dirs $(PROG_NAME)


$(PROG_NAME): $(OBJ_FILES)
	$(CC) $(LD_FLAGS) -o $@ $^

dirs: obj

obj:
	mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CC_FLAGS) -c -o $@ $<

clean:
	rm -rf $(PROG_NAME) obj/
