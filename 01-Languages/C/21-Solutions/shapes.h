/* Exercise 6: header/source split, following Lesson 15's convention. */
#ifndef SHAPES_H
#define SHAPES_H

typedef struct {
    double radius;
} Circle;

double circleArea(const Circle* c);
double circlePerimeter(const Circle* c);

#endif /* SHAPES_H */
