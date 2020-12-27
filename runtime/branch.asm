; ***************************************************************************************************************
; ***************************************************************************************************************
;
;      Name:       branch.asm
;      Purpose:    Branch commands
;      Created:    27th December 2020
;      Author:     Paul Robson (paul@robsons.org.uk)
;
; ***************************************************************************************************************
; ***************************************************************************************************************

; ***************************************************************************************************************
;
;										9x BRA Branch Always
;
; ***************************************************************************************************************

Command_BRA:
		lda 	instr+1 					; needs sign extend.
		and 	#$08 						; if bit 11 is set.
		beq 	+
		lda 	instr+1
		ora 	#$F0
		sta 	instr+1
+		
		clc 								; now add to the pctr
		lda 	instr
		adc 	pctr
		sta 	pctr
		lda 	instr+1
		adc 	pctr+1
		sta 	pctr+1

		jmp 	execLoop

; ***************************************************************************************************************
;
;										Ax BEQ Branch equal zero
;
; ***************************************************************************************************************

Command_BEQ:
		lda 	register
		ora 	register+1
		beq 	Command_BRA
		jmp 	execLoop

; ***************************************************************************************************************
;
;										Bx BPL Branch positive
;
; ***************************************************************************************************************

Command_BPL:
		lda 	register+1
		bpl 	Command_BRA
		jmp 	execLoop
