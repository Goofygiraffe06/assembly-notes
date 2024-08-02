SECTION .data
    msg db 'Namste gois', 0Ah ; Define the string with a newline character

SECTION .text
global _start

_start:
    mov eax, msg    ; Load the address of the string into eax

    ; Call the strlen function to calculate the length of the string
    call strlen

    ; The result (string length) is now stored in eax

    mov edx, eax    ; Move the string length to edx for write syscall
    mov ecx, msg    ; Load the address of the string into ecx
    mov ebx, 1      ; File Descriptor (1 for STDOUT)
    mov eax, 4      ; Syscall number for SYS_WRITE
    int 80h         ; Call Kernel to write the string

    mov ebx, 0      ; Return Code (0 for success)
    mov eax, 1      ; Syscall number for SYS_EXIT
    int 80h         ; Call kernel to exit the program

strlen:
    push ebx        ; Preserve ebx register value
    mov ebx, eax    ; Save the address of the string in ebx

next:
    cmp byte [eax], 0 ; Compare the byte at the address in eax with 0 (end of string)
    jz finish       ; If it's 0, jump to finish (end of the counting loop)
    inc eax         ; Increment the address in eax to point to the next character
    jmp next        ; Jump back to the beginning of the loop

finish:
    sub eax, ebx    ; Calculate the length of the string by subtracting the original address from the current address in eax
    pop ebx         ; Restore the original value of ebx
    ret             ; Return from the function

