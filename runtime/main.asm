          *=$2001
          !word endLine
          !word 1
          !byte $fe,$02
          !text "0:"
          !byte $9e
          !text "8224"
          !byte 0
          !word 0
endLine   

            *=$2020

            sei

            tba
            pha
            lda   #$24
            tab

            lda #$35
            sta $01

            lda #$00
            tax 
            tay 
            taz 
            map
            eom

            lda   #$A0
            sta   $FC
            lda   #$F8
            sta   $FD
            lda   #$01
            sta   $FE

            jsr   $FFCF
            sta   $0800

            jsr printtext
            pla
            tab
            rts


printtext   ldx #$00
            ldy #0
            ldz #0
loop        lda .string,x
            beq exit
            sta $08A0,x
            lda  #42
            sta [$FC],z
            inx
            iny
            inz
            jmp loop
exit        rts

.string     !scr "hello world", 0
