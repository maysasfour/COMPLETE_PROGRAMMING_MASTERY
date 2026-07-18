/* stringutils.h -- a second module, to show a real multi-file project
   is more than just "one header, one source" -- main.c links against
   both mathutils and stringutils independently. */
#ifndef STRINGUTILS_H
#define STRINGUTILS_H

/* Returns a count, and requires the caller to have allocated `out` with
   at least strlen(in) + 1 bytes -- no bounds checking is performed
   inside (consistent with Lesson 08's coverage of this real risk). */
int countVowels(const char* text);
void toUppercase(char* text);

#endif /* STRINGUTILS_H */
