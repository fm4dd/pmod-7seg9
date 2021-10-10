CC=gcc
CFLAGS= -O3 -Wall -g
LIBS= -lgpiod
AR=ar

#ALLBIN= settm1640 demotm1640
ALLBIN= settm1640

all: ${ALLBIN}

clean:
	rm -f *.o ${ALLBIN}

settm1640: tm1640.o settm1640.o
	$(CC) tm1640.o settm1640.o -o settm1640 ${LIBS}

#demotm1640: tm1640.o demotm1640.o
#	$(CC) tm1640.o demotm1640.o -o demotm1640 ${LIBS}

