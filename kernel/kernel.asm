[org 0x1000]
[bits 16]

kernel_start:
    ; print hello message
    mov si, hello_msg
    call print_string
    
    mov si, success_msg
    call print_string
    
    ; Infinite loop
    jmp $

print_string:
    lodsb               ; Load byte from [SI] into AL
    or al, al           ; Check if AL is 0 (null terminator)
    jz .done            ; If zero, we're done
    mov ah, 0x0E        ; BIOS teletype function
    int 0x10            ; Print character
    jmp print_string    ; Continue loop
.done:
    ret

hello_msg db ' Hello World from OS-1 Kernel!', 13, 10, 0
success_msg db 'Real mode kernel running successfully!', 13, 10, 0

; Pad the kernel
times 512-($-$$) db 0