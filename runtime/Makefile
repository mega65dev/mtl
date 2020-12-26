
.PHONY: prebuild xemu fpga test

ASSEMBLER = acme
ASMCMD = -f cbm --cpu m65 -o main.prg -r main.lst main.asm

test : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=2 $(ASMCMD)
	../bin/testbed main.prg
	rm -f dump.mem memory.dump

xemu : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=1 $(ASMCMD)
	../bin/xmega65.native -prg main.prg -besure
	rm -f dump.mem memory.dump

fpga : $(wildcard *.asm)
	$(ASSEMBLER) -Dtarget=1 $(ASMCMD)
	../bin/m65 -F -r main.prg
	rm -f dump.mem memory.dump
	
