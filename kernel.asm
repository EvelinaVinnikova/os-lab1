[ORG 0x7E00] ; Сообщаем ядру его реальный адрес в памяти
[BITS 16]

start:
    mov si, msg_kernel
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
msg_kernel db 'Kernel loaded successfully!', 0