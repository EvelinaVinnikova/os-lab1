[BITS 16]
[ORG 0x7C00]

KERNEL_ADDR equ 0x7E00 ; Адрес для загрузки ядра

start:
    ; Настройка сегментов и стека
    cli
    mov ax, 0x0000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x9000
    mov [BootDrive], dl          ; сохранить номер диска BIOS


    ; Вывод сообщения о начале загрузки
    mov si, msg_loading
    call print_string

    xor ah, ah
    mov dl, [BootDrive]
    int 0x13

    ; Чтение ядра с диска
    mov ah, 0x02  
    mov al, 4    
    mov ch, 0     
    mov cl, 2   
    mov dh, 0
    mov bx, KERNEL_ADDR
    mov dl, [BootDrive]
    int 0x13            ; Вызываем дисковый сервис BIOS

    ; Проверка на ошибку чтения
    jc error_loop       ; Была ошибка => уходим на ошибку [cite: 830]

    cli
    in al, 0x92
    or al, 00000010b   ; установка бита A20
    out 0x92, al
    lgdt [gdtr]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:0x00007E00

    [BITS 32]
    protected_mode_entry:
        mov ax,0x10
        mov ds,ax
        mov es,ax
        mov fs,ax
        mov gs,ax
        mov ss,ax
        mov esp,0x90000
        jmp 0x08:0x00007E00
        hlt

    align 8
    gdt_start:
        dq 0x0000000000000000
        dq 0x00CF9A000000FFFF
        dq 0x00CF92000000FFFF
    gdt_end:
    gdtr: dw gdt_end-gdt_start-1
          dd gdt_start


error_loop:
    mov si, msg_error
    call print_string
    hlt

; Функция для печати строки
print_string:
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

; Данные
msg_loading db 'Loading kernel...', 0x0D, 0x0A, 0
msg_error   db 'Disk read error!', 0
BootDrive db 0

; Neccessary part для загрузчика
times 510 - ($ - $$) db 0
dw 0xAA55