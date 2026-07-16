// example.cpp - value semantics by default, references vs pointers, auto/const.
#include <iostream>
#include <vector>
#include <string>

int main() {
    std::cout << "--- value semantics: copying a vector makes an independent copy ---" << std::endl;
    std::vector<int> a = {1, 2, 3};
    std::vector<int> b = a; // COPY, not an alias
    b.push_back(4);
    std::cout << "a.size() after mutating b: " << a.size() << " (unchanged)" << std::endl;
    std::cout << "b.size(): " << b.size() << std::endl;

    std::cout << "\n--- references ---" << std::endl;
    int x = 5;
    int& ref = x;
    ref = 10;
    std::cout << "x after modifying through ref: " << x << std::endl;

    std::cout << "\n--- pointers ---" << std::endl;
    int* ptr = &x;
    *ptr = 20;
    std::cout << "x after modifying through ptr: " << x << std::endl;
    ptr = nullptr;
    std::cout << "ptr reassigned to nullptr: " << (ptr == nullptr) << std::endl;

    std::cout << "\n--- auto and const ---" << std::endl;
    auto count = 42;
    auto name = std::string("Ada");
    const int maxRetries = 3;
    std::cout << "count=" << count << ", name=" << name << ", maxRetries=" << maxRetries << std::endl;

    return 0;
}
