/* example.c -- structs, unions, and a real minimal "polymorphism via
   function-pointer struct" demo -- C's actual OOP-adjacent feature,
   since it has no classes/inheritance/virtual functions at all. */
#include <stdio.h>

/* A plain struct: fields laid out in memory, no methods, no access
   control, no inheritance. */
typedef struct {
    int x;
    int y;
} Point;

/* A union: ALL members share the SAME memory -- writing one member and
   reading a different one reinterprets those same bytes as the new
   type. sizeof(union) is the size of its LARGEST member, not the sum. */
typedef union {
    int asInt;
    float asFloat;
    char asBytes[4];
} IntOrFloat;

/* --- Manual "polymorphism" via a struct of function pointers --- */
/* This is C's actual substitute for C++ virtual functions: a "Shape"
   struct holding data PLUS function pointers acting as a hand-rolled
   vtable. Each "subtype" (Circle, Rectangle) provides its own function
   implementations and stores them in its own Shape instance. */
typedef struct Shape {
    void* self;                                  /* pointer to the concrete data (a Circle or Rectangle) */
    double (*area)(const struct Shape*);          /* the "virtual function" */
    const char* (*name)(const struct Shape*);
} Shape;

typedef struct { double radius; } Circle;
typedef struct { double width, height; } Rectangle;

static double circleArea(const Shape* shape) {
    const Circle* c = (const Circle*)shape->self;   /* explicit cast -- no dynamic_cast exists */
    return 3.14159265358979 * c->radius * c->radius;
}
static const char* circleName(const Shape* shape) {
    (void)shape;   /* unused in this simple case, but the "virtual function" signature requires it */
    return "Circle";
}

static double rectangleArea(const Shape* shape) {
    const Rectangle* r = (const Rectangle*)shape->self;
    return r->width * r->height;
}
static const char* rectangleName(const Shape* shape) {
    (void)shape;
    return "Rectangle";
}

int main(void) {
    Point p = {3, 4};
    printf("Point: (%d, %d)\n", p.x, p.y);

    /* Union demonstration: writing asInt then reading asBytes shows the
       SAME 4 bytes reinterpreted, proving they share memory (not copies). */
    IntOrFloat u;
    u.asInt = 65;   /* 'A' in ASCII, as the low byte on a little-endian machine */
    printf("\nUnion: wrote asInt = %d, sizeof(union) = %zu bytes (size of its largest member)\n",
           u.asInt, sizeof(u));
    printf("Reading the SAME memory as asBytes[0] = %d (== 'A' == 65, same bits, reinterpreted)\n",
           (int)(unsigned char)u.asBytes[0]);

    u.asFloat = 3.14f;
    printf("After writing asFloat = 3.14, asInt now reads as %d (garbage as an int -- same bits, different type)\n",
           u.asInt);

    /* Manual polymorphism: an ARRAY of Shape, each pointing at different
       concrete data and different function implementations -- called
       through the SAME uniform interface, exactly like calling a
       virtual function through a base-class pointer in C++. */
    printf("\nManual polymorphism via function-pointer struct (C's vtable substitute):\n");
    Circle circleData = {5.0};
    Rectangle rectData = {4.0, 6.0};

    Shape shapes[2];
    shapes[0] = (Shape){ .self = &circleData, .area = circleArea, .name = circleName };
    shapes[1] = (Shape){ .self = &rectData, .area = rectangleArea, .name = rectangleName };

    for (size_t i = 0; i < 2; i++) {
        /* Uniform call site -- doesn't know or care which concrete type
           it's calling; the function pointer in each Shape decides. */
        printf("  %s: area = %.2f\n", shapes[i].name(&shapes[i]), shapes[i].area(&shapes[i]));
    }

    return 0;
}
