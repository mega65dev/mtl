ifeq ($(OS),Windows_NT)
CCOPY = copy
CMAKE = mingw32-make
CDEL = del /Q
S = \\
else
CCOPY = cp
CDEL = rm -f
CMAKE = make
S = /
endif

.PHONY: all 

all : cegmon.rom 
#	$(CCOPY) basic.rom ..$(S)emulator$(S)basic.rom
	python export.py
	
cegmon.rom : cegmon.asm
	64tass -Werror -q -c -b -o $@ -L cegmon.lst $<
	#$(CCOPY) cegmon.rom ..$(S)emulator$(S)monitor.rom

