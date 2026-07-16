// solution-01.cpp - swap via references, contrasted with a broken value-parameter version.
#include <iostream>

void swapValues(int& a, int& b) {
    int temp = a;
    a = b;
    b = temp;
}

void swapValuesBroken(int a, int b) {
    int temp = a;
    a = b;
    b = temp;
}

int main() {
    int x = 1, y = 2;
    swapValues(x, y);
    std::cout << "After swapValues: x=" << x << ", y=" << y << std::endl;

    int p = 1, q = 2;
    swapValuesBroken(p, q);
    std::cout << "After swapValuesBroken: p=" << p << ", q=" << q << std::endl;

    return 0;
}
