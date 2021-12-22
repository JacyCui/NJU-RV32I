#include "sys.h"

char hello[] = "Hello World!";
char err_unknown[] = "Unknown Command!";
char err_argmiss[] = "Argument Missing Exception!"; 
char err_argill[] = "Illegal Argument Exception!";
char help_info[] = "hello\nfib n\ntime\nwhoami\necho str\nclear\nbcd n\nled on n\nled off n";

char success[] = "Set Successfully!";

char buffer[MAX_LEN];
uint32_t pos = 0;

int main();
void exec_cmd(const char* cmd, uint32_t size);
uint32_t fib(uint32_t n);


//setup the entry point
void entry() {
    asm("lui sp, 0x00120"); //set stack to high address of the dmem
    asm("addi sp, sp, -4");
    main();
}

int main() {
	initled();
	initbcd();
    char c = getch();
    while (1) {
        if (c) break;
        c = getch();
    } // start when any key is pressed

    vga_init();
    putstr(hello);
    putch(13);
    
    pos = 0;
    c = getch();
    while (1) {
	if (c) {
		if (c == 13) {
			if (pos) {
            			buffer[pos] = 0;
            			putch('\n');
           	 		exec_cmd(buffer, pos);
			}
			pos = 0;
        	}
		else if (c == 8) {
			if (pos) pos--;
		}
        	else {
            		buffer[pos++] = c;
        	}
        	putch(c);
	}
	c = getch();
    };
    return 0;
}

void exec_cmd(const char* cmd, uint32_t size) {
    if (!strcmp(cmd, "hello")) {
        putstr(hello);
        return;
    }
    if (!strcmp(cmd, "time")) {
	    uint32_t t = gettime();
	    puttime(t);
	    return;
    }
    if (!strcmp(cmd, "clear")) {
	    vga_init();
	    setline(VGA_MAXLINE - 1);
	    return;
    }
    if (!strcmp(cmd, "whoami")) {
	    putstr("cuijiacai@nju:201220014");
	    return;
    }
    if (!strcmp(cmd, "help")) {
	    putstr(help_info);
	    return;
    }
    if (size >= 3 && !strncmp(cmd, "bcd", 3)) {
	    if (size == 3) {
		    putstr(err_argmiss);
		    return;
	    }
	    uint32_t n = a2u(cmd, 3);
	    putbcd(n);
	    putstr(success); 
	    return;
    }
    if (size >= 6 && !strncmp(cmd, "led on", 6)) {
	    if (size == 6) {
		    putstr(err_argmiss);
		    return;
	    }
	    uint32_t n = a2u(cmd, 3);
	    if (n >= LED_NUM) {
		    putstr(err_argill);
		    return;
	    }
	    ledon(n);
	    putstr(success);
	    return;
    }
    if (size >= 7 && !strncmp(cmd, "led off", 7)) {
	    if (size == 7) {
		    putstr(err_argmiss);
		    return;
	    }
	    uint32_t n = a2u(cmd, 3);
	    if (n >= LED_NUM) {
		    putstr(err_argill);
		    return;
	    }
	    ledoff(n);
	    putstr(success);
	    return;
    }
    if (size >= 3 && !strncmp(cmd, "fib", 3)) {
        if (size == 3) {
		putstr(err_argmiss);
		return;
	}
	uint32_t n = a2u(cmd, 3);
        char res[MAX_LEN];
        u2a(res, fib(n));
        putstr(res);
        return;
    }
    if (size >= 4 && !strncmp(cmd, "echo", 4)) {
	    if (size == 4) {
		    putstr(err_argmiss);
		    return;
	    }
	    putstr(cmd + 5);
	    return;
    }
    putstr(err_unknown);
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

