%include 'stdlib.asm'

SECTION .data
	num1	db	'First Number: ', 0
    	num2	db	'Second Number: ', 0
    	msg1	db	'Addition: ', 0
    	msg2	db	'Subtraction: ', 0
    	msg3	db	'Multiplication: ', 0
    	msg4	db	'Division: ', 0
    	msg5	db	'Remainder: ', 0

SECTION .text
global _start

_start:
	mov	ecx, 50
    	mov	edx, 5

    	; Print first number
    	mov	eax, num1
    	call	sprint
    	push	eax
    	mov	eax, ecx
    	call	iprintl
    	pop	eax

    	; Print second number
    	mov	eax, num2
    	call	sprint
    	push	eax
    	mov	eax, edx
    	call	iprintl
    	pop	eax

add_func:
    	; Perform addition and print result
    	mov	eax, msg1
    	call	sprint
    	push	ecx
    	add	ecx, edx
    	mov	eax, ecx
    	call	iprintl
    	pop	ecx

sub_func:
    	; Perform subtraction and print result
    	mov	eax, msg2
    	call	sprint
    	push	ecx
    	sub	ecx, edx
    	mov	eax, ecx
    	call	iprintl
    	pop	ecx

mul_func:
    	; Perform multiplication and print result
    	mov	eax, msg3
    	call	sprint
    	push	ecx
    	imul 	ecx, edx
    	mov 	eax, ecx
    	call 	iprintl
    	pop 	ecx
	
div_func:
	; Perform division and print result
	mov 	eax, msg4
	call 	sprint

	push	eax         	; Save message for printing remainder later

	mov 	eax, ecx    	; Save dividend (first number) in eax
	mov 	ebx, edx    	; Save divisor (second number) in ebx
	xor 	edx, edx    	; Clear edx before division
	div 	ebx         	; Divide eax by ebx (dividend by divisor)
	call 	iprintl     	; Print the quotient (result of division)

	pop 	eax         	; Restore message for printing remainder
	mov	eax, msg5
	call 	sprint

	; Print remainder
	mov 	eax, edx    	; Remainder is already in edx
	call 	iprintl


    	; Exit the program
    	mov 	ebx, 0
    	call 	exit

