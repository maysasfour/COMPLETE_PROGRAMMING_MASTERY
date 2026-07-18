# C Cheat Sheet

[Back to course overview](README.md)

## Compile / Run

```bash
gcc -std=c17 -Wall -Wextra file.c -o app && ./app
clang -std=c17 file.c -o app && ./app
cl /std:c17 /W4 file.c && file.exe                 # MSVC (Developer Command Prompt)
cl /std:c17 main.c other.c /Fe:app.exe && app.exe   # multi-file
```

## Variables and Types

```c
int i = 30;              /* usually 32-bit, not guaranteed */
long l = 30L;
long long ll = 30LL;
unsigned int u = 30u;
float f = 3.14f;
double d = 3.14;
char c = 'A';
bool b = true;            /* <stdbool.h>, C99+ */
const int max = 3;        /* compile-time-enforced read-only */
size_t n = sizeof(int);   /* unsigned, platform's natural size type */

int arr[5] = {1,2,3,4,5};
int* p = &i;               /* pointer: holds an address */
*p = 42;                    /* dereference: writes through the pointer */
```

## Operators

```c
a == b; a != b; a < b; a && b; a || b; !a;
a & b; a | b; a ^ b; ~a; a << 1; a >> 1;   /* bitwise */
p + 1;      /* pointer arithmetic -- advances by sizeof(*p) bytes, NO bounds checking */
&x;         /* address-of */
*p;         /* dereference */
```

## Control Flow

```c
if (x > 0) { } else if (x < 0) { } else { }
switch (x) { case 1: /* ... */ break; default: break; }  /* fall-through by default */
for (int i = 0; i < n; i++) { }
while (cond) { }
do { } while (cond);
```

## Functions

```c
int add(int a, int b) { return a + b; }
void modify(int* out) { *out = 42; }        /* "output parameter" -- C has no references */
int main(void) { return 0; }                 /* (void), NOT () -- empty () means unspecified args */
```

## Arrays and Strings

```c
int nums[5];                       /* fixed size, no bounds checking, no built-in dynamic array */
char name[32] = "Ada";              /* NUL-terminated char array */
strlen(name); strcmp(a, b);         /* <string.h> -- never use == to compare string CONTENTS */
strncpy(dest, src, n - 1); dest[n-1] = '\0';   /* strncpy does NOT guarantee NUL-termination */
snprintf(buf, sizeof(buf), "%d", x);           /* bounds-safe formatted write */
```

## Structs and Unions (C's Stand-in for Objects)

```c
typedef struct {
    char owner[64];
    double balance;
} Account;

void accountDeposit(Account* acc, double amount) { acc->balance += amount; }  /* -> for pointers */
Account a;
a.balance = 100.0;                 /* . for values */

typedef union { int i; float f; } Number;   /* all members share the same memory */
```

## Pointers and Memory (Manual, No GC, No RAII)

```c
int* p = malloc(sizeof(int));      /* uninitialized memory */
int* z = calloc(1, sizeof(int));   /* zero-initialized memory */
p = realloc(p, 2 * sizeof(int));   /* grow/shrink; may move the block */
free(p);                            /* every malloc/calloc/realloc needs exactly one matching free */
p = NULL;                           /* avoid a dangling pointer after free */
```

## Function Pointers / Callbacks

```c
void forEach(const int* arr, size_t n, void (*cb)(int)) {
    for (size_t i = 0; i < n; i++) cb(arr[i]);
}
void printer(int v) { printf("%d\n", v); }
forEach(nums, 5, printer);
```

## Error Handling (No Exceptions)

```c
int divide(int a, int b, int* out) {
    if (b == 0) return -1;    /* return-code convention */
    *out = a / b;
    return 0;
}

errno = 0;
FILE* f = fopen("x.txt", "r");
if (!f) printf("%s\n", strerror(errno));
```

## File I/O

```c
FILE* f = fopen("data.txt", "w");
fprintf(f, "%d\n", 42);
fclose(f);

FILE* in = fopen("data.txt", "r");
char line[256];
while (fgets(line, sizeof(line), in)) { /* ... */ }
fclose(in);
```

## No Generics — `void*` or Macros

```c
int cmp(const void* a, const void* b) {
    return (*(const int*)a) - (*(const int*)b);
}
qsort(arr, n, sizeof(int), cmp);   /* type-erased "generic" sort via void* + a comparator */
```

## Header/Source Split

```c
/* shapes.h */
#ifndef SHAPES_H
#define SHAPES_H
typedef struct { double radius; } Circle;
double circleArea(const Circle* c);
#endif

/* shapes.c */
#include "shapes.h"
double circleArea(const Circle* c) { return 3.14159 * c->radius * c->radius; }
```

## Common stdlib Idioms

```c
#include <stdio.h>    /* printf, fopen, FILE */
#include <stdlib.h>   /* malloc, free, atoi, qsort, EXIT_SUCCESS */
#include <string.h>   /* strlen, strcmp, strcpy, strncpy, strtok, memcpy */
#include <math.h>     /* sqrt, pow, fabs -- link with -lm on gcc/clang */
#include <ctype.h>    /* isdigit, isalpha, toupper, tolower */
#include <assert.h>   /* assert(cond) -- debugging aid, aborts on failure, not a test framework */
#include <stdbool.h>  /* bool, true, false -- C99+ */
#include <stdint.h>   /* fixed-width ints: int32_t, uint8_t, etc. */
```

## Test Harness Pattern (No Built-in Framework)

```c
#define ASSERT_EQ_INT(expected, actual) \
    do { if ((expected) != (actual)) printf("FAIL line %d\n", __LINE__); } while (0)
```
