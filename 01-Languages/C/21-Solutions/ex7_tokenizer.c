/* Exercise 7: strtok-based tokenizing. strtok mutates its input buffer
   in place (writes '\0' where each delimiter was) -- it is NOT safe to
   call on a string literal, which C may place in read-only memory;
   a modifiable local buffer is used here instead. */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <string.h>

int main(void) {
    char buffer[] = "apples,bread,milk,eggs";   /* modifiable copy, not a literal pointer */

    printf("Tokens:\n");
    char* token = strtok(buffer, ",");
    while (token != NULL) {
        printf("  %s\n", token);
        token = strtok(NULL, ",");   /* NULL continues tokenizing the same buffer */
    }

    return 0;
}
