ifeq ($(OS),Windows_NT)
CCOPY = copy
CMAKE = mingw32-make
CDEL = del /Q
CDELQ = >NUL
APPSTEM = .exe
S = \\
CXXFLAGS = -IC:$(S)sdl2$(S)include$(S)SDL2 -Iframework -I . -I .$(S)include -I .$(S)bin -I .$(S)6502 -DINCLUDE_DEBUGGING_SUPPORT -DWINDOWS
LDFLAGS = -LC:$(S)sdl2$(S)lib -lmingw32 -lSDL2main -lSDL2
else
CCOPY = cp
CDEL = rm -f
CDELQ = 
CMAKE = make
APPSTEM =
S = /
SDL_CFLAGS := $(shell sdl2-config --cflags)
SDL_LDFLAGS := $(shell sdl2-config --libs)
CXXFLAGS := $(SDL_CFLAGS) -O2 -DLINUX -DINCLUDE_DEBUGGING_SUPPORT \
			-I. -I .$(S)include -I.$(S)framework -I$(S)usr$(S)include$(S)SDL2 -I.$(S)6502 -I.$(S)bin
LDFLAGS := $(SDL_LDFLAGS)
endif

# ***********************************************************************************
#
#											Common Build
#
# ***********************************************************************************

APPNAME = testbed$(APPSTEM)

SOURCES = 	framework$(S)main.o framework$(S)gfx.o framework$(S)debugger.o \
			src$(S)sys_processor.o src$(S)sys_debug_superboard.o src$(S)hardware.o
  
CC = g++

.PHONY: all clean emulator prebuild final

all: emulator
	$(CDEL) memory.dump $(CDELQ)
	64tass -q -o test.prg test.asm 
	$(CCOPY) $(APPNAME) ..$(S)..$(S)bin

emulator: 6502$(S)__6502opcodes.h include$(S)monitor_rom.inc $(APPNAME)

%.o:%.cpp
	$(CC) $(CXXFLAGS) -c -o $@ $<
	
clean:
	$(CDEL) $(APPNAME) 
	$(CDEL) src$(S)*.o 
	$(CDEL) framework$(S)*.o

6502$(S)__6502opcodes.h: 
	$(CMAKE) -C ..$(S)processor

include$(S)/monitor_rom.inc:
	$(CMAKE) -C ..$(S)roms

$(APPNAME): $(SOURCES)
	$(CC) $(SOURCES) $(LDFLAGS) -o $@
	

