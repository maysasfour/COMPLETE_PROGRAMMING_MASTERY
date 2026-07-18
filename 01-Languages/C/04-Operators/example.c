/* example.c -- pointer arithmetic and the complete absence of operator
   overloading (every operator means exactly one fixed thing, for every
   type, everywhere). */
#include <stdio.h>

int main(void) {
    int numbers[5] = {10, 20, 30, 40, 50};
    int* p = numbers;   /* an array decays to a pointer to its first element */

    printf("Arithmetic: 7 / 2 = %d (integer division truncates), 7 %% 2 = %d\n", 7 / 2, 7 % 2);
    printf("Arithmetic (float): 7.0 / 2 = %f\n", 7.0 / 2);

    /* Pointer arithmetic is scaled by sizeof(*p) automatically -- p + 1
       advances by sizeof(int) bytes, not 1 byte, because the compiler
       knows p's pointee type. This has no equivalent in garbage-collected
       languages, and in C++ is identical but far less commonly reached
       for directly (iterators/ranges are preferred there). */
    printf("p points to %d\n", *p);
    printf("p + 1 points to %d\n", *(p + 1));
    printf("p[2] (same as *(p + 2)) = %d\n", p[2]);

    /* Pointer subtraction gives the number of ELEMENTS between two
       pointers into the same array, not bytes -- another scaled operation. */
    int* end = &numbers[4];
    printf("end - p = %td elements apart\n", end - p);

    /* Bitwise operators: identical to C++, no overloading possible in
       either language for built-in types, but worth showing since C
       leans on raw bit manipulation more often (no std::bitset). */
    unsigned int flags = 0b1010;
    printf("flags = %u, flags | 0b0101 = %u, flags & 0b1100 = %u, flags << 1 = %u\n",
           flags, flags | 0b0101, flags & 0b1100, flags << 1);

    /* No operator overloading exists in C at all -- '+' on two structs
       below would be a compile error; C has no mechanism whatsoever to
       define it, unlike C++'s operator+. This is demonstrated by what is
       ABSENT, not by a runnable failure -- see README.md. */

    return 0;
}
