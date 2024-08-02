%include	'stdlib.asm'

SECTION	.data
	parent	db	'Hello, from parent process', 0h
	child	db	'Hello, from child process', 0h

SECTION .text
global _start:

_start:

	mov	eax, 2		; Kernel opcode for fork
	int	80h		; System interrupt
	cmp	eax, 0		; Check if we have a child proces
	jz	.child		; if yes, jump!

.parent:

	mov	eax, parent
	call	sprintl

	call	exit

.child:

	mov	eax, child
	call	sprintl
	call	exit
