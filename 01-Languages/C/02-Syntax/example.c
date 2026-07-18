/* example.c -- demonstrates the preprocessor, the (void) vs () trap, and
   the "no top-level statements" rule: every C file needs an explicit
   main; nothing can execute at file scope. */
#include <stdio.h>

/* #define is a preprocessor text-substitution macro -- it has no type and
   no scope; it is a pure find-and-replace performed before the compiler
   ever sees the token stream. */
#define GREETING "Hello from the preprocessor"

/* A conditional-compilation block -- entirely resolved before compilation,
   so exactly one of these two printf calls physically exists in the
   compiled object code, not both with a runtime branch. */
#define VERBOSE 1

/* void here genuinely means "takes no parameters" -- omitting it (an
   empty ()) would instead mean "unspecified parameters" in C, silently
   disabling the compiler's argument-count checking at every call site. */
static void showBuildMode(void) {
#if VERBOSE
    printf("Build mode: VERBOSE\n");
#else
    printf("Build mode: quiet\n");
#endif
}

int main(void) {
    printf("%s\n", GREETING);
    showBuildMode();

    /* Statements only exist inside function bodies -- there is no
       equivalent of Python's/JavaScript's top-level script statements.
       Everything before main() above is a declaration/macro, not code
       that runs. */
    return 0;
}
