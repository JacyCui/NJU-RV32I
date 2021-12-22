#define VGA_START    0x00200000
#define VGA_MAXLINE  30
#define VGA_MAXCOL   64
#define PS2_START    0x00300000



void putstr(char* str);
void putch(char ch);
char getch(void);

void vga_init(void);


