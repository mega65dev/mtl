; ***************************************************************************************************************
; ***************************************************************************************************************
;
;      Name:       exec.asm
;      Purpose:    Execute the runtime
;      Created:    27th December 2020
;      Author:     Paul Robson (paul@robsons.org.uk)
;
; ***************************************************************************************************************
; ***************************************************************************************************************

; ***************************************************************************************************************
;
;									Run a code routine following the call
;
; ***************************************************************************************************************

execRuntime
		clc
		pla 								; get the start address from the call + 1
		adc 	#1 							; RTS post increments on return.
		sta 	pctr
		pla
		adc 	#0
		sta 	pctr+1

execLoop
		ldy 	#0 							; get instruction (Hi/Lo order)
		lda 	(pctr),y
		sta 	instr+1
		iny
		lda 	(pctr),y
		sta 	instr
		;
		jsr 	ShowDebugInfo 				; current state if debugging
		;
		lda 	pctr 						; bump pctr
		clc 
		adc 	#2
		sta 	pctr
		bcc 	+
		inc 	pctr+1
+


		lda 	instr+1 					; get instr MSN and double it, so shift right thrice.
		lsr
		lsr
		lsr
		and 	#$1E 						; force into range
		tax

		lda 	execTable,x 				; get address and go there.
		sta 	temp0
		lda 	execTable+1,x
		sta 	temp0+1

		jmp 	(temp0)

execTable
		!word 	Command_LDR  				; $0x Load Register
		!word 	Command_STR  				; $1x Store Register
		!word 	Command_ADD 				; $2x Add to Register
		!word 	Command_SUB 				; $3x Sub from Register
		!word 	notImplemented 				; $4x
		!word 	notImplemented 				; $5x
		!word 	Command_AND 				; $6x And into Register
		!word 	Command_ORR 				; $7x Or with Register
		!word 	Command_XOR 				; $8x Xor into Register
		!word 	Command_BRA 				; $9x Branch always
		!word 	Command_BEQ 				; $Ax Branch zero
		!word 	Command_BPL 				; $Bx Branch positive
		!word 	notImplemented 				; $Cx
		!word 	notImplemented 				; $Dx
		!word 	notImplemented 				; $Ex
		!word 	notImplemented 				; $Fx

notImplemented								; come here when not implemented.
		ldx 	#$EE
		txa
		tay
		see
halt
		jmp 	halt