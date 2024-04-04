CC := gcc
CFLAGS := -Wall -g
LDFLAGS := -lm

SRC := main.c fft/fft.c
OBJS := $(SRC:.c=.o)

OUT := main

all: $(OUT)

$(OUT): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OUT) $(OBJS)

.PHONY: all clean
