
; Compiled on Linux (x86_64)
; Author: giraffe
; Kernel: 6.9.6-arch1-1
; Date: 2024-07-03 19:44:44
; File: crawler.asm
; Compiler: nasm (NASM version 2.16.03 compiled on May  4 2024)

%include 'stdlib.asm'

SECTION .data
	err 	db	'AN ERROR OCCURED! TIME TO GDB', 0h
	msg1	db	'Connected...', 0h
	; request headers
	req	db	'GET / HTTP/1.1', 0Dh, 0Ah, 'Host: 139.162.39.66:80', 0Dh, 0Ah, 0Dh, 0Ah, 0h

SECTION .bss
	buff	resb	1024	

SECTION .text
global _start

_error:
	mov	eax, err		; move the address of the error message
	call	sprintl			; Print the error message to the stdout
	xor 	ebx, ebx		; Setting the return code to 0 - Check stdlib.asm (ebx is used to control the return code on exit)
	call	exit			; Call the exit subroutine

_start:
	; Initialise all the registers 

	xor	eax, eax
	xor 	ebx, ebx
	xor 	ecx, ecx
	xor 	edx, edx

_socket:
	; We are going to create our socket 
	; int socket(int domain, int type, int protocol)

	push	byte 6			; IPPROTO_TCP - The protocol we are going to be using for the connection
	push	byte 1			; SOCK_STREAM - It specifies the socket type for the connection (here TCP)
	push 	byte 2			; AF_INET - It is the domain that the socket created is going to be using
					; for communicating, AF_INET is for IPv4 addresses
	
	mov	ecx, esp		; Moving the address of array of arguments to ecx register
	mov	ebx, 1			; Invoking the SOCKET subroutine
	mov	eax, 102		; Kernel opcode for SYS_SOCKETCALL
	int	80h			; System Interrupt

_connect:
	; This subroutine is responsible for connecting to the website to get the data from 
	; 
	
	mov	edx, eax		; Move the file descriptor to edi register
	push	dword 0x00000000	; pushing the IP Address to the stack
	push	word 0x5000		; Pushing the Port for the socket to bind
	push	word 2			; Telling that we are using IPv4 format (AF_INET)
	mov	ecx, esp		; Moving the array of arguments arguments to ecx register
	push	byte 16			; Size of the arguments
	push	ecx			; Push the address of the arguments on to the stack
	push	edx			; Push the file descriptor into the stack
	mov	ecx, esp		; Moving the address of stack to the ecx register
	mov	ebx, 3			; Invoking the BIND subroutine
	mov	eax, 102		; Kernel opcode for SYS_SOCKETCALL
	int	80h			; System Interrupt

	cmp	eax, 0			; Compare the file descriptor
	jnge	_error			; This is important because ports can be used by someother services during bind
	push	eax			; Preserve the file descriptor
	mov	eax, msg1
	call	sprintl			; Print the bind successful message
	pop	eax			; Restore the file descriptor


