[BITS 16]
[ORG 0x7C00]

KERNEL_ADDR equ 0x7E00 ; Адрес для загрузки ядра, как в методичке

start:
    ; --- Настройка сегментов и стека ---
    cli
    mov ax, 0x0000
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    ; --- Вывод сообщения о начале загрузки ---
    mov si, msg_loading
    call print_string

    ; --- ЧТЕНИЕ ЯДРА С ДИСКА (ГЛАВНАЯ ЧАСТЬ) ---
    mov ah, 0x02        ; Функция BIOS: "прочитать секторы" [cite: 653, 657, 661]
    mov al, 4           ; Читаем 4 сектора (2048 байт)
    mov ch, 0           ; Цилиндр 0
    mov cl, 2           ; Начиная с сектора 2 (сектор 1 - это мы сами)
    mov dh, 0           ; Головка 0
    mov bx, KERNEL_ADDR ; ES:BX = адрес буфера (0000:7E00)
    
    int 0x13            ; Вызываем дисковый сервис BIOS

    ; --- Проверка на ошибку чтения ---
    jc error_loop       ; Если была ошибка (Carry Flag = 1), уходим на ошибку [cite: 830]

    ; --- Передача управления ядру ---
    jmp KERNEL_ADDR     ; Прыгаем на адрес, куда загрузили ядро

error_loop:
    mov si, msg_error
    call print_string
    hlt

; --- Функция для печати строки ---
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

; --- Данные ---
msg_loading db 'Loading kernel...', 0x0D, 0x0A, 0
msg_error   db 'Disk read error!', 0

; --- Обязательная часть для загрузчика ---
times 510 - ($ - $$) db 0
dw 0xAA55