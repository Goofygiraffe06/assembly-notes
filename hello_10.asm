%include	'stdlib.asm'

SECTION .text
global _start:

_start:

	mov	ecx, 0

print:
	 inc	ecx

	mov	eax, ecx
	add	eax, 48
	push	eax
	mov	eax, esp
	call	sprintl
	pop	eax
	cmp	ecx, 9
	jne	print
	
	mov	ebx, 0
	call	exit
