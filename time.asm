%include	'stdlib.asm'

SECTION .data
	msg	db	'UNIX time: ', 0h

SECTION	.text
global _start:

_start:	

	mov	eax, msg
	call	sprint
	
	mov	eax, 13		; Kernel opcode for SYS_TIME
	int	80h		; System Interrupt
	call	iprintl

	xor	ebx, ebx	; Clear the register ebx
	call	exit		; Smoothly exit
