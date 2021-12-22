#include "sys.h"


char hello[]= "Hello World!\n";
char cmd[] = "cmd> ";

int main();

//setup the entry point
void entry()
{
    asm("lui sp, 0x00120"); //set stack to high address of the dmem
    asm("addi sp, sp, -4");
    main();
}

int main()
{
    char c = getch();
    while (1) {
        if (c) break;
        c = getch();
    }
    vga_init();
    putstr(hello);

    c = getch();
    while (1)
    {
	    if (c) putch(c);
	    c = getch();
    };

    return 0;
}
