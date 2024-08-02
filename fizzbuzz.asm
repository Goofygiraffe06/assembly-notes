%include	'stdlib.asm'

SECTION .data
	fizz	db	'Fizz', 0h
	buzz	db	'Buzz', 0h

SECTION .text
global _start:

_start:

	; Initialize variables
	mov	esi, 0		; Source Index register
	mov	edi, 0		; Data register 
	mov	ecx, 0		; Counter register

.continue
	cmp	ecx, 16000
	jne	.next_num
	mov	ebx, 0
	call	exit	

.next_num:

	inc	ecx

.check_fizzbuzz:
	xor	edx, edx
	mov	eax, ecx
	mov	ebx, 15
	div	ebx
	mov	edi, edx
	cmp	edi, 0
	jne	.check_fizz
	mov	eax, fizz
	call	sprint
	mov	eax, buzz
	call	sprintl
	jmp	.continue

.check_fizz:

	xor	edx, edx	; Clear the register, this is used to hold the remainder after division
	mov	eax, ecx	; Move the number from ecx to eax for division
	mov	ebx, 3		; We are going to divide by 3
	div	ebx		; divide the number by 3
	mov	edi, edx	; Move data from edx (data) register to edi (fizz boolean register)
	cmp	edi, 0		; If the remainder is 0, that means it is divisible by 3
	jne	.check_buzz
	mov	eax, fizz
	call	sprintl
	jmp	.continue

.check_buzz:

	xor	edx, edx
	mov	eax, ecx
	mov	ebx, 5
	div	ebx
	mov	edi, edx
	cmp	edi, 0
	jne	.print_int
	mov	eax, buzz
	call	sprintl
	jmp	.continue

.print_int:

	mov	eax, ecx
	call	iprintl
	jmp	.continue
