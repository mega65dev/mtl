
.PHONY: prebuild xemu fpga test

ASSEMBLER = acme
ASMCMD = -f cbm --cpu m65 -o main.prg -r main.lst main.asm

test : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=2 --setpc 8448 $(ASMCMD)
	../bin/testbed main.prg go
	rm -f dump.mem memory.dump

xemu : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=1 --setpc 8448 $(ASMCMD)
	python addheader.py main.prg
	../bin/xmega65.native -prg main.prg -besure
	rm -f dump.mem memory.dump

fpga : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=1 --setpc 8448 $(ASMCMD)
	python addheader.py main.prg
	../bin/m65 -F -r main.prg
	rm -f dump.mem memory.dump
	
