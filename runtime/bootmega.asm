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
	phz

	ldx     charPos                         ; Z X offset into first 256 chars
	ldz     charPos
	inc     charPos
	and     #63                             ; handle PETSCII
	sta     $0800,x

	lda     #$00                            ; write colour to $01F800 (Color RAM)
	sta     myTemp4
	lda     #$F8
	sta     myTemp4+1
	lda     #$01
	sta     myTemp4+2
	lda     #$00
	sta     myTemp4+3
	lda     #$01
	sta     [myTemp4],z
	plz
	plx
	pla
	rts

charPos
	!byte   0

