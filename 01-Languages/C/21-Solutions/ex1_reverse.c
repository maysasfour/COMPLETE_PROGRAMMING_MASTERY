/* Exercise 1: reverse an array using only pointer arithmetic. */
#include <stdio.h>
#include <stddef.h>

void reverseInPlace(int* arr, size_t n) {
    int* left = arr;
    int* right = arr + (n - 1);
    while (left < right) {
        int tmp = *left;
        *left = *right;
        *right = tmp;
        left++;
        right--;
    }
}

int main(void) {
    int values[] = { 1, 2, 3, 4, 5, 6 };
    size_t n = sizeof(values) / sizeof(values[0]);

    printf("Before: ");
    for (size_t i = 0; i < n; i++) printf("%d ", values[i]);
    printf("\n");

    reverseInPlace(values, n);

    printf("After:  ");
    for (size_t i = 0; i < n; i++) printf("%d ", values[i]);
    printf("\n");
    return 0;
}
