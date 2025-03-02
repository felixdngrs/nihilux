ENTRY(_start)

SECTIONS {
    . = 0x7C00;

    .text : {
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(COMMON)
        *(.bss)
    }

    .bootloader : {
        *(.text.bootloader)
        *(.data.bootloader)
        *(.bss.bootloader)
    }

    . = 0x9000;
    .kernel : {
        *(.text.kernel)
        *(.data.kernel)
        *(.bss.kernel)
    }
}
