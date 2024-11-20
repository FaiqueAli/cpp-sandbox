CC = g++
CFLAGS = -c -Wall
TARGET = libarithmetic_ops.a

all: $(TARGET)

arithmetic_ops.o: arithmetic_ops.cpp
	$(CC) $(CFLAGS) arithmetic_ops.cpp

$(TARGET): arithmetic_ops.o
	ar rcs $(TARGET) arithmetic_ops.o

clean:
	rm -f *.o $(TARGET)
