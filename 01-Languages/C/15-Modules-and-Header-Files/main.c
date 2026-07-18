/* main.c -- links against mathutils.c and stringutils.c, each compiled
   as its OWN separate translation unit, then linked together into one
   executable (see README.md's compile-then-link commands). C has no
   "module" language keyword or package manager (Lesson 15's honest gap)
   -- this header/.c-file split plus separate compilation IS C's entire
   answer to organizing code across multiple files. */
#include <stdio.h>
#include "mathutils.h"
#include "stringutils.h"

int main(void) {
    printf("-- mathutils.c --\n");
    printf("addInts(3, 4) = %d\n", addInts(3, 4));
    printf("multiplyInts(3, 4) = %d\n", multiplyInts(3, 4));

    int scores[] = {90, 85, 77, 92, 88};
    printf("average(scores, 5) = %.2f\n", average(scores, 5));

    printf("\n-- stringutils.c --\n");
    const char* phrase = "Hello, Modular C!";
    printf("countVowels(\"%s\") = %d\n", phrase, countVowels(phrase));

    char buffer[] = "hello, modular c!";
    toUppercase(buffer);
    printf("toUppercase result: %s\n", buffer);

    return 0;
}
