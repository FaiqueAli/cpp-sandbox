CC = g++
CFLAGS = -c -Wall
TARGET = libinput_handler.a

all: $(TARGET)

input_handler.o: input_handler.cpp
	$(CC) $(CFLAGS) input_handler.cpp

$(TARGET): input_handler.o
	ar rcs $(TARGET) input_handler.o

clean:
	rm -f *.o $(TARGET)
