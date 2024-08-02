%include	'stdlib.asm'

SECTION .text
global _start:

_start:

	mov	ecx, 0		; Initializing the count register with 0

next_num:
	inc	ecx		; Increment the ecx for first num
	mov	eax, ecx	; moving the int to eax for iprint
	call	iprintl		; Calling iprintl function
	cmp	ecx, 10		; If the ecx has reached 10
	jne	next_num	; no, jmp to next_num
	
	mov	ebx, 0		; set return code
	call	exit		; smoothly exit
