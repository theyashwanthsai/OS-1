; --- bootloader.asm ---
[org 0x7C00]    ; BIOS loads us at this address (standard for bootloaders)
mov bp, 0x8000  ; Set stack base (away from bootloader code)
mov sp, bp      ; Set stack pointer

mov si, hello_msg  ; Point SI to the string
call print_string  ; Call our print routine

; --- Load Kernel ---
mov ah, 0x02        ; BIOS read sectors function
mov al, 16          ; Read 16 sectors (adjust based on kernel size)
mov ch, 0x00        ; Cylinder 0
mov cl, 0x02        ; Start reading from sector 2 (sector 1 is the first kernel sector)

; Sector 1 is the bootloader itself.
; Kernel starts immediately after the bootloader, it would be at sector 2 on a floppy.

print_string:
  lodsb           ; Load next byte from [SI] into AL, increment SI
  or al, al       ; Is AL = 0 (null terminator)?
  jz .done        ; If yes, return
  mov ah, 0x0E    ; BIOS teletype function is selected
  int 0x10        ; Print the character in AL. bios video services interrupt
  jmp print_string
.done:
  ret

hello_msg db 'Booting toy_OS...', 0  ; Null-terminated string

times 510-($-$$) db 0  ; Pad to 510 bytes
dw 0xAA55              ; Boot signature (magic number)