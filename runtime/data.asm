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

temp0 = zeroPageStart+8 					; target address.

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
