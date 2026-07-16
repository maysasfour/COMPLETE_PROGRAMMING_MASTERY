// solution-01.cpp - FizzBuzz with if/else, combined with a range-based for.
#include <iostream>
#include <string>
#include <vector>

std::string fizzBuzz(int n) {
    if (n % 15 == 0) return "FizzBuzz";
    if (n % 3 == 0) return "Fizz";
    if (n % 5 == 0) return "Buzz";
    return std::to_string(n);
}

int main() {
    std::vector<int> numbers;
    for (int i = 1; i <= 15; i++) numbers.push_back(i);

    for (const auto& n : numbers) {
        std::cout << fizzBuzz(n) << std::endl;
    }
    return 0;
}
