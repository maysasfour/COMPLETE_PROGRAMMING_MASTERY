/* Exercise 4: function-pointer callbacks driving a generic forEach --
   C's stand-in for higher-order functions, using raw function pointers
   (no lambdas/closures exist in C at all). */
#include <stdio.h>
#include <stddef.h>

void intArrayForEach(const int* arr, size_t n, void (*callback)(int)) {
    for (size_t i = 0; i < n; i++) {
        callback(arr[i]);
    }
}

static void printValue(int v) {
    printf("%d ", v);
}

static int g_sum = 0;   /* file-scope accumulator; C has no closures to capture locals */
static void accumulateSum(int v) {
    g_sum += v;
}

int main(void) {
    int values[] = { 3, 1, 4, 1, 5, 9, 2, 6 };
    size_t n = sizeof(values) / sizeof(values[0]);

    printf("Values: ");
    intArrayForEach(values, n, printValue);
    printf("\n");

    intArrayForEach(values, n, accumulateSum);
    printf("Sum via callback: %d\n", g_sum);

    return 0;
}
