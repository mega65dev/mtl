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
    } else {
    !source "boottest.asm"
    }

start
        ldx     #0
        lda     #42
        sta     $FFC2
loop    lda     $2020,x
        jsr     PrintHex
        lda     #' '
        jsr     PrintCharacter
        inx
        cpx     #32
        bne     loop        
halt
        jmp     halt

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


