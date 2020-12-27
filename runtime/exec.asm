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

		see	

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
		!word 	notImplemented 				; $0x
		!word 	notImplemented 				; $1x
		!word 	notImplemented 				; $2x
		!word 	notImplemented 				; $3x
		!word 	notImplemented 				; $4x
		!word 	notImplemented 				; $5x
		!word 	notImplemented 				; $6x
		!word 	notImplemented 				; $7x
		!word 	notImplemented 				; $8x
		!word 	notImplemented 				; $9x
		!word 	notImplemented 				; $Ax
		!word 	notImplemented 				; $Bx
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