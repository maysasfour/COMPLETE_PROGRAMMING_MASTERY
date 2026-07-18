/* example.c -- the traditional first C program, plus a check of which C
   standard the compiler is actually using (see the Common Mistakes section
   in README.md for why this matters more in C than in most other languages
   this repository covers). */
#include <stdio.h>

int main(void) {
    printf("Hello, C!\n");

    /* __STDC_VERSION__ is only defined starting from C94/C95 (undefined
       under strict C89). Printing it confirms which standard flag the
       compiler actually honored, since (unlike C++'s __cplusplus under
       MSVC) this one is NOT subject to a similar freezing quirk. */
#ifdef __STDC_VERSION__
    printf("__STDC_VERSION__ = %ldL\n", __STDC_VERSION__);
#else
    printf("__STDC_VERSION__ is not defined (pre-C95 compiler)\n");
#endif

    return 0;
}
