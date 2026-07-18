/* example.c -- qsort with a comparator function pointer, plus a
   generic "for each" callback pattern -- C's substitute for
   higher-order functions/lambdas, which it has neither of. */
#include <stdio.h>
#include <stdlib.h>

/* qsort's comparator contract: return negative if a < b, zero if equal,
   positive if a > b. Both parameters arrive as `const void*` -- qsort
   is itself generic via type erasure through void*, and the comparator
   must cast them back to the real type manually (Lesson 13 explores
   this void*-based "generics" pattern in depth). */
int compareInts(const void* a, const void* b) {
    int ia = *(const int*)a;
    int ib = *(const int*)b;
    return (ia > ib) - (ia < ib);   /* avoids potential overflow of a plain ia - ib */
}

int compareIntsDescending(const void* a, const void* b) {
    return compareInts(b, a);   /* reuse by swapping argument order */
}

/* A generic "for each" callback: applies `action` to every element.
   This is the closest C gets to a higher-order function -- there is no
   lambda syntax, so callers must define/pass a named function. */
void forEachInt(const int* array, size_t count, void (*action)(int)) {
    for (size_t i = 0; i < count; i++) {
        action(array[i]);
    }
}

void printDoubled(int value) {
    printf("%d ", value * 2);
}

int main(void) {
    int numbers[] = {5, 2, 8, 1, 9, 3};
    size_t count = sizeof(numbers) / sizeof(numbers[0]);

    printf("original: ");
    for (size_t i = 0; i < count; i++) printf("%d ", numbers[i]);
    printf("\n");

    /* qsort takes: the array, element count, element size, and a
       comparator function pointer -- fully generic via void pointers
       plus explicit sizeof, C's real substitute for a templated std::sort. */
    qsort(numbers, count, sizeof(int), compareInts);
    printf("ascending: ");
    for (size_t i = 0; i < count; i++) printf("%d ", numbers[i]);
    printf("\n");

    qsort(numbers, count, sizeof(int), compareIntsDescending);
    printf("descending: ");
    for (size_t i = 0; i < count; i++) printf("%d ", numbers[i]);
    printf("\n");

    printf("\ndoubled via callback: ");
    forEachInt(numbers, count, printDoubled);
    printf("\n");

    return 0;
}
