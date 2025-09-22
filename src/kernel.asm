[ORG 0x7E00] ; Сообщаем ядру его реальный адрес в памяти
; kernel.asm - Наше простое "ядро"
[BITS 16]

start:
    ; Выводим сообщение, чтобы показать, что мы загрузились
    mov si, msg_kernel
    call print_string

    hlt ; Останавливаем процессор

; --- Функция для печати строки (такая же, как в загрузчике) ---
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
msg_kernel db 'Kernel loaded successfully!', 0