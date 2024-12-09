# Directories
SRCDIR = src
INCDIR = include
BINDIR = bin

# Source files and object files
SRCS = $(wildcard $(SRCDIR)/*.c)
OBJS = $(SRCS:$(SRCDIR)/%.c=$(BINDIR)/%.o)

# Compiler flags
CFLAGS = -Wall -O2 -ffreestanding -nostdinc -nostdlib -mcpu=cortex-a53+nosimd -I$(INCDIR)

# Default target
all: clean kernel8.img

# Rule for assembling .S files into .o files (for start.S specifically)
$(BINDIR)/start.o: $(SRCDIR)/start.S
	clang --target=aarch64-elf $(CFLAGS) -c $< -o $@

# Rule for compiling .c files into .o files
$(BINDIR)/%.o: $(SRCDIR)/%.c
	clang --target=aarch64-elf $(CFLAGS) -c $< -o $@

# Rule for linking object files into the final kernel8.img
kernel8.img: $(BINDIR)/start.o $(OBJS)
	ld.lld -m aarch64elf -nostdlib $(BINDIR)/start.o $(OBJS) -T link.ld -o kernel8.elf
	llvm-objcopy -O binary kernel8.elf kernel8.img

# Clean rule to remove generated files
clean:
	rm -rf $(BINDIR)/*.o kernel8.elf >/dev/null 2>/dev/null || true

# Run the kernel using QEMU
run: kernel8.img
	qemu-system-aarch64 -M raspi3b -kernel kernel8.img -serial null -serial stdio
