CC = g++
CFLAGS = -Wall
LIBS = ../arithmetic_ops/libarithmetic_ops.a ../input_handler/libinput_handler.a
TARGET = main_logic_exec
# TARGET = main_logic

all: $(TARGET)

main_logic.o: main_logic.cpp
	$(CC) -c main_logic.cpp

$(TARGET): main_logic.o
	$(CC) main_logic.o $(LIBS) -o $(TARGET)

clean:
	rm -f *.o $(TARGET)
