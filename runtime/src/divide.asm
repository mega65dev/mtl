; *******************************************************************************************
; *******************************************************************************************
;
;       File:           divide.asm
;       Purpose:        Divide and Modulus code
;      	Created:    	27th December 2020
;       Author:         Paul Robson (paul@robson.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;							5x DIV - Divide into register
;
; *******************************************************************************************

Command_DIV:
		jsr 	EffectiveAddress 			; but value into temp1
		lda 	(eac),y
		sta 	temp0+1
		lda 	(eac,x)
		sta 	temp0
		jsr 	Divide
		jmp 	execLoop

; *******************************************************************************************
;
;							register := register / temp0, mod in temp1
;
; *******************************************************************************************

;
;	register = Q temp0 = M temp1 = A
;
Divide:
		lda 	#0 							; set A = 0
		sta 	temp1
		sta 	temp1+1
		ldy 	#16 						; loop round 16 times.
_DivLoop:
		asl 	register 					; shift QA left. Q first
		rol 	register+1
		;
		rol 	temp1 						; shift A left carrying in.
		rol 	temp1+1		
		;
		sec 								; calculate A-M, result in XA/C
		lda 	temp1
		sbc 	temp0
		tax
		lda 	temp1+1
		sbc 	temp0+1
		bcc 	_DivNoUpdate 				; if A >= M then store result and set Q bit 0.
		;
		sta 	temp1+1
		stx 	temp1
		inc 	register 					; we know it is even.
		;
_DivNoUpdate:		
		dey
		bne 	_DivLoop
		rts
