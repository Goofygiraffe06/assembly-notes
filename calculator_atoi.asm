%include	'stdlib.asm'

SECTION .data
	msg	db	'The sum of arguments: ', 0h

SECTION .text
global _start:

_start:

	pop	ecx		; The number of arguments passed during execution
	pop	edx		; Discarding the second argument, it contains the program name
	
	dec	ecx		; Decrement the count register because we removed the program name from the stack
	xor	edx, edx	; Clear the edx (data) register to store additions in future

.next:
	cmp	ecx, 0h		; Check if the total number of arguments is 0
	jz	.finish		; if yes, then jump to finish label
	pop	eax		; store the first argument in eax register
	call	atoi		; call the atoi to convert string number to integer
	add	edx, eax	; Adding the resultant integer to edx (data) register
	dec	ecx
	jmp	.next

.finish:
	
	mov	eax, msg
	call	sprint
	mov	eax, edx
	call	iprintl

	mov	ebx, 0
	call	exit

