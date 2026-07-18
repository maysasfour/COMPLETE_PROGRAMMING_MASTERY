/* mathutils.c -- the implementation matching mathutils.h's declarations.
   This is its own separate translation unit -- compiled independently
   of main.c, then linked together afterward (see README.md). */
#include "mathutils.h"

int addInts(int a, int b) {
    return a + b;
}

int multiplyInts(int a, int b) {
    return a * b;
}

double average(const int* values, int count) {
    if (count == 0) return 0.0;
    long sum = 0;
    for (int i = 0; i < count; i++) {
        sum += values[i];
    }
    return (double)sum / count;
}
