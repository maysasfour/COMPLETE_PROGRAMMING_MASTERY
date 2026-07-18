/* example.c -- C strings are just null-terminated char arrays, <string.h>
   functions, and a REAL, safely-reproduced buffer overflow (in a
   heap-allocated struct we control, not the real call stack) showing
   strcpy's danger and strncpy's partial fix. */
#define _CRT_SECURE_NO_WARNINGS   /* MSVC deprecates strcpy/sprintf by default; we want to
                                     demonstrate the real, un-"improved" function on purpose */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void) {
    /* A C "string" is nothing but a char array with a trailing '\0' --
       there is no string type, no length stored anywhere alongside it.
       Every <string.h> function relies on scanning for that '\0'. */
    char greeting[20] = "Hello";
    printf("greeting = \"%s\", strlen = %zu, sizeof(array) = %zu\n",
           greeting, strlen(greeting), sizeof(greeting));

    strcat(greeting, ", C!");
    printf("after strcat: \"%s\"\n", greeting);

    /* strcmp: 0 means equal, nonzero (sign is implementation-defined
       beyond "positive"/"negative") otherwise -- nothing like ==. */
    printf("strcmp(\"abc\", \"abc\") = %d\n", strcmp("abc", "abc"));
    printf("strcmp(\"abc\", \"abd\") = %d (nonzero -- never compare C strings with ==)\n",
           strcmp("abc", "abd"));

    /* --- Controlled buffer overflow demonstration --- */
    /* We deliberately allocate a small struct on the HEAP with a fixed
       buffer immediately followed by a canary field, so we can safely
       observe corruption of *our own* adjacent memory without touching
       the real call stack (which MSVC's /GS stack-protector would
       otherwise detect and abort the process for, preventing us from
       observing anything). This is a real, reproduced overflow, just
       contained to memory we own and can safely inspect afterward. */
    struct Sandbox {
        char buffer[8];
        char canary[8];
    };
    struct Sandbox* box = malloc(sizeof(struct Sandbox));
    if (box == NULL) { fprintf(stderr, "malloc failed\n"); return 1; }

    strcpy(box->canary, "INTACT!");
    printf("\nBefore overflow: buffer=(empty), canary=\"%s\"\n", box->canary);

    /* "A very long string" is 19 characters + '\0' = 20 bytes, into an
       8-byte buffer[8] -- strcpy has NO length limit and NO bounds
       checking at all; it copies until it hits the source's '\0',
       wherever that is, overwriting canary[] (and technically anything
       else past it) with no warning, no error, no crash here because
       it's heap memory we control. This is the exact class of bug
       behind decades of real-world buffer-overflow security exploits. */
    strcpy(box->buffer, "A very long string");
    printf("After strcpy overflow: buffer=\"%s\", canary=\"%s\" (CORRUPTED -- overwritten by the overflow)\n",
           box->buffer, box->canary);

    /* The fix: strncpy caps the number of bytes copied at its 3rd
       argument. It does NOT null-terminate automatically if the source
       is >= that length, so we must terminate manually -- a real,
       commonly-missed strncpy gotcha in its own right. */
    strcpy(box->canary, "INTACT!");   /* reset for the fixed demonstration */
    memset(box->buffer, 0, sizeof(box->buffer));

    strncpy(box->buffer, "A very long string", sizeof(box->buffer) - 1);
    box->buffer[sizeof(box->buffer) - 1] = '\0';   /* strncpy does not guarantee this itself */
    printf("\nAfter strncpy (capped + manually terminated): buffer=\"%s\", canary=\"%s\" (intact)\n",
           box->buffer, box->canary);

    free(box);
    return 0;
}
