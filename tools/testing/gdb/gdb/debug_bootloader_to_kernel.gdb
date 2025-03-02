set architecture i8086

# Load the bootloader ELF file (contains debugging symbols)
file ../nihilos.elf

# Connect to the QEMU remote GDB server on port 1234 (has to be started before using this one)
target remote localhost:1234

# Set a breakpoint at the bootloader entry point (BIOS loads it at 0x7C00)
break *0x7C00

# Set a breakpoint at the kernel entry point (where execution starts at 0x9000)
break *0x9000

# Start execution until a breakpoint is hit
continue

