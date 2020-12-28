; *******************************************************************************************
; *******************************************************************************************
;
;       File:           multiply.asm
;       Purpose:        Multiply code
;      	Created:    	27th December 2020
;       Author:         Paul Robson (paul@robson.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;							4x MUL - Multiply into register
;
; *******************************************************************************************

Command_MUL:
		jsr 	EffectiveAddress 			; but value into temp1
		lda 	(eac),y
		sta 	temp1+1
		lda 	(eac,x)
		sta 	temp1
		lda 	register 					; register into temp0 and multiply.
		sta 	temp0
		lda 	register+1
		sta 	temp0+1
		jsr 	Multiply
		jmp 	execLoop

; *******************************************************************************************
;
;								register := temp0 * temp1
;
; *******************************************************************************************

Multiply:
		lda 	#0 							; zero total.
		sta 	register
		sta 	register+1
_MultLoop:
		lsr 	temp0+1
		ror 	temp0	
		bcc 	_MultNoAdd
		clc
		lda 	temp1		
		adc 	register
		sta 	register
		lda 	temp1+1
		adc 	register+1
		sta 	register+1
_MultNoAdd:
		asl 	temp1
		rol 	temp1+1
		lda 	temp0
		ora 	temp0+1
		bne 	_MultLoop
		rts
