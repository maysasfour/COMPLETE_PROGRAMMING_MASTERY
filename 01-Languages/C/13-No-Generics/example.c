/* example.c -- C has NO generics/templates at all. void* + explicit
   casting is the traditional workaround; _Generic (C11) is the closest
   thing to type-based dispatch, but it is compile-time selection
   among ALREADY-WRITTEN type-specific code, not true generic code
   generation the way a C++ template is. */
#include <stdio.h>

/* --- Workaround 1: void* + explicit casting (the traditional way) --- */
/* A "generic" container via void* -- but ALL type safety is gone. The
   caller must remember what type was actually stored and cast it back
   correctly themselves; the compiler cannot help at all. */
typedef struct {
    void* value;
} Box;

Box boxWrap(void* value) {
    Box b;
    b.value = value;
    return b;
}

/* --- For the _Generic-dispatched "generic max" below: still requires a
   SEPARATE, already-written function per type; _Generic only picks
   WHICH one to call based on the argument's type at compile time --
   there is no single generic definition generating both from one
   source, unlike a C++ template. */
int maxInt(int a, int b) { return a > b ? a : b; }
double maxDouble(double a, double b) { return a > b ? a : b; }

#define genericMax(x, y) _Generic((x), \
        int: maxInt, \
        double: maxDouble \
    )(x, y)

int main(void) {
    int i = 42;
    double d = 3.14;

    Box boxedInt = boxWrap(&i);
    Box boxedDouble = boxWrap(&d);

    /* The caller MUST know and correctly cast back to the right type --
       nothing stops a mismatched cast from compiling; it would just
       silently misinterpret the bytes at runtime. */
    printf("boxedInt: %d\n", *(int*)boxedInt.value);
    printf("boxedDouble: %f\n", *(double*)boxedDouble.value);

    /* --- Workaround 2: _Generic (C11) -- the closest thing to type-based
       dispatch C has. This is macro-like compile-time SELECTION among
       branches YOU already wrote for each type -- not code generation
       from a single generic definition the way a C++ template is. Every
       branch must already exist, written out, for every type you want
       to support. */
#define describe(x) _Generic((x), \
        int: "int", \
        double: "double", \
        char*: "char*", \
        default: "unknown type" \
    )

    int anInt = 7;
    double aDouble = 2.5;
    char* aString = "hello";

    printf("\n_Generic type dispatch (compile-time selection, not template code generation):\n");
    /* _Generic's controlling expression is a special case: it is used
       only to inspect the operand's TYPE at compile time and is never
       actually evaluated at runtime (C11 6.5.1.1p3) -- so printing each
       variable's own value alongside describe(...) here is what makes
       the variables genuinely "used", avoiding an "initialized but not
       referenced" warning that a bare describe(anInt) call alone would
       trigger, since _Generic itself never reads anInt's value. */
    printf("describe(anInt) = %s (anInt = %d)\n", describe(anInt), anInt);
    printf("describe(aDouble) = %s (aDouble = %f)\n", describe(aDouble), aDouble);
    printf("describe(aString) = %s (aString = %s)\n", describe(aString), aString);

    printf("\ngenericMax(3, 9) = %d (dispatches to maxInt at compile time)\n", genericMax(3, 9));
    printf("genericMax(3.5, 1.5) = %f (dispatches to maxDouble at compile time)\n", genericMax(3.5, 1.5));

    return 0;
}
