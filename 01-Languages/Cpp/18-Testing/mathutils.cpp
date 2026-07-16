// mathutils.cpp - the implementation.
#include "mathutils.hpp"
#include <stdexcept>

int add(int a, int b) {
    return a + b;
}

double divideValues(double a, double b) {
    if (b == 0) throw std::invalid_argument("Cannot divide by zero");
    return a / b;
}
