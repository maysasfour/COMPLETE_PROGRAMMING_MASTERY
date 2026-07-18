/* stringutils.c -- implementation matching stringutils.h. */
#include "stringutils.h"
#include <ctype.h>

int countVowels(const char* text) {
    int count = 0;
    for (const char* p = text; *p != '\0'; p++) {
        char c = (char)tolower((unsigned char)*p);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') {
            count++;
        }
    }
    return count;
}

void toUppercase(char* text) {
    for (char* p = text; *p != '\0'; p++) {
        *p = (char)toupper((unsigned char)*p);
    }
}
