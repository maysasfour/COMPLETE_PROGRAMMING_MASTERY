/* example.c -- no default arguments, no overloading, and function
   pointers (a real, first-class value in C, foundational for Lesson 12). */
#include <stdio.h>

/* No default arguments exist in C -- every call must supply every
   parameter explicitly. The common workaround is a sentinel value
   (here, -1 means "use the default retries value"). */
int connect(const char* host, int retries) {
    if (retries < 0) retries = 3; /* manual "default" */
    printf("connecting to %s with %d retries\n", host, retries);
    return retries;
}

/* No function overloading exists in C either -- you cannot declare a
   second `add` taking doubles; C would treat that as a redefinition
   error. The real-world workaround is distinct names per type
   ("addInt"/"addDouble") or, for genuine type-generic dispatch,
   _Generic (Lesson 13). */
int addInt(int a, int b) { return a + b; }
double addDouble(double a, double b) { return a + b; }

/* A function pointer: a variable that stores the ADDRESS of a function,
   callable through that pointer just like calling the function directly.
   This is what qsort's comparator (Lesson 12) and C's manual "vtable"
   pattern (Lesson 11) are both built on. */
int square(int x) { return x * x; }
int cube(int x) { return x * x * x; }

int applyOperation(int x, int (*operation)(int)) {
    return operation(x);
}

int main(void) {
    connect("example.com", -1);   /* uses the sentinel "default" */
    connect("example.com", 5);    /* explicit override */

    printf("addInt(2, 3) = %d\n", addInt(2, 3));
    printf("addDouble(2.5, 3.5) = %f\n", addDouble(2.5, 3.5));

    /* Declare a function pointer variable explicitly and call through it. */
    int (*opPtr)(int) = square;
    printf("opPtr(4) = %d (opPtr currently holds square's address)\n", opPtr(4));
    opPtr = cube;
    printf("opPtr(4) = %d (opPtr now holds cube's address)\n", opPtr(4));

    /* Pass a function pointer as an argument -- the callback pattern
       Lesson 12 builds on directly. */
    printf("applyOperation(5, square) = %d\n", applyOperation(5, square));
    printf("applyOperation(5, cube) = %d\n", applyOperation(5, cube));

    return 0;
}
