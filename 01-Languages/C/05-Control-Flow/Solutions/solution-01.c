/* solution-01.c -- FizzBuzz via switch on a computed bit pattern. */
#include <stdio.h>

void fizzBuzz(int n) {
    int pattern = (n % 3 == 0) * 1 + (n % 5 == 0) * 2; /* 0=neither, 1=Fizz, 2=Buzz, 3=FizzBuzz */
    switch (pattern) {
        case 1:
            printf("Fizz\n");
            break;
        case 2:
            printf("Buzz\n");
            break;
        case 3:
            printf("FizzBuzz\n");
            break;
        default:
            printf("%d\n", n);
            break;
    }
}

int main(void) {
    int numbers[15];
    for (int i = 0; i < 15; i++) numbers[i] = i + 1;

    for (int i = 0; i < 15; i++) {
        fizzBuzz(numbers[i]);
    }
    return 0;
}
