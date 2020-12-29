ifeq ($(OS),Windows_NT)
CCOPY = copy
CMAKE = mingw32-make
CDEL = del /Q
CDELQ = >NUL
APPSTEM = .exe
DEVICE = -l COM4
S = \\
else
CCOPY = cp
CDEL = rm -f
CDELQ = 
CMAKE = make
APPSTEM =
S = /
DEVICE =
endif

.PHONY: prebuild xemu fpga test

ASSEMBLER = acme
ASMCMD = -f cbm --cpu m65 -o main.prg -r main.lst main.asm

test : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=2 --setpc 8448 $(ASMCMD)
	python buildlist.py
	../bin/testbed main.prg go
	$(CDEL) dump.mem memory.dump $(CDELQ)

xemu : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=1 --setpc 8448 $(ASMCMD)
	python buildlist.py
	python addheader.py main.prg
	../bin/xmega65 -prg main.prg -besure
	$(CDEL) dump.mem memory.dump $(CDELQ)

fpga : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=1 --setpc 8448 $(ASMCMD)
	python buildlist.py
	python addheader.py main.prg
	../bin/m65 $(DEVICE) -F -r main.prg
	$(CDEL) dump.mem memory.dump $(CDELQ)
	
