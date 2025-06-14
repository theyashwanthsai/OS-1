; --- bootloader.asm ---
[org 0x7C00]    ; BIOS loads us at this address (standard for bootloaders)
mov bp, 0x8000  ; Set stack base (away from bootloader code)
mov sp, bp      ; Set stack pointer

mov [boot_drive], dl  ; Save boot drive

mov si, hello_msg  ; Point SI to the string
call print_string  ; Call our print routine

; --- Load Kernel ---
mov ah, 0x02        ; BIOS read sectors function
mov al, 16          ; Read 16 sectors (adjust based on kernel size)
mov ch, 0x00        ; Cylinder 0
mov cl, 0x02        ; Start reading from sector 2 (sector 1 is the first kernel sector)

; Sector 1 is the bootloader itself.
; Kernel starts immediately after the bootloader, it would be at sector 2 on a floppy.

mov dh, 0x00
mov dl, [boot_drive]  ; Drive number (floppy or HDD)
mov bx, 0x0000
mov ax, 0x100
mov es, ax            ; Load address segment: 0x1000:0x0000 = 0x10000
int 0x13              ; BIOS disk read
jc disk_error         ; Jump if error

mov si, load_success_msg
call print_string

jmp 0x1000:0x0000


print_string:
  lodsb           ; Load next byte from [SI] into AL, increment SI
  or al, al       ; Is AL = 0 (null terminator)?
  jz .done        ; If yes, return
  mov ah, 0x0E    ; BIOS teletype function is selected
  int 0x10        ; Print the character in AL. bios video services interrupt
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

times 510-($-$$) db 0  ; Pad to 510 bytes
dw 0xAA55              ; Boot signature (magic number)