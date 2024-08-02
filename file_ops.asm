%include	'stdlib.asm'

SECTION	.data
	msg1		db	'Creating file funi.txt in current directory...', 0h
	msg2		db	'Writing wadup dawgg to funi.txt...', 0h
	msg3		db	'Reading from the file funi.txt...', 0h
	msg4		db	'Closing file funi.txt...', 0h
	filename	db	'funi.txt', 0h
	contents	dd	'wadup dawgg!', 0Ah, 0h

SECTION .bss
	buffer		resb	255	

SECTION .text
global _start:

_start:

	mov	eax, msg1
	call	sprintl

create_file:

	; Create a new file
	mov	ebx, filename		; ebx register takes filename
	mov	ecx, 0666o		; ecx register consists of file perms (https://chmod-calculator.com/)
	mov	eax, 8			; Kernel opcode for SYS_CREAT
	int	80h			; System Interrupt

write_file:

	; Writing to a file
	push	eax			; Preserve the contents of eax reg using stack
	mov	eax, msg2		; print the debug message to STDOUT
	call	sprintl			
	mov	eax, contents		; move the contents to eax to get the data lenght
	call	slen			; call the appropriate subroutine
	mov	edx, eax		; move the resultant data to edx (data) register
	mov	ecx, contents		; move the address of contents to ecx
	pop	eax			; restore the value of eax, it contains file descriptor
	mov	ebx, eax		; move it to ebx register
	mov	eax, 4			; Kernel opcode for SYS_WRITE
	int	80h			; System Interrupt
	
open_file:

	; open from a file
	; ecx reg tells us how we want to open the file
	; 0 - read only, 1 - write only, 2 - write only
	; when a file is opened eax reg will contain the file descriptor
	mov	eax, msg3
	push	sprintl
	mov	ecx, 2			; Open the file in read and write mode
	mov	ebx, filename		; move the filename to ebx register
	mov	eax, 5			; Kernel opcode for SYS_OPEN
	int	80h			; System interrupt

read_file:

	; Reading from a file
	push	eax
	mov	eax, msg3
	call	sprintl
	pop	eax
	mov     edx, 12             	; number of bytes to read 
    	mov     ecx, buffer   	    	; move the memory address to store contents of file 
   	mov     ebx, eax            	; move the opened file descriptor into EBX
   	mov     eax, 3              	; invoke SYS_READ (kernel opcode 3)
    	int     80h                 	; call the kernel
 	
	push	eax
	mov	eax, buffer
	call	sprintl
	pop	eax

seek_file:

	mov	ebx, eax		; move file descriptor
	mov	edx, 2			; writing at file end
	mov	ecx, 0			; move the cursor 1 byte so we can have a space
	mov	eax, 19			; Kernel opcode for SYS_LSEEK
	int	80h

	mov	edx, 12			; write 4 bytes
	mov	ecx, contents		; Write lmao to the cursor
	mov	eax, 4			; Kernel opcode for SYS_WRITE
	int	80h

close_file:
	mov	eax, msg4
	call	sprintl
	pop	eax
	mov	eax, 6
	int 	80h

delete_file:

	mov	ebx, filename
	mov	eax, 10
	int 	80h

quit:
	; Program exit	
	xor	ebx, ebx		; clear ebx reg
	call	exit			; exit smoothly

