/* solution-01.c -- function-pointer dispatch table instead of a branch chain. */
#include <stdio.h>

typedef int (*BinOp)(int, int);

int opAdd(int a, int b) { return a + b; }
int opSub(int a, int b) { return a - b; }
int opMul(int a, int b) { return a * b; }
int opDiv(int a, int b) { return a / b; }

int calculate(int a, int b, int opCode) {
    /* The array index IS the dispatch -- no if/switch needed here at all. */
    static const BinOp table[4] = { opAdd, opSub, opMul, opDiv };
    return table[opCode](a, b);
}

int main(void) {
    printf("calculate(10, 3, 0) = %d\n", calculate(10, 3, 0));
    printf("calculate(10, 3, 1) = %d\n", calculate(10, 3, 1));
    printf("calculate(10, 3, 2) = %d\n", calculate(10, 3, 2));
    printf("calculate(10, 3, 3) = %d\n", calculate(10, 3, 3));
    return 0;
}
