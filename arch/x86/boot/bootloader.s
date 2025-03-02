.global _start
.section .text
.code16                       # 16-Bit Real Mode Code

_start:
    cli                       # Interrupts deaktivieren
    xor %ax, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    mov $0x7C00, %sp          # Stack setzen

    # BIOS setzt DL automatisch -> DL enthält das Bootlaufwerk (Floppy=0x00, HDD=0x80)
    mov %dl, %bl              # Speichere Bootlaufwerk in BL

    # Nachricht ausgeben
    mov $message, %si
    call print_string

    # Kernel von Festplatte oder Floppy laden (ab Sektor 2)
    mov $0x9000, %ax          # ES-Segment auf 0x9000 setzen (BIOS erwartet ES:BX)
    mov %ax, %es
    mov $0x0000, %bx          # Offset für Kernel im Segment (wird bei ES:BX gelesen)
    mov $4, %al               # Anzahl der zu lesenden Sektoren
    call disk_load

    # Erfolgsmeldung
    mov $success_msg, %si
    call print_string

    # Kernel ausführen
    ljmp $0x9000, $0x0000     # Springe zum Kernel (setzt CS=0)

halt:
    hlt
    jmp halt

# ---------------------------
# BIOS Disk Read (INT 13h, AH=2)
# ---------------------------
disk_load:
    pusha
    mov $0x02, %ah            # BIOS-Lesen-Funktion (INT 13h, AH=02h)
    mov %al, %al              # Anzahl der Sektoren bleibt in AL
    mov $0, %ch               # Cylinder 0
    mov $2, %cl               # Startsektor (Sektor 2)
    mov $0, %dh               # Head 0
    mov %bl, %dl              # Bootlaufwerk (vom BIOS gesetzt)
    int $0x13
    jc disk_error             # Falls Fehler: Fehlerbehandlung
    popa
    ret

disk_error:
    mov $error_msg, %si
    call print_string
    jmp halt

# ---------------------------
# String-Ausgabe (BIOS INT 10h)
# ---------------------------
print_string:
    lodsb
    test %al, %al
    jz done
    mov $0x0E, %ah
    int $0x10
    jmp print_string
done:
    ret

# Zeichenketten
message:     .asciz "Booting from detected drive...\r\n"
success_msg: .asciz "Kernel loaded successfully!\r\n"
error_msg:   .asciz "Disk read error! Check boot source.\r\n"

# 510 Bytes auffüllen und Signatur setzen
.org 510
.word 0xAA55

