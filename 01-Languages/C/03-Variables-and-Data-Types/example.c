/* example.c -- primitive types, sizeof, and stdbool.h's bool (not built
   into the language itself the way C++'s bool is). */
#include <stdio.h>
#include <stdbool.h>   /* without this include, 'bool'/'true'/'false' do not exist pre-C23 */
#include <limits.h>    /* INT_MAX etc. -- sizes are not fixed by the language, only by the platform */

int main(void) {
    /* Signed/unsigned integer types -- sizes are platform-defined minimums,
       not fixed values (unlike Java's guaranteed-width int/long). */
    char c = 'A';
    short s = 32000;
    int i = -7;
    long l = 100000L;
    long long ll = 9000000000LL;
    unsigned int ui = 4000000000U;

    float f = 3.14f;
    double d = 3.14159265358979;

    /* bool only exists because <stdbool.h> #defines it to _Bool plus
       true/false macros -- pre-C99, C had no boolean type at all and
       code used plain int (0 = false, anything else = true), which is
       still legal and common in real C code today. */
    bool isReady = true;

    printf("char c = %c, sizeof(char) = %zu byte\n", c, sizeof(char));
    printf("short s = %d, sizeof(short) = %zu bytes\n", s, sizeof(short));
    printf("int i = %d, sizeof(int) = %zu bytes, INT_MAX = %d\n", i, sizeof(int), INT_MAX);
    printf("long l = %ld, sizeof(long) = %zu bytes\n", l, sizeof(long));
    printf("long long ll = %lld, sizeof(long long) = %zu bytes\n", ll, sizeof(long long));
    printf("unsigned int ui = %u\n", ui);
    printf("float f = %f, sizeof(float) = %zu bytes\n", f, sizeof(float));
    printf("double d = %.11f, sizeof(double) = %zu bytes\n", d, sizeof(double));
    printf("bool isReady = %d (stdbool.h's bool is just _Bool; %%d is the only correct printf spec for it)\n", isReady);

    /* const in C is a much weaker guarantee than C++'s: it only prevents
       *this* variable from being reassigned through its own name -- it
       does not create a genuine compile-time constant the way C++'s
       constexpr or even a plain C++ const at namespace scope can. */
    const int maxRetries = 3;
    printf("maxRetries = %d\n", maxRetries);

    return 0;
}
