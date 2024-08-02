%include	'stdlib.asm'

SECTION .data
	msg1	db	'Namste gois', 0h		; 0h is null terminating byte
	msg2	db	'Wassup dawwwwggg', 0h		; No more LF

SECTION .text
global _start:

_start:
	mov	eax, msg1
	call	sprintl		; Automatically LF is added

	mov	eax, msg2
	call	sprintl

	mov	ebx, 0		; The programmer can control the exit code by moving the required return code ebx register
	call	exit

