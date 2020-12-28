; *******************************************************************************************
; *******************************************************************************************
;
;       File:           call.asm
;       Purpose:        Call and Return
;      	Created:    	28th December 2020
;       Author:         Paul Robson (paul@robson.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;									CALL routine
;
; *******************************************************************************************

Command_CALL:
		lda 	pctr 						; push PC on stack
		pha
		lda 	pctr+1
		pha
		;
		asl 	instr 						; instr x 4 => address
		rol 	instr+1
		asl 	instr
		rol 	instr+1
		lda 	instr 						; copy to vector
		sta 	vector
		lda 	instr+1
		sta 	vector+1
		jsr 	_CCCallInstr 				; call that routine.
		;
		pla 								; restore PC
		sta 	pctr+1
		pla
		sta 	pctr
		jmp 	execLoop 					; and go round

_CCCallInstr:
		jmp 	(vector)						

; *******************************************************************************************
;
;										Return Code
;
; *******************************************************************************************

		+define	"sys.return",0,0
ReturnCode:
		pla 								; remove JSR to exec routine, call to return code.
		pla
		pla 		
		pla
		rts

; *******************************************************************************************
;
;										Halt Code
;
; *******************************************************************************************

		+define "sys.halt",0,0
HaltCode:		
		lda 	#42
		jsr 	PrintCharacter
		ldx 	#$EE
		txa
		tay
		see
HaltNow:
		jmp 	HaltNow

; *******************************************************************************************
;
;											Print 
;
; *******************************************************************************************

		+define	"sys.print.hex",1,0
PrintHexCode:		
		lda 	register+1
		jsr 	PrintHex		
		lda 	register
		jsr 	PrintHex
		rts

