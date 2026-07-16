// example.cpp - default arguments, overloading, pass-by-value/reference/const-reference.
#include <iostream>
#include <string>

std::string greet(std::string name = "World") {
    return "Hello, " + name;
}

int add(int a, int b) { return a + b; }
double add(double a, double b) { return a + b; }

void incrementByValue(int x) { x++; }
void incrementByRef(int& x) { x++; }
void printByConstRef(const std::string& s) {
    std::cout << "printByConstRef: " << s << std::endl;
}

int main() {
    std::cout << "--- default arguments ---" << std::endl;
    std::cout << greet() << std::endl;
    std::cout << greet("Ada") << std::endl;

    std::cout << "\n--- overloading ---" << std::endl;
    std::cout << "add(2, 3): " << add(2, 3) << std::endl;
    std::cout << "add(2.5, 3.5): " << add(2.5, 3.5) << std::endl;

    std::cout << "\n--- pass-by-value vs pass-by-reference ---" << std::endl;
    int counter = 5;
    incrementByValue(counter);
    std::cout << "counter after incrementByValue: " << counter << " (unchanged)" << std::endl;
    incrementByRef(counter);
    std::cout << "counter after incrementByRef: " << counter << " (actually incremented)" << std::endl;

    printByConstRef("efficient, read-only");

    return 0;
}
