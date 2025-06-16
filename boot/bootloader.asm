[org 0x7C00]
mov bp, 0x8000
mov sp, bp
mov [boot_drive], dl

mov si, hello_msg
call print_string

; Load kernel
mov ah, 0x02
mov al, 16
mov ch, 0x00
mov cl, 0x02
mov dh, 0x00
mov dl, [boot_drive]
mov bx, 0x1000
int 0x13
jc disk_error

mov si, load_success_msg
call print_string

; Jump to kernel in real mode
jmp 0x0000:0x1000

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

disk_error:
    mov si, disk_error_msg
    call print_string
    cli
    hlt
    jmp $

hello_msg db 'Booting OS-1...', 0
disk_error_msg db ' Disk error!', 0
load_success_msg db ' Kernel-1 loaded successfully!', 0
boot_drive db 0

times 510-($-$$) db 0
dw 0xAA55