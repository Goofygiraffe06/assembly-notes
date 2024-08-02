%include	'stdlib.asm'

SECTION .data
	msg1	db	'Namste gois', 0Ah
	msg2	db	'Wassup dawwwwggg', 0Ah

SECTION .text
global _start:

_start:
	mov	eax, msg1
	call	sprint

	mov	eax, msg2
	call	sprint

	mov	ebx, 0		; The programmer can control the exit code by moving the required return code ebx register
	call	exit

; Expected Behaviour -  Our second message is outputted twice.
