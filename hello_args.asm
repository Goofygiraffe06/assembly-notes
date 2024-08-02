%include	'stdlib.asm'

SECTION .text
global _start:

_start:
	pop	ecx		; ecx is a general purpose register, but also a counter register it has the count of arguments


args:
	cmp	ecx, 0h		; we are checking if the number of arguments is not 0
	jz	quit		; if yes, smoothly exit
	pop	eax		; we are popping the argument from the stack
	call	sprintl		; Print it to STDOUT
	dec	ecx		; Decrement the arguments count
	jmp	args		; reiterate until there are no arguments left

quit:
	mov	ebx, 0
	call	exit

; Notes - In NASM arguments are stored in a stack in reverse order, so the last two elements on the stack are going to be num of args

; Diagram of how the stack looks like:

;      -----------------
;      |   count_args  |	-> stack[4]
;      -----------------
;	       |
;      -----------------
;      |   main_prog   |	-> stack[3]
;      -----------------
;              |
;      -----------------
;      |      arg0     |	-> stack[2]
;      -----------------
;              |
;      -----------------
;      |      arg1     |	-> stack[1]
;      -----------------
;              | 
;      -----------------	
;      |     argn      |	-> stack[0]
;      -----------------

