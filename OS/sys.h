#define VGA_START 0x00200000
#define VGA_MAXLINE 30
#define VGA_MAXCOL 64

#define PS2_START 0x00300000

#define BCD_START 0x00400000
#define LED_START 0x00500000
#define LED_NUM 8
#define CLOCK_START 0x00600000

#define MAX_LEN 128

typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

void putstr(const char* str);
void putch(char ch);
char getch(void);
void setline(uint32_t n);

void initbcd(void);
void putbcd(uint32_t input);

void initled(void);
void ledon(uint32_t input);
void ledoff(uint32_t input);

uint32_t gettime();
void puttime(uint32_t t);

void vga_init(void);

uint32_t strlen(const char* str);
int strcmp(const char* str1, const char* str2);
int strncmp(const char* str1, const char* str2, uint32_t size);
void strcpy(char* dest, const char* src);
void strncpy(char* dest, const char* src, uint32_t size);

uint32_t a2u(const char* str);
int a2i(const char* str);
void u2a(char* dest, uint32_t src);
void i2a(char* dest, int src);

