
zeroPage = 0
myTemp4 = $FC  

        *=$2001
        !word   endLine
        !word   1
        !byte   $fe,$02
        !text   "0:"
        !byte   $9e
        !text   "8224"
        !byte   0
        !word   0
endLine   

        *=$2020
        sei
        lda     #$35
        sta     $01

        lda     #$00
        tax 
        tay 
        taz 
        map
        eom

        lda     #$40
        tab
        jmp     start

PrintCharacter
        pha
        phx
        phz

        ldx     charPos
        ldz     charPos
        inc     charPos
        sta     $0800,x

        lda     #$00
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
