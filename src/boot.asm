[BITS 16]
[ORG 0x7C00]

KERNEL_ADDR equ 0x7E00 ; Адрес для загрузки ядра

start:
    ; Настройка сегментов и стека
    cli
    mov ax, 0x0000
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; Вывод сообщения о начале загрузки
    mov si, msg_loading
    call print_string

    ; Чтение ядра с диска
    mov ah, 0x02  
    mov al, 4    
    mov ch, 0     
    mov cl, 2   
    mov dh, 0
    mov bx, KERNEL_ADDR
    
    int 0x13            ; Вызываем дисковый сервис BIOS

    ; Проверка на ошибку чтения
    jc error_loop       ; Была ошибка => уходим на ошибку [cite: 830]

    ; Передача управления ядру
    jmp KERNEL_ADDR

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

; Neccessary part для загрузчика
times 510 - ($ - $$) db 0
dw 0xAA55