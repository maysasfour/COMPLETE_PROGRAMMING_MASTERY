// example.cpp - nullptr, comparison/ternary, pointer arithmetic.
#include <iostream>

int main() {
    std::cout << "--- nullptr ---" << std::endl;
    int* ptr = nullptr;
    std::cout << "ptr == nullptr: " << (ptr == nullptr) << std::endl;

    std::cout << "\n--- comparison and ternary ---" << std::endl;
    int a = 5, b = 10;
    std::cout << "a == b: " << (a == b) << std::endl;
    std::cout << (a < b ? "a is smaller" : "b is smaller or equal") << std::endl;

    std::cout << "\n--- pointer arithmetic ---" << std::endl;
    int arr[] = {10, 20, 30};
    int* p = arr;
    std::cout << "*p: " << *p << std::endl;
    std::cout << "*(p + 1): " << *(p + 1) << std::endl;
    p++;
    std::cout << "*p after p++: " << *p << std::endl;

    return 0;
}
