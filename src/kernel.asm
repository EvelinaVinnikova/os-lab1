[BITS 32]
global _start
_start:
    mov ax,0x10
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov esp,0x90000
    mov word [0xB8000],0x074B   ; 'K'
    mov word [0xB8002],0x0752   ; 'R'
.hang: hlt
      jmp .hang