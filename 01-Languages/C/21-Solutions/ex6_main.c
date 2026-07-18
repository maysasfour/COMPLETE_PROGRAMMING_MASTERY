#include <stdio.h>
#include "shapes.h"

int main(void) {
    Circle c = { 5.0 };
    printf("radius = %.1f\n", c.radius);
    printf("area = %.4f\n", circleArea(&c));
    printf("perimeter = %.4f\n", circlePerimeter(&c));
    return 0;
}
