; ***************************************************************************************************************
; ***************************************************************************************************************
;
;      Name:       main.asm
;      Purpose:    MTL Runtime
;      Created:    26th December 2020
;      Author:     Paul Robson (paul@robsons.org.uk)
;
; ***************************************************************************************************************
; ***************************************************************************************************************

	!if target=1 {
	!source "bootmega.asm"
	} 
	!if target=2 {
	!source "boottest.asm"
	}

	!src 	"data.asm"

; ***************************************************************************************************************
;
;					Runtime Header starts here (if not run in test handler, target #0)
;
; ***************************************************************************************************************

start
		jmp 	runApplication 				; +0  is jump to initial code
		!byte 	0
		jmp 	$0000 						; +4  is opcode execution routine
		!byte 	0
		!word	$0000 						; +8  is the address of the first procedure.
		!word 	start  						; +10 is the load address
		!word 	UnnitialisedVariables 		; +12 is the start of the uninitialised variables.
		!word 	EndVariableSpace 			; +14 is the end of the uninitialised variables.

; ***************************************************************************************************************
;
;									Runtime code starts here
;
; ***************************************************************************************************************

		* = start+64

runApplication		
		ldx 	#$FF
		txs
		+set16 	pctr,1042
		+inc16  pctr
		ldx     #0
		lda     #42
		sta     $FFC2 
loop    lda     $2020,x
		jsr     PrintHexSpace
		inx
		cpx     #32
		bne     loop        
halt
		jmp     halt

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

; ***************************************************************************************************************
;
;						Testing code goes here (this is for non runtime builds)
;
; ***************************************************************************************************************

CodeSpace:

; ***************************************************************************************************************
;
;					Then the variables with predefined values, constants, addresses etc.
;
; ***************************************************************************************************************

		!align 	255,0 						; put on page boundary.
SystemVariables:

; ***************************************************************************************************************
;
;									Then the uninitialised variables
;
; ***************************************************************************************************************

UnnitialisedVariables:
		!if target > 0 { 					; allocate memory if not runtime build.
			!fill 	variableMax * 2,$FF
		}

EndVariableSpace:
