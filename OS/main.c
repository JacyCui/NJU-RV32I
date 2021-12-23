#include "sys.h"

char hello[] = "Hello World!";
char err_unknown[] = "Unknown Command!";
char err_argmiss[] = "Argument Missing Exception!";
char err_argill[] = "Illegal Argument Exception!";
char help_info[] = "hello\nfib n\ntime\nwhoami\necho str\nclear\nbcd n\nled on n\nled off n\nexpr str";
char success[] = "Set Successfully!";

char buffer[MAX_LEN];
uint32_t pos = 0;

int main();
void exec_cmd(const char* cmd, uint32_t size);
uint32_t fib(uint32_t n);

int expr(const char* str);
void insert_operand(int* operand, int* top_num, int num);
void insert_oper (char * oper , int *top_oper , char ch);
int compare(char* oper, int* top_oper, char ch);
void deal_date(int* operand, char* oper, int* top_num, int* top_oper);


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
    while (1) { if (c) break; c = getch(); }
    // start when any key is pressed

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
			else if (c == 8) { if (pos) pos--; else putch(20); }
			else{ buffer[pos++] = c; }
			putch(c);
		}
		c = getch();
    };
    return 0;
}

void exec_cmd(const char* cmd, uint32_t size) {
    if (!strcmp(cmd, "hello")) { putstr(hello); return; }
    if (!strcmp(cmd, "time")) { puttime(gettime()); return; }
    if (!strcmp(cmd, "clear")) { vga_init(); setline(VGA_MAXLINE - 1); return; }
    if (!strcmp(cmd, "whoami")) { putstr("cuijiacai@nju:201220014"); return; }
    if (!strcmp(cmd, "help")) { putstr(help_info); return; }
    if (size >= 3 && !strncmp(cmd, "bcd", 3)) {
	    if (size == 3) { putstr(err_argmiss); return; }
	    putbcd(a2u(cmd + 3));
	    putstr(success); 
	    return;
    }
    if (size >= 6 && !strncmp(cmd, "led on", 6)) {
	    if (size == 6) { putstr(err_argmiss); return; }
	    uint32_t n = a2u(cmd + 6);
	    if (n >= LED_NUM) { putstr(err_argill); return; }
	    ledon(n);
	    putstr(success);
	    return;
    }
    if (size >= 7 && !strncmp(cmd, "led off", 7)) {
	    if (size == 7) { putstr(err_argmiss); return; }
	    uint32_t n = a2u(cmd + 7);
	    if (n >= LED_NUM) { putstr(err_argill); return; }
	    ledoff(n);
	    putstr(success);
	    return;
    }
    if (size >= 3 && !strncmp(cmd, "fib", 3)) {
        if (size == 3) { putstr(err_argmiss); return; }
		uint32_t n = a2u(cmd + 3);
        char res[MAX_LEN];
        u2a(res, fib(n));
        putstr(res);
        return;
    }
    if (size >= 4 && !strncmp(cmd, "echo", 4)) {
	    if (size <= 5) { putstr(err_argmiss); return; }
	    putstr(cmd + 5); return;
    }
    if (size >= 4 && !strncmp(cmd, "expr", 4)) {
        if (size <= 5) { putstr(err_argmiss); return; }
        char res[MAX_LEN];
        i2a(res, expr(cmd + 5));
        putstr(res);
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

int expr(const char* str) {
    int operand[MAX_LEN];
    char oper[MAX_LEN];
    for (uint32_t i = 0; i < MAX_LEN; i++) {
        operand[i] = 0;
        oper[i] = 0;
    }

    int top_num = -1;
    int top_oper = -1;

    char* temp;
    char dest[MAX_LEN];  

    int num = 0, i = 0;  
    
    while(*str != '\0') {  
        temp = dest;  
        while(*str >= '0' && *str <= '9') *(temp++) = *(str++);
        if(*str != '(' && *(temp - 1) != '\0') {
            *temp = '\0';
            num = a2i(dest);
            insert_operand(operand, &top_num, num);
        }
        while(1) {
            if (top_oper == -1 && !*str) break;
            i = compare(oper, &top_oper, *str);
            if (i == 0) { insert_oper(oper, &top_oper, *str); break; }
            if (i == 1) str++;
            else deal_date(operand, oper, &top_num, &top_oper);  
        }
        str++;
    }
    return operand[0];
}

void insert_operand(int* operand, int* top_num, int num) { (*top_num) ++; operand[*top_num] = num; }  
void insert_oper(char* oper , int *top_oper , char ch) { (*top_oper)++; oper[*top_oper] = ch; }  
     
int compare(char* oper, int* top_oper, char ch) {
    if ((oper[*top_oper] == '-' || oper[*top_oper] == '+') && (ch == '*' || ch == '/')) return 0;
    if (*top_oper == -1 || ch == '('|| (oper[*top_oper] == '(' && ch != ')')) return 0;
    if (oper[*top_oper] =='(' && ch == ')') { (*top_oper)--; return 1;}
    return -1;
}  

void deal_date(int* operand, char* oper, int* top_num, int* top_oper) {
    int num_1 = operand[*top_num];
    int num_2 = operand[*top_num - 1];  
    int value;
    switch(oper[*top_oper]) {
        case '+': value = num_1 + num_2; break;
        case '-': value = num_2 - num_1; break;
        case '*': value = num_2 * num_1; break;
        case '/': value = num_2 / num_1; break;
        default: value = 0; break;
    }
    (*top_num)--;
    operand[*top_num] = value;
    (*top_oper)--;
}



