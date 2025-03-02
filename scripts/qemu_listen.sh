#!/bin/bash

# Boot image (defaults to "boot.img" if not provided)
BOOT_IMAGE="${2:-boot.img}"

# First argument: target architecture
TARGET_ARCH="$1"

# Check if an architecture was provided
if [ -z "$TARGET_ARCH" ]; then
    echo "error: No architecture specified!"
    echo "usage: $0 <architecture> [boot_image]"
    exit 1
fi

# Set the appropriate QEMU command based on the architecture
case "$TARGET_ARCH" in
    x86_64)
        QEMU_CMD="qemu-system-x86_64 -fda ${BOOT_IMAGE} -s -S"
        ;;
    i386)
        QEMU_CMD="qemu-system-i386 -fda ${BOOT_IMAGE} -s -S"
        ;;
    arm)
        QEMU_CMD="qemu-system-arm -M versatilepb -cpu arm1176 -kernel ${BOOT_IMAGE} -s -S"
        ;;
    aarch64)
        QEMU_CMD="qemu-system-aarch64 -M virt -cpu cortex-a72 -kernel ${BOOT_IMAGE} -s -S"
        ;;
    mips)
        QEMU_CMD="qemu-system-mips -M malta -kernel ${BOOT_IMAGE} -s -S"
        ;;
    mips64)
        QEMU_CMD="qemu-system-mips64 -M malta -kernel ${BOOT_IMAGE} -s -S"
        ;;
    ppc)
        QEMU_CMD="qemu-system-ppc -M g3beige -kernel ${BOOT_IMAGE} -s -S"
        ;;
    ppc64)
        QEMU_CMD="qemu-system-ppc64 -M powernv -kernel ${BOOT_IMAGE} -s -S"
        ;;
    riscv32)
        QEMU_CMD="qemu-system-riscv32 -M virt -kernel ${BOOT_IMAGE} -s -S"
        ;;
    riscv64)
        QEMU_CMD="qemu-system-riscv64 -M virt -kernel ${BOOT_IMAGE} -s -S"
        ;;
    sparc)
        QEMU_CMD="qemu-system-sparc -M SS-5 -kernel ${BOOT_IMAGE} -s -S"
        ;;
    sparc64)
        QEMU_CMD="qemu-system-sparc64 -M sun4u -kernel ${BOOT_IMAGE} -s -S"
        ;;
    *)
        echo "error: '$TARGET_ARCH' is not a supported QEMU architecture!"
        echo "valid architectures: x86_64, i386, arm, aarch64, mips, mips64, ppc, ppc64, riscv32, riscv64, sparc, sparc64"
        exit 1
        ;;
esac

# Start QEMU
echo "starting QEMU: $QEMU_CMD"
eval $QEMU_CMD

