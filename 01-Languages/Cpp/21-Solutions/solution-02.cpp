// solution-02.cpp - Exercise 02: reproduce slicing, then fix it with a reference parameter.
#include <iostream>
#include <string>
#include <numbers>

class Shape {
public:
    virtual double area() const { return 0.0; }
    virtual std::string describe() const { return "Shape"; }
    virtual ~Shape() = default; // virtual destructor: mandatory for any polymorphic base
};

class Circle : public Shape {
    double radius;
public:
    explicit Circle(double r) : radius(r) {}
    double area() const override { return std::numbers::pi * radius * radius; }
    std::string describe() const override { return "Circle"; }
};

class Square : public Shape {
    double side;
public:
    explicit Square(double s) : side(s) {}
    double area() const override { return side * side; }
    std::string describe() const override { return "Square"; }
};

// Taking Shape BY VALUE means the parameter `s` is a genuinely new Shape object,
// copy-constructed from only the Shape portion of whatever was passed in -- the
// Circle-specific `radius` member and its vtable pointer are gone. Every virtual
// call here resolves against the base Shape, not the original Circle.
void printSlicedArea(Shape s) {
    std::cout << "  printSlicedArea -> describe(): " << s.describe()
              << ", area(): " << s.area() << std::endl;
}

// A reference binds to the ORIGINAL object -- no copy, no slicing. Virtual dispatch
// resolves against the real, complete Circle, exactly as intended.
void printCorrectArea(const Shape& s) {
    std::cout << "  printCorrectArea -> describe(): " << s.describe()
              << ", area(): " << s.area() << std::endl;
}

int main() {
    Circle c(2.0);
    const double expectedArea = std::numbers::pi * 2.0 * 2.0;

    std::cout << "--- pass-by-value: SLICED ---" << std::endl;
    printSlicedArea(c);
    std::cout << "  (expected \"Circle\" and area " << expectedArea
              << " -- got \"Shape\" and area 0, because the Circle part was sliced off)" << std::endl;

    std::cout << "\n--- pass-by-reference: CORRECT ---" << std::endl;
    printCorrectArea(c);
    std::cout << "  (correctly reports \"Circle\" and area " << expectedArea << ")" << std::endl;

    return 0;
}
