OS-1/
├── README.md
├── LICENSE
├── Makefile
├── .gitignore
├── boot/
│   ├── bootloader.asm
│   └── linker.ld
├── kernel/
│   ├── kernel.asm
│   ├── print.asm          # (future: separate print functions)
│   └── interrupts.asm     # (future: interrupt handlers)
├── drivers/
│   ├── keyboard.asm       # (future: keyboard driver)
│   ├── disk.asm          # (future: disk operations)
│   └── vga.asm           # (future: advanced VGA functions)
├── lib/
│   ├── string.asm        # (future: string utilities)
│   └── math.asm          # (future: math functions)
├── build/
│   ├── bootloader.bin
│   ├── kernel.bin
│   └── os.img
├── docs/
│   ├── BUILDING.md
│   ├── ARCHITECTURE.md
│   └── CHANGELOG.md
└── tools/
    ├── debug.sh
    └── run.sh