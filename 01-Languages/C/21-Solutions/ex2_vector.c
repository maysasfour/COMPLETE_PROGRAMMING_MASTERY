/* Exercise 2: a minimal dynamic growable array, with allocation tracking
   to prove every malloc/realloc is eventually matched by one free. */
#include <stdio.h>
#include <stdlib.h>

static int g_allocs = 0;
static int g_frees = 0;

typedef struct {
    int* data;
    size_t length;
    size_t capacity;
} Vec;

static void vecInit(Vec* v) {
    v->data = NULL;
    v->length = 0;
    v->capacity = 0;
}

static void vecPush(Vec* v, int value) {
    if (v->length == v->capacity) {
        size_t newCap = (v->capacity == 0) ? 4 : v->capacity * 2;
        int* newData = (int*)realloc(v->data, newCap * sizeof(int));
        if (v->data == NULL) g_allocs++;   /* first realloc == the initial malloc-equivalent */
        v->data = newData;
        v->capacity = newCap;
    }
    v->data[v->length++] = value;
}

static void vecFree(Vec* v) {
    free(v->data);
    g_frees++;
    v->data = NULL;
    v->length = v->capacity = 0;
}

int main(void) {
    Vec v;
    vecInit(&v);

    for (int i = 1; i <= 10; i++) {
        vecPush(&v, i * i);
    }

    printf("length=%zu capacity=%zu\n", v.length, v.capacity);
    printf("contents: ");
    for (size_t i = 0; i < v.length; i++) printf("%d ", v.data[i]);
    printf("\n");

    vecFree(&v);
    printf("allocs=%d frees=%d (balanced=%s)\n",
           g_allocs, g_frees, (g_allocs == g_frees) ? "yes" : "no");
    return 0;
}
