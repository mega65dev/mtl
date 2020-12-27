; ***************************************************************************************************************
; ***************************************************************************************************************
;
;      Name:       bootmega.asm
;      Purpose:    MTL Runtime, specific Mega65 code
;      Created:    26th December 2020
;      Author:     Paul Robson (paul@robsons.org.uk)
;
; ***************************************************************************************************************
; ***************************************************************************************************************

myTemp4 = $02                                   ; temp far pointer

zeroPageStart = $10                             ; zero page allocation here.

variableMax = 32 								; how many variables allowed in test version

; ***************************************************************************************************************
;
;                                               Header, a BASIC line
;
; ***************************************************************************************************************

boot						
	sei                                     ; disable Interrupts
	lda     #$35                            ; C64 RAM visibility/tape off. 
	sta     $01

	lda     #$00                            ; Reset mapping - lower/upper offsets = 0
	tax                                     ; so everything except $Dxxx RAM ?
	tay 
	taz 
	map
	eom

	lda     #$FE                            ; use page $FExx as ZP.
	tab
	jmp     runApplication

; ***************************************************************************************************************
;
;                                               Print Character A
;
; ***************************************************************************************************************

PrintCharacter
	pha
	phx
	phy
	phz

	and     #63                             ; handle PETSCII
	pha

	lda 	charPos
	sta 	myTemp4
	lda 	charPos+1
	clc
	adc 	#$08
	sta 	myTemp4+1
	pla
	ldy 	#0
	sta 	(myTemp4),y

				                            ; write colour to $01F800 (Color RAM)
	clc
	lda 	charPos+1
	adc 	#$F8
	sta     myTemp4+1
	lda     #$01
	sta     myTemp4+2
	lda     #$00
	taz
	sta     myTemp4+3
	lda     #$01
	sta     [myTemp4],z

	inc 	charPos
	bne 	_PCNoCarry
	inc 	charPos+1
_PCNoCarry
	lda 	charPos
	cmp 	#$D0
	bne 	_PCExit
	lda 	charPos+1
	cmp 	#7
	bne 	_PCExit


	lda 	#0
	sta 	charPos
	sta 	charPos+1
_PCExit:	
	plz
	ply
	plx
	pla
	rts

charPos
	!word 	0

