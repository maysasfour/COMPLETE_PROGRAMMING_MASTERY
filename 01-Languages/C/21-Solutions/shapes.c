#include "shapes.h"

#define PI 3.14159265358979323846

double circleArea(const Circle* c) {
    return PI * c->radius * c->radius;
}

double circlePerimeter(const Circle* c) {
    return 2.0 * PI * c->radius;
}
