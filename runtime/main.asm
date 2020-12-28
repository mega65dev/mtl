; ***************************************************************************************************************
; ***************************************************************************************************************
;
;      Name:       main.asm
;      Purpose:    MTL Runtime (slow 'n' lazy version, NMOS 6502 only no optimisation)
;      Created:    26th December 2020
;      Author:     Paul Robson (paul@robsons.org.uk)
;
; ***************************************************************************************************************
; ***************************************************************************************************************

zeroPageStart = $10                             ; zero page allocation here.

		!src 	"src/data.asm"

; ***************************************************************************************************************
;
;					Runtime Header starts here (if not run in test handler, target #0)
;
; ***************************************************************************************************************

start
		jmp 	boot 						; +0  is jump to initial code
		!byte 	0
execRoutine		
		jmp 	execRuntime 				; +4  is opcode execution routine
		!byte 	0

firstProcedure		
		!word	codeSpace 					; +8  is the address of the first procedure.

loadAddress		
		!word 	start  						; +10 is the load address

initStart
		!word 	UnnitialisedVariables 		; +12 is the start of the uninitialised variables.

initEnd
		!word 	EndVariableSpace 			; +14 is the end of the uninitialised variables.

registerAddress
		!word 	register					; +16 is the address of the register

nextFreeZeroAddress 	 						
		!word 	nextFreeZero				; +18 next free zp address.

routineList 								
		!word 	0							; +20 linked list of routines built in/library.

		* = start+64

; ***************************************************************************************************************
;
;								Import the system specific code
;
; ***************************************************************************************************************

		!if target=1 {
		!source "src/bootmega.asm"
		} 
		!if target=2 {
		!source "src/boottest.asm"
		}

; ***************************************************************************************************************
;
;									Runtime code starts here
;
; ***************************************************************************************************************

runApplication		
		ldx 	#$FF 						; reset the 6502 stack.
		txs
		jsr 	ClearMemory 				; erase all memory.
		jsr 	runFirstProc 				; run the first procedure
halted:	jmp 	halted		 				; and stop.

runFirstProc		
		jmp 	(firstProcedure) 			; execute the first procedure

; ***************************************************************************************************************
;
;											Includes
;
; ***************************************************************************************************************

		!src 	"src/exec.asm"
		!src 	"src/simple.asm"
		!src 	"src/multiply.asm"
		!src 	"src/divide.asm"
		!src 	"src/branch.asm"
		!src 	"src/call.asm"
		!src 	"src/utility.asm"

; ***************************************************************************************************************
;
;						Testing code goes here (this is for non runtime builds)
;
; ***************************************************************************************************************

codeSpace:
		jsr 	execRuntime
		+cmd 	0,1
		+call 	cs2
		+call 	cs2
		+call 	cs2
		+call 	PrintHexCode
		+call 	PrintHexCode
		+call	HaltCode

		!align 	3,0
cs2		
		jsr 	execRuntime
		+cmd 	4,2
		+call 	ReturnCode

; ***************************************************************************************************************
;
;					Then the variables with predefined values, constants, addresses etc.
;
; ***************************************************************************************************************

		!align 	255,0 						; put on page boundary.
SystemVariables:
		!word 	10000
		!word 	2
		!word 	10

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
