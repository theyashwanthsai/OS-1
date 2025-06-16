# Assembler
ASM = nasm

# Flags
ASMFLAGS_BIN = -f bin

# Directories
BOOT_DIR = boot
KERNEL_DIR = kernel
BUILD_DIR = build
DRIVERS_DIR = drivers
LIB_DIR = lib

# Source files
BOOTLOADER_SRC = $(BOOT_DIR)/bootloader.asm
KERNEL_SRC = $(KERNEL_DIR)/kernel.asm

# Output files
BOOTLOADER_BIN = $(BUILD_DIR)/bootloader.bin
KERNEL_BIN = $(BUILD_DIR)/kernel.bin
OS_IMG = $(BUILD_DIR)/os.img

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Default target
all: $(OS_IMG)

# Build bootloader
$(BOOTLOADER_BIN): $(BOOTLOADER_SRC) | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS_BIN) $< -o $@

# Build kernel
$(KERNEL_BIN): $(KERNEL_SRC) | $(BUILD_DIR)
	$(ASM) $(ASMFLAGS_BIN) $< -o $@

# Create OS image
$(OS_IMG): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	cat $(BOOTLOADER_BIN) $(KERNEL_BIN) > $@
	truncate -s 1440K $@

# Run in QEMU
run: $(OS_IMG)
	qemu-system-i386 -fda $(OS_IMG)

# Clean
clean:
	rm -rf $(BUILD_DIR)

# Debug
debug: $(OS_IMG)
	qemu-system-i386 -fda $(OS_IMG) -s -S

# Install (copy to a USB or floppy)
install: $(OS_IMG)
	@echo "Copy $(OS_IMG) to your boot device"

# Show build info
info:
	@echo "OS-1 Build Information:"
	@echo "Bootloader: $(BOOTLOADER_SRC)"
	@echo "Kernel: $(KERNEL_SRC)"
	@echo "Output: $(OS_IMG)"

.PHONY: all run clean debug install info