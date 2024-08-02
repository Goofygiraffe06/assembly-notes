; Compiled on Linux (x86_64)
; Author: giraffe
; Kernel: 6.9.6-arch1-1
; Date: 2024-06-30 18:24:41
; File: sockets.asm
; Compiler: nasm (NASM version 2.16.03 compiled on May  4 2024)

; Socket Programming - create, bind, listen, accept, ewad, write, close
	
%include	'stdlib.asm'

SECTION .data
	msg1 db 'Socket Created Successfully!', 0h
	msg2 db 'Socket Bind Succesful', 0h
	msg3 db 'Socket is Now Listening for New Connections', 0h
	msg4 db 'Accepted a new client', 0h
	msg5 db '(netcat)> ', 0h
	error db 'An Error Occured! GDB-IT!!!', 0h
	; our response string
	resp db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 16', 0Dh, 0Ah, 0Dh, 0Ah, 'Hack The Planet!\n', 0Dh, 0Ah, 0h

SECTION .bss
	buffer resb 1024,   

SECTION .text
global  _start

_error:
	mov	eax, error
	call	sprintl
	xor 	ebx, ebx
	call 	exit

_start:
	; Clear all registers 
	xor	eax, eax
	xor	ebx, ebx
	xor 	ecx, ecx
	xor 	edx, edx
	
_socket:
	; Create a socket 
	; int socket(int domain, int type, int protocol)
	; Since the stack follows LIFO we need to start inserting from the last 
	; The ebx register takes a pointer to an array of argument. so, we load all them on to the stack and mov esp to ebx

	push	byte 6			; IPPROTO_TCP - The protocol we are going to be using for the connection
	push	byte 1			; SOCK_STREAM - It specifies the socket type for the connection (here TCP)
	push 	byte 2			; AF_INET - It is the domain that the socket created is going to be using
					; for communicating, AF_INET is for IPv4 addresses
	
	mov	ecx, esp		; Moving the address of array of arguments to ecx register
	mov	ebx, 1			; Invoking the SOCKET subroutine 
	mov	eax, 102		; Kernel opcode for SYS_SOCKETCALL
	int	80h			; System Interrupt	
	
	cmp	eax, 0			; Compare the file descriptor with 0
	jnge 	_error			; If the file descriptor is less than 0 or not positive then the unix failed to create a socket and we need to jump to the error subroutine and notify the user about the issue.
	push	eax 			; Preserve the file descriptor before it is used to print the success message	
	mov 	eax, msg1		; Print out the succes message
	call	sprintl
	pop	eax			; Restore the original value of register eax (file descriptor)

_bind:
	; Binds the created socket to a port
	; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)

	mov	edx, eax		; Move the file descriptor to edi register
	push	dword 0x00000000	; pushing the IP Address to the stack
	push	word 0x2923		; Pushing the Port for the socket to bind 
	push	word 2			; Telling that we are using IPv4 format (AF_INET)
	mov	ecx, esp		; Moving the array of arguments arguments to ecx register
	push	byte 16			; Size of the arguments
	push	ecx			; Push the address of the arguments on to the stack
	push	edx			; Push the file descriptor into the stack
	mov	ecx, esp		; Moving the address of stack to the ecx register
	mov	ebx, 2			; Invoking the BIND subroutine
	mov	eax, 102		; Kernel opcode for SYS_SOCKETCALL
	int	80h			; System Interrupt	
	
	cmp	eax, 0			; Compare the file descriptor 
	jnge	_error			; This is important because ports can be used by someother services during bind
	push	eax			; Preserve the file descriptor
	mov	eax, msg2
	call	sprintl			; Print the bind successful message
	pop	eax			; Restore the file descriptor

_listen:
	; Listens to incoming connections
	; int listen(int sockfd, int backlog)

	push	byte 1			; The max number of devices that can connect to this socket 	
	push	edx			; Push the file descriptor into the stack
	mov	ecx, esp		; Moving address of arguments to ecx register
	mov	ebx, 4			; Invoking the LISTEN subroutine
	mov	eax, 102		; Kernel opcode for SYS_SOCKETCALL
	int 	80h			; System Interrupt

	cmp	eax, 0			; Comparing our resultant file descriptor 
	jnge	_error			; If it is less than 0 then the process failed so, we jump to error subroutine
	push	eax			; Preserve file descriptor 	
	mov	eax, msg3		
	call	sprintl			; Print the success message 
	pop	eax			; Restore original value of eax register 

_accept:
	; Since the listener is ready, we need to accept the other connections
	; test the working of this by running `nc 127.0.0.1 9001`
	; int accept(int sockfd, struct sockaddr *_Nullable restrict addr, socklen_t *_Nullable restrict addrlen)

	push	byte 0			; Null Argument (address lenght)
	push 	byte 0			; NUll Argument (address)
	push	edx			; Push the file descriptor
	mov	ecx, esp		; Move the address of the arguments to ecx register
	mov	ebx, 5			; Invoking the ACCEPT subroutine 
	mov	eax, 102		; Kernel opcode for SYS_SOCKETCALL
	int	80h			; System Interrupt

	cmp	eax, 0			; Compare the status code
	jnge	_error			; If it is negative, then jump to error subroutine 
	push	eax			; Preserve the value of eax register
	mov	eax, msg4		; Move the address of the success message 
	call	sprintl			; Print the success message
	pop	eax			; Restore the original value of eax register


_fork:
	; This spawns a child process which handles the reading from sockets
	; pid_t fork(void)

	mov	esi, eax		; Store the file descriptor in the esi register
	mov	eax, 2			; Kernel opcode for FORK
	int	80h			; System Interrupt
	
	cmp	eax, 0			; Compare the eax register to see if the fork was successful
	jz	_read			; If yes, jump to _read and start reading from socket

	jmp	_accept			; If not, start looking for new sockets to accept


_read:
	; This reads the data sent by the other socket
	; ssize_t read(int fd, void buf[.count], size_t count)

	mov	edx, 1024		; We are going to read the first 255 bytes of data
	mov	ecx, buffer		; This is where we are going to store the read data
	mov	ebx, esi		; Move the file descriptor to ebx register
	mov	eax, 3			; Kernel opcode for READ
	int 	80h			; System Interrupt

	mov	eax, msg5		; Print the user for clarity
	call	sprintl
	mov	eax, buffer		; Move the read data to eax register
	call	sprintl			; Print the read data

_write:
	; This writes the data to the remote socket
	; ssize_t write(int fd, const void buf[.count], size_t count)

	mov	edx, 100		; Lenght of bytes to write to remote socket 
	mov	ecx, resp		; Move the address of response to ecx register
	mov	ebx, esi		; Move the previously stored to ebx register 
	mov	eax, 4			; Kernel opcode for WRITE
	int 	80h			; System Interrupt

_close:
	; This is used to close the socket connection
	; int close(int fd)

	mov	ebx, esi		; Move the file descriptor from esi register to ebx register	
	mov	eax, 6 			; Kernel opcode for SYS_CLOSE
	int 	80h			; System Interrupt

_exit:
	xor 	ebx, ebx
	call	exit


