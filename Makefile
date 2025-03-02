# Variablen
DEBUG_MODE=1
AS_OPTS=
ifeq ($(DEBUG_MODE), 1)
    AS_OPTS += -g
endif

LINKER_SCRIPT = linker.ld

# Bootloader
BOOTLDR_IN = bootloader.s
BOOTLDR_OUT = bootloader.o
BOOTLDR_BIN = bootloader.bin

# Kernel
KRNL_IN = kernel.s
KRNL_OUT = kernel.o
KRNL_BIN = kernel.bin

# Ausgabe
OS_NAME = nihilos
BOOTIMG_NAME = boot.img
OS_ELF = $(OS_NAME).elf
OS_BIN = $(OS_NAME).bin

# Werkzeuge
AS = as
LD = ld
OBJCOPY = objcopy
DD = dd
RM = rm -f
BASH = bash
SHLOG_SCRIPT = $(realpath shlog.sh)
SHLOG = . $(SHLOG_SCRIPT); shlog

# Standardziel
all: build

# Kompilierung des Bootloaders
$(BOOTLDR_OUT): $(BOOTLDR_IN)
	@ $(BASH) -c "$(SHLOG) INFO "Assembling bootloader...""
	$(AS) $(AS_OPTS) -o $@ $<

# Kompilierung des Kernels
$(KRNL_OUT): $(KRNL_IN)
	@ $(BASH) -c "$(SHLOG) INFO "Assembling kernel...""
	$(AS) $(AS_OPTS) -o $@ $<

# Linken von Bootloader und Kernel
$(OS_ELF): $(BOOTLDR_OUT) $(KRNL_OUT)
	@ $(BASH) -c "$(SHLOG) INFO "Linking everything...""
	$(LD) -T $(LINKER_SCRIPT) -o $@ $^

# Erstellen des Binär-Files
$(OS_BIN): $(OS_ELF)
	@ $(BASH) -c "$(SHLOG) INFO "Creating binary...""
	$(OBJCOPY) -O binary $< $@

# Erstellen des Boot-Images
$(BOOTIMG_NAME): $(OS_BIN)
	@ $(BASH) -c "$(SHLOG) INFO "Creating boot image...""
	$(RM) $(BOOTIMG_NAME)
	$(DD) if=/dev/zero of=$(BOOTIMG_NAME) bs=512 count=2880
	$(DD) if=$(OS_BIN) of=$(BOOTIMG_NAME) bs=512 seek=0
	@ $(BASH) -c "$(SHLOG) SUCCESS "Boot image created.""

# Haupt-Build-Ziel
build: $(BOOTIMG_NAME)
	@ $(BASH) -c "$(SHLOG) SUCCESS "$(OS_NAME) has been built!""

# Aufräumen
clean:
	@ $(BASH) -c "$(SHLOG) INFO "Cleaning up...""
	$(RM) $(BOOTLDR_OUT) $(KRNL_OUT) $(OS_ELF) $(OS_BIN) $(BOOTIMG_NAME)

.PHONY: all build clean
