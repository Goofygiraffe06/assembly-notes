; Compiled on Linux (x86_64)
; Author: giraffe
; Kernel: 6.9.6-arch1-1
; Date: 2024-06-30 18:24:41
; File: sockets.asm
; Compiler: nasm (NASM version 2.16.03 compiled on May  4 2024)

; Socket Programming - create, bind, listen, accept, read, write, close

%include 'stdlib.asm'

SECTION .data
    msg1 db 'Socket Created Successfully!', 0h
    msg2 db 'Socket Bind Successful', 0h
    msg3 db 'Socket is Now Listening for New Connections', 0h
    msg4 db 'Accepted a new client', 0h
    msg5 db '(netcat)> ', 0h
    error db 'An Error Occurred! GDB-IT!!!', 0h
    resp db 'HTTP/1.1 200 OK', 0Dh, 0Ah, 'Content-Type: text/html', 0Dh, 0Ah, 'Content-Length: 16', 0Dh, 0Ah, 0Dh, 0Ah, 'Hack The Planet!\n', 0Dh, 0Ah, 0h

SECTION .bss
    buffer resb 1024

SECTION .text
global _start

_error:
    ; Print error message and exit
    mov eax, error
    call sprintl
    xor ebx, ebx
    call exit

_start:
    ; Clear all registers
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

_socket:
    ; Create a socket
    ; int socket(int domain, int type, int protocol)
    push byte 6         ; IPPROTO_TCP
    push byte 1         ; SOCK_STREAM
    push byte 2         ; AF_INET
    mov ecx, esp        ; Argument array address
    mov ebx, 1          ; Socket syscall number
    mov eax, 102        ; SYS_SOCKETCALL
    int 80h             ; System call

    ; Check for errors
    cmp eax, 0
    jnge _error
    push eax            ; Preserve file descriptor
    mov eax, msg1
    call sprintl
    pop eax             ; Restore file descriptor

_bind:
    ; Bind the socket to a port
    ; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
    mov edx, eax        ; Socket file descriptor
    push dword 0x00000000   ; IP Address (any)
    push word 0x2923     ; Port 9001
    push word 2          ; AF_INET
    mov ecx, esp        ; Argument array address
    push byte 16        ; Size of arguments
    push ecx            ; Address of arguments
    push edx            ; Socket file descriptor
    mov ecx, esp        ; Argument array address
    mov ebx, 2          ; BIND syscall number
    mov eax, 102        ; SYS_SOCKETCALL
    int 80h             ; System call

    ; Check for errors
    cmp eax, 0
    jnge _error
    push eax            ; Preserve file descriptor
    mov eax, msg2
    call sprintl
    pop eax             ; Restore file descriptor

_listen:
    ; Listen for incoming connections
    ; int listen(int sockfd, int backlog)
    push byte 1         ; Backlog size
    push edx            ; Socket file descriptor
    mov ecx, esp        ; Argument array address
    mov ebx, 4          ; LISTEN syscall number
    mov eax, 102        ; SYS_SOCKETCALL
    int 80h             ; System call

    ; Check for errors
    cmp eax, 0
    jnge _error
    push eax            ; Preserve file descriptor
    mov eax, msg3
    call sprintl
    pop eax             ; Restore file descriptor

_accept:
    ; Accept incoming connection
    ; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
    push byte 0         ; Null argument (address length)
    push byte 0         ; Null argument (address)
    push edx            ; Socket file descriptor
    mov ecx, esp        ; Argument array address
    mov ebx, 5          ; ACCEPT syscall number
    mov eax, 102        ; SYS_SOCKETCALL
    int 80h             ; System call

    ; Check for errors
    cmp eax, 0
    jnge _error
    push eax            ; Preserve file descriptor
    mov eax, msg4
    call sprintl
    pop eax             ; Restore file descriptor

_fork:
    ; Fork a child process
    ; pid_t fork(void)
    mov esi, eax        ; Client socket file descriptor
    mov eax, 2          ; FORK syscall number
    int 80h             ; System call

    ; Check for errors
    cmp eax, 0
    jz _read            ; Child process reads from socket
    jmp _accept         ; Parent process accepts new connections

_read:
    ; Read data from socket
    ; ssize_t read(int fd, void *buf, size_t count)
    mov edx, 1024       ; Buffer size
    mov ecx, buffer     ; Buffer address
    mov ebx, esi        ; Client socket file descriptor
    mov eax, 3          ; READ syscall number
    int 80h             ; System call

    ; Print read data
    mov eax, msg5
    call sprint
    mov eax, buffer
    call sprintl

_write:
    ; Write response to socket
    ; ssize_t write(int fd, const void *buf, size_t count)
    mov edx, 100        ; Response length
    mov ecx, resp       ; Response address
    mov ebx, esi        ; Client socket file descriptor
    mov eax, 4          ; WRITE syscall number
    int 80h             ; System call

_close:
    ; Close socket connection
    ; int close(int fd)
    mov ebx, esi        ; Socket file descriptor
    mov eax, 6          ; SYS_CLOSE syscall number
    int 80h             ; System call

_exit:
    ; Exit progr

