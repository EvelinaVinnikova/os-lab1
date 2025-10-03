#include <stdint.h>
static volatile uint16_t* const VGA=(uint16_t*)0xB8000;
static inline void putc_at(char ch,int row,int col,uint8_t attr){
  VGA[row*80+col]=(uint16_t)attr<<8|(uint8_t)ch;
}

static void print_at(const char* s,int row,int col){
  uint8_t a=0x07; int r=row,c=col;
  while(*s){
    if(*s=='\n'){
      r++;
      c=0;
      s++;
      continue;
    }
    putc_at(*s++,r,c++,a);
    if(c>=80){
      c=0;
      r++;
    }
  }
}

void kernel_main(void){
  print_at("Kernel is now running in protected mode!",10,0);
  for(;;)__asm__ __volatile__("hlt");
}
void _start(void){
  kernel_main();
}