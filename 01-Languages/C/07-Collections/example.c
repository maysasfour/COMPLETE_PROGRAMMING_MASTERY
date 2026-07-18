/* example.c -- fixed-size arrays, no bounds checking (demonstrated
   safely, in a controlled way, not as real undefined behavior we ship),
   and a hand-rolled dynamic array using malloc/realloc since C has no
   std::vector equivalent at all. */
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    /* A fixed-size array: its size is part of its type, known at compile
       time, and CANNOT grow. Unlike std::vector, there is no bounds
       checking on [] at all -- accessing scores[10] below would compile
       and run (reading whatever memory happens to be there) instead of
       throwing/erroring, a genuine and serious C footgun. */
    int scores[5] = {90, 85, 77, 92, 88};
    printf("Fixed-size array (size baked into the type, no growth possible):\n");
    for (size_t i = 0; i < 5; i++) {
        printf("scores[%zu] = %d\n", i, scores[i]);
    }

    /* sizeof(array) / sizeof(array[0]) is the classic C idiom for "how
       many elements does this array have" -- there is no .length or
       .size() method because a raw array is not an object, just a
       contiguous memory block with a compile-time-known size. */
    printf("sizeof(scores) = %zu bytes, element count = %zu\n",
           sizeof(scores), sizeof(scores) / sizeof(scores[0]));

    /* C has NO built-in dynamic/growable array type at all -- unlike
       C++'s std::vector<T>, which grows automatically. A C programmer
       must hand-roll this with malloc/realloc, manually tracking size
       and capacity. This is the single biggest ergonomic gap between
       C's and C++'s collection stories. */
    printf("\nHand-rolled dynamic array (malloc/realloc, no built-in vector):\n");
    size_t capacity = 2;
    size_t count = 0;
    int* dynArr = malloc(capacity * sizeof(int));
    if (dynArr == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }

    for (int i = 1; i <= 6; i++) {
        if (count == capacity) {
            capacity *= 2;   /* manual growth strategy -- std::vector does this internally */
            int* grown = realloc(dynArr, capacity * sizeof(int));
            if (grown == NULL) {
                fprintf(stderr, "realloc failed\n");
                free(dynArr);
                return 1;
            }
            dynArr = grown;
            printf("  (grew capacity to %zu)\n", capacity);
        }
        dynArr[count++] = i * i;
    }

    printf("dynArr contents (count=%zu, capacity=%zu): ", count, capacity);
    for (size_t i = 0; i < count; i++) {
        printf("%d ", dynArr[i]);
    }
    printf("\n");

    free(dynArr);   /* manual -- no destructor will do this for us; forgetting it leaks */
    dynArr = NULL;   /* good practice: avoid a dangling pointer after free */

    return 0;
}
