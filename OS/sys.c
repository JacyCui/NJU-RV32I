#include "sys.h"


char* vga_start = (char*)VGA_START;
uint32_t  vga_line = 0;
uint32_t  vga_ch = 0;

char* ps2 = (char*)PS2_START;

uint32_t* bcd = (uint32_t*)BCD_START;

uint8_t* led = (uint8_t*)LED_START;

uint32_t* clock = (uint32_t*)CLOCK_START;

char cmd[] = "cmd> ";


void vga_init() {
    vga_line = 0;
    vga_ch =0;
    for (int i = 0; i < VGA_MAXLINE; i++)
        for (int j = 0; j < VGA_MAXCOL; j++)
            vga_start[(i << 6) + j] = 0;
}

void putch(char ch) {
    if (ch == 8) { //backspace
        vga_ch--;
        vga_start[(vga_line << 6) + vga_ch] = 0;
        return;
    }
    if (ch == 13) {
        vga_line++;
	if (vga_line >= VGA_MAXLINE) vga_init();
	vga_ch = 0;
        putstr(cmd);
        return;
    }
    if (ch == 10) { //enter
        vga_line++;
        if (vga_line >= VGA_MAXLINE) vga_init();
	vga_ch = 0;
        return;
    }
    vga_start[(vga_line << 6) + vga_ch] = ch;
    vga_ch++;
    if (vga_ch >= VGA_MAXCOL) {
        vga_line++;
        vga_ch = 0;
    }
    if (vga_line >= VGA_MAXCOL) {
	    vga_init();
    }
}

void putstr(const char* str){
    for (const char* p = str; *p != 0; p++) putch(*p);
}

char getch() {
    return *ps2;
}

void setline(uint32_t n) {
	vga_line = n;
}

void initbcd() {
	*bcd = 0;
}

void putbcd(uint32_t input) {
	*bcd = input & 0x00ffffff;
}

void initled() {
	for (uint32_t i = 0; i < LED_NUM; i++) led[i] = 0;
}

void ledon(uint32_t input) {
	led[input] = 1;
}

void ledoff(uint32_t input) {
	led[input] = 0;
}

uint32_t gettime() {
	return *clock;
}

void puttime(uint32_t t) {
	char tmp[MAX_LEN];
	u2a(tmp, t);
	tmp[0] = (t & 0xf) + '0';
	tmp[1] = ((t >> 4) & 0xf) + '0';
	tmp[2] = ((t >> 8) & 0xf) + '0';
	tmp[3] = ((t >> 12) & 0xf) + '0';
	tmp[4] = ((t >> 16) & 0xf) + '0';
	tmp[5] = ((t >> 20) & 0xf) + '0';
	putch(tmp[5]); putch(tmp[4]); putch(':');
	putch(tmp[3]); putch(tmp[2]); putch(':');
	putch(tmp[1]); putch(tmp[0]);
}


uint32_t strlen(const char* str){
    uint32_t i = 0;
    while (str[i]) i++;
    return i;
}

int strcmp(const char* str1, const char* str2) {
    const char* p1 = str1;
    const char* p2 = str2;
    while (*p1 && *p2 && *p1 == *p2) { p1++; p2++; }
    return *p1 - *p2;
}

int strncmp(const char* str1, const char* str2, uint32_t size) {
    uint32_t i;
    for (i = 0; i < size; i++) if (str1[i] != str2[i]) break;
    if (i == size) return 0;
    return str1[i] - str2[i];
}

void strcpy(char* dest, const char* src) {
    while (*src) *(dest++) = *(src++);
    *dest = 0;
}

void strncpy(char* dest, const char* src, uint32_t size) {
    uint32_t i = 0;
    for (i = 0; i < size; i++) dest[i] = src[i];
    dest[i] = 0;
}

uint32_t a2u(const char* str, uint32_t begin) {
    uint32_t len = strlen(str);
    uint32_t res = 0;
    for (uint32_t i = begin; i < len; i++)
        if (str[i] >= '0' && str[i] <= '9')
            res = res * 10 + (str[i] - '0');
    return res;
}

void u2a(char* dest, uint32_t src) {
    uint32_t size = 0;
    while (src) {
        dest[size++] = '0' + (src % 10);
        src /= 10;
    }
    dest[size] = 0;
    uint32_t i = 0, j = size - 1;
    while (i < j) {
        char tmp = dest[i];
        dest[i] = dest[j];
        dest[j] = tmp;
        i++; j--;
    }
}
