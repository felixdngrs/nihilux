.global _start
.section .text
.code16

_kernel_main:   
    cli
    mov $0x0E, %ah
    mov $'7', %al
    int $0x10

    mov $0x9000, %ax  
    mov %ax, %es
 
    mov $0x07C0, %ax        # init stack
    mov %ax, %ss
    mov $0xFFFE, %sp        # set stack-pointer up

    mov $message, %si
    call print_string

hang:
    jmp hang                   # endless loop

print_string:
    lodsb
    test %al, %al
    jz done
    mov $0x0E, %ah
    int $0x10
    jmp print_string
done:
    ret

message: 
    .asciz "Kernel OK! ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~\r\n"

