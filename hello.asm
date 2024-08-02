SECTION .data
	msg     db      'Hello x86 Assembly', 0Ah
SECTION .text
global _start

_start:
    mov edx, 19        ; Length of the string
    mov ecx, msg       ; Address of the string
    mov ebx, 1         ; File descriptor (1 for STDOUT)
    mov eax, 4         ; Syscall number for SYS_WRITE
    int 80h            ; Call kernel

    ; Exit program
    mov eax, 1         ; Syscall number for SYS_EXIT
    xor ebx, ebx       ; Exit code 0
    int 80h            ; Call kernel

