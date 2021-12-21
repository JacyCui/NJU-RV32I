#include "sys.h"


char* vga_start = (char*) VGA_START;
int   vga_line=0;
int   vga_ch=0;
char* ps2 = (char*) PS2_START;


void vga_init(){
    vga_line = 0;
    vga_ch =0;
    for(int i=0;i<VGA_MAXLINE;i++)
        for(int j=0;j<VGA_MAXCOL;j++)
            vga_start[ (i<<6)+j ] =0;
}

void putch(char ch) {
  if(ch==8) //backspace
  {
      vga_ch--;
      vga_start[ (vga_line<<6) + vga_ch] = 0;
      return;
  }
  if(ch==13 || ch==10) //enter
  {
      vga_line++;
      vga_ch=0;
      return;
  }
  vga_start[ (vga_line<<6)+vga_ch] = ch;
  vga_ch++;
  if(vga_ch>=VGA_MAXCOL)
  {
     vga_line++;
     vga_ch = 0;
  }
  return;
}

void putstr(char *str){
    for(char* p=str;*p!=0;p++)
      putch(*p);
}

char getch() {
    return *ps2;
}


