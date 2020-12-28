; ***************************************************************************************************************
; ***************************************************************************************************************
;
;      Name:       data.asm
;      Purpose:    MTL Runtime ZP Allocation, Macros etc.
;      Created:    26th December 2020
;      Author:     Paul Robson (paul@robsons.org.uk)
;
; ***************************************************************************************************************
; ***************************************************************************************************************
	

; ***************************************************************************************************************
;
;										Zero Page Allocation
;
; ***************************************************************************************************************

pctr = zeroPageStart						; program counter (address of instruction)

register = zeroPageStart+2 					; current register value.

eac = zeroPageStart+4 						; effective address calculation.

instr = zeroPageStart+6 					; current instruction.

temp0 = zeroPageStart+8 					; working registers.

temp1 = zeroPageStart+10 

nextFreeZero = zeroPageStart + 16 			; memory we can use.

; ***************************************************************************************************************
;
;												Macros
;
; ***************************************************************************************************************

!macro set16 .addr,.value {
		lda 	#((.value) & $FF)
		sta 	0+(.addr)
		lda 	#((.value) >> 8)
		sta 	1+(.addr)	
}

!macro 	inc16 .addr {
		inc 	0+(.addr)
		bne 	+
		inc 	1+(.addr)
+
}

!macro cmd 	.cmdid,.addr {
		!byte 	(.cmdid << 4)+((.addr >> 8) & 0x0F)
		!byte 	(.addr & $FF)
}		

!macro call .addr {
		!byte 	((.addr >> 10) & $3F)+$C0
		!byte 	(.addr >> 2) & $FF		
}

!macro define .name,.count,.first {
		!word 	0 							; link to next (filled in later)
		!byte 	.count 						; number of parameters
		!byte 	.first 						; first parameter address if more than one (last in R)
		!text 	.name,0 					; ASCIIZ name.
		!align 	3,0 
}