
    !if target=1 {
    !source "bootmega.asm"
    } else {
    !source "boottest.asm"
    }

start
        lda     #42
        jsr     PrintCharacter
halt
        adc     #1
        and     #127
        jsr     PrintCharacter
        jmp     halt

