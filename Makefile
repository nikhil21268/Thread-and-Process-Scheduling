#TARGETS= Q1_1 Q1_2
TARGETS=Q1_1 Q1_2
CC_C=$(CROSS_TOOL)gcc
#CFLAGS=-Wall -g -std=c99 
CFLAGS=-g -pthread
all: clean $(TARGETS)
$(TARGETS):
	$(CC_C) $(CFLAGS) $@.c -o $@
clean:
	rm -f $(TARGETS)
#chmod u+x deploy.sh