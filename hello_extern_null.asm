%include	'stdlib.asm'

SECTION .data
	msg1	db	'Namste gois', 0Ah, 0h		; 0h is null terminating byte
	msg2	db	'Wassup dawwwwggg', 0Ah, 0h

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
; This is fixed now, due to null terminating character 

; In assembly, variables are stored one after another in memory so the last byte of our msg1 variable is right next to the first byte of our msg2 variable. 
; We know our string length calculation is looking for a zero byte so unless our msg2 variable starts with a zero byte it keeps counting as if it's the same string
; So we need to put a zero byte or 0h after our strings to let assembly know where to stop counting. 	
