; SECTION .bss
; variableName1:      RESB    1       ; reserve space for 1 byte
; variableName2:      RESW    1       ; reserve space for 1 word
; variableName3:      RESD    1       ; reserve space for 1 double word
; variableName4:      RESQ    1       ; reserve space for 1 double precision float (quad word)
; variableName5:      REST    1       ; reserve space for 1 extended precision float



%include	'stdlib.asm'

SECTION .data
	msg1	db	'Enter your name: ', 0h
	msg2	db	'Hello, ', 0h

SECTION .bss
	buff	resb	255	; Reserving space for a variable of 255 bytes in memory

SECTION .text
global _start:

_start:

	mov	eax, msg1
	call	sprint		; Printing the initial message

	mov	edx, 255	; setting size_t paramter for SYS_READ
	mov	ecx, buff	; storing the buff mem address in ecx
	mov	ebx, 0		; FILE DESCRIPTOR (0 - SYS_READ)
	mov	eax, 3		; opcode for SYS_READ
	int	80h		; Interrupt for kernel

	mov	eax, msg2	; print 'Hello, '
	call	sprint

	mov	eax, buff	
	call	sprint		; print user input (buff)

	call	exit

