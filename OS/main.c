#include "sys.h"

char hello[] = "Hello World!";
char err[] = "Unknown Command!";
char buffer[MAX_LEN];
int pos = 0;

int main();
void exec_cmd(const char* cmd);
uint32_t fib(uint32_t n);


//setup the entry point
void entry() {
    asm("lui sp, 0x00120"); //set stack to high address of the dmem
    asm("addi sp, sp, -4");
    main();
}

int main() {
    char c = getch();
    while (1) {
        if (c) break;
        c = getch();
    } // start when any key is pressed

    vga_init();
    putstr(hello);
    putch(13);

    c = getch();
    while (1) {
	    if (c == 13) {
            buffer[pos] = 0;
            pos = 0;
            putch('\n');
            exec_cmd(buffer);
        }
        else {
            buffer[pos++] = c;
        }
        putch(c);
	    c = getch();
    };
    return 0;
}

void exec_cmd(const char* cmd) {
    if (!strcmp(cmd, "hello")) {
        putstr(hello);
        return;
    }
    if (!strncmp(cmd, "fib", 3)) {
        uint32_t n = a2u(cmd, 3);
        char res[MAX_LEN];
        u2a(res, fib(n));
        putstr(res);
        return;
    }
    putstr(err);
}

uint32_t fib(uint32_t n) {
    uint32_t fib0 = 0, fib1 = 1;
    if (n == 0) return 0;
    if (n == 1) return 1;
    for (uint32_t i = 2; i <= n; i++) {
        uint32_t tmp = fib1;
        fib1 = fib0 + fib1;
        fib0 = tmp;
    }
    return fib1;
}

