; ***************************************************************************************************************
; ***************************************************************************************************************
;
;      Name:       utility.asm
;      Purpose:    Utility routines
;      Created:    27th December 2020
;      Author:     Paul Robson (paul@robsons.org.uk)
;
; ***************************************************************************************************************
; ***************************************************************************************************************

; ***************************************************************************************************************
;
;											Erase data memory
;
; ***************************************************************************************************************

ClearMemory:
		lda 	initStart 					; start erasing from here
		sta 	temp0
		lda 	initStart+1
		sta 	temp0+1
		ldy 	#0		
_CLMLoop:
		lda 	temp0 						; done the lot ?
		cmp 	initEnd
		bne 	_CLMClear
		lda 	temp0+1
		cmp 	initEnd+1
		bne 	_CLMClear
		rts		
_CLMClear:
		tya 								; zero location and advance.
		sta 	(temp0),y
		inc 	temp0
		bne 	_CLMLoop
		inc 	temp0+1
		jmp 	_CLMLoop

; ***************************************************************************************************************
;
;										Show debug information
;
; ***************************************************************************************************************

ShowDebugInfo:
		lda 	pctr+1
		jsr 	PrintHexSpace
		lda 	pctr
		jsr 	PrintHex
		lda 	instr+1
		jsr 	PrintHexSpace
		lda 	instr
		jsr 	PrintHex
		lda 	register+1
		jsr 	PrintHexSpace
		lda 	register
		jsr 	PrintHex
		rts		

; ***************************************************************************************************************
;
;						PrintA as hex constant with/without leading space
;
; ***************************************************************************************************************

PrintHexSpace:
		pha
		lda 	#' '
		jsr 	PrintCharacter
		pla
PrintHex:        
		pha
		lsr     
		lsr     
		lsr     
		lsr     
		jsr     _PrintNibble
		pla
_PrintNibble:
		pha
		and     #15
		cmp     #10
		bcc     +
		adc     #6
+
		adc     #48
		jsr     PrintCharacter
		pla 
		rts
