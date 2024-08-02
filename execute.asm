%include	'stdlib.asm'

SECTION	.data
	cmd	db	'/bin/ls', 0h
	arg	db	'-l', 0h
	env	db	0h

SECTION .text
global _start:

_start:
	
	; ebx - cmd, ecx - args, edx - env

	mov	ebx, cmd
	mov	ecx, arg
	mov	edx, env

	mov	eax, 11		; Kernel opcode for SYS_EXECV
	int 	80h

	mov	ebx, 0
	call	exit
