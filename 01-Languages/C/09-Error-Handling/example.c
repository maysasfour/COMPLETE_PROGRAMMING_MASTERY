/* example.c -- C has NO exceptions at all: errno, return-code
   conventions, and setjmp/longjmp as a rarely-used non-local escape hatch. */
#define _CRT_SECURE_NO_WARNINGS   /* strerror is deprecated (in favor of strerror_s) by
                                     MSVC by default; used deliberately here for portability */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <setjmp.h>

/* Return-code convention: a function signals failure via its return
   value, and the CALLER is responsible for checking it -- nothing
   forces this the way an uncaught exception would. Forgetting to check
   is the single most common C error-handling bug. */
int divide(int a, int b, int* result) {
    if (b == 0) {
        return -1;   /* failure: division by zero */
    }
    *result = a / b;
    return 0;   /* success */
}

int main(void) {
    int result;

    if (divide(10, 2, &result) == 0) {
        printf("10 / 2 = %d\n", result);
    }

    if (divide(10, 0, &result) != 0) {
        printf("divide(10, 0) failed as expected (return-code convention)\n");
    }

    /* errno: a global (thread-local in practice) integer set by many
       standard library functions on failure. It is NOT cleared
       automatically on success, so it must be zeroed before a call
       whose failure you intend to detect via errno specifically. */
    errno = 0;
    FILE* f = fopen("this_file_does_not_exist_12345.txt", "r");
    if (f == NULL) {
        /* strerror translates the errno value into a human-readable
           message -- there is no exception object carrying this data. */
        printf("fopen failed as expected: errno=%d (%s)\n", errno, strerror(errno));
    } else {
        fclose(f);
    }

    /* setjmp/longjmp: a rarely-used escape hatch for jumping back to a
       previously saved point in the call stack, skipping over any
       number of intervening function calls -- the closest thing C has
       to throw/catch, but with NO automatic cleanup of anything
       (no destructors, no RAII) along the way, unlike a C++ exception
       unwinding through stack frames. Real C code avoids this except in
       niche cases (some test frameworks, deeply nested error bailouts
       in parsers). */
    static jmp_buf recoveryPoint;
    int jumpValue = setjmp(recoveryPoint);
    if (jumpValue == 0) {
        printf("\nsetjmp: first pass, jumpValue = %d\n", jumpValue);
        printf("about to longjmp back to setjmp...\n");
        longjmp(recoveryPoint, 42);   /* "throws" 42 back to the setjmp call site --
                                          everything after this call is unreachable,
                                          intentionally, so nothing follows it here */
    } else {
        printf("setjmp: resumed after longjmp, jumpValue = %d\n", jumpValue);
    }

    return 0;
}
