SECTION .data
	msg	db 	'Namste, x86 Assembly', 0Ah

SECTION .text
global _start:

_start:

	mov	ecx, msg	; Loading the data into ecx register
	mov	eax, ecx	; Moving the address of ecx to eax register, so two registers poining at one mem location
					; So, the main idea is that we have a base pointer to the text location and then we 
					; increment each byte by comparing if the charecter at that index is not 0 and looping
					; and then subtract ecx from eax, so we will have the lenght of the data effectively.

count:

	cmp	byte[eax], 0
	jz	final
	inc	eax
	jmp	count

final:

	sub	eax, ecx	; Subtracting ecx from eax to determine size
	mov	edx, eax	; Moving the calculated size to edx
	mov	ecx, msg	; Address of the string
	mov	ebx, 1		; File Descriptor (1 - STDOUT)
	mov	eax, 4		; Syscall for SYS_WRITE
	int	80h			; Call Kernel
	mov eax, 1		; Syscall number for exit
	xor ebx, ebx	; Exit Code 0
	int 80h			; Call kernel 

