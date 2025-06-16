ENTRY(kernel_main)

SECTIONS
{
    . = 0x1000;  /* Kernel loads at 0x1000 (4KB) not 0x10000 */
    
    .text : {
        *(.text)
    }
    
    .data : {
        *(.data)
    }
    
    .bss : {
        *(.bss)
    }
}