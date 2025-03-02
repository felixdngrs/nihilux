
# Nihilux
# Copyright (C) 2025 Felix Dangers fdangers@proton.me
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

DEBUG_MODE=1
AS_OPTS=
ifeq ($(DEBUG_MODE), 1)
    AS_OPTS += -g
endif

SCRIPTS = scripts

LINKER_SCRIPT = linker.ld
BUILD_DIR = build

ARCH = x86
ARCH_DIR = arch/${ARCH}

# Bootloader
BOOTLDR_IN = ${ARCH_DIR}/boot/bootloader.s
BOOTLDR_OUT = ${BUILD_DIR}/bootloader.o

# Kernel
KRNL_IN = ${ARCH_DIR}/kernel.s
KRNL_OUT = ${BUILD_DIR}/kernel.o

# Output
OS_NAME = nihilos
BOOTIMG_NAME = ${BUILD_DIR}/boot.img
OS_ELF = ${BUILD_DIR}/$(OS_NAME).elf
OS_BIN = ${BUILD_DIR}/$(OS_NAME).bin

# Tools
AS = as
LD = ld
OBJCOPY = objcopy
DD = dd
RM = rm -f
BASH = bash
SHLOG_SCRIPT = $(realpath ${SCRIPTS}/shlog.sh)
SHLOG = . $(SHLOG_SCRIPT); shlog

# Target
all: build

$(BOOTLDR_OUT): $(BOOTLDR_IN)
	@ $(BASH) -c "$(SHLOG) INFO "Assembling bootloader...""
	$(AS) $(AS_OPTS) -o $@ $<

$(KRNL_OUT): $(KRNL_IN)
	@ $(BASH) -c "$(SHLOG) INFO "Assembling kernel...""
	$(AS) $(AS_OPTS) -o $@ $<

# link bootloader & kernel
$(OS_ELF): $(BOOTLDR_OUT) $(KRNL_OUT)
	@ $(BASH) -c "$(SHLOG) INFO "Linking everything...""
	$(LD) -T $(LINKER_SCRIPT) -o $@ $^

# create binary files
$(OS_BIN): $(OS_ELF)
	@ $(BASH) -c "$(SHLOG) INFO "Creating binary...""
	$(OBJCOPY) -O binary $< $@

# create boot image
$(BOOTIMG_NAME): $(OS_BIN)
	@ $(BASH) -c "$(SHLOG) INFO "Creating boot image...""
	$(RM) $(BOOTIMG_NAME)
	$(DD) if=/dev/zero of=$(BOOTIMG_NAME) bs=512 count=2880
	$(DD) if=$(OS_BIN) of=$(BOOTIMG_NAME) bs=512 seek=0
	@ $(BASH) -c "$(SHLOG) SUCCESS "Boot image created.""

build: $(BOOTIMG_NAME)
	@ $(BASH) -c "$(SHLOG) SUCCESS "$(OS_NAME) has been built!""

clean:
	@ $(BASH) -c "$(SHLOG) INFO "Cleaning up...""
	$(RM) --recursive --dir ${BUILD_DIR}/*

.PHONY: all build clean
