#define VGA_START 0x00200000
#define VGA_MAXLINE 30
#define VGA_MAXCOL 64
#define PS2_START 0x00300000

#define MAX_LEN 64

typedef unsigned int uint32_t;

void putstr(char* str);
void putch(char ch);
char getch(void);

void vga_init(void);

uint32_t strlen(const char* str);
int strcmp(const char* str1, const char* str2);
int strncmp(const char* str1, const char* str2, uint32_t size);
void strcpy(char* dest, const char* src);
void strncpy(char* dest, const char* src, uint32_t size);

uint32_t a2u(const char* str, uint32_t begin);
void u2a(char* dest, uint32_t src);
