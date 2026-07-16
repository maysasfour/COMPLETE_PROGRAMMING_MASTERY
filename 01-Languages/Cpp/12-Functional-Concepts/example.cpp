// example.cpp - lambda capture modes, std::function, <algorithm> with lambdas.
#include <iostream>
#include <functional>
#include <vector>
#include <algorithm>
#include <iterator>

int main() {
    std::cout << "--- capture by value vs by reference ---" << std::endl;
    int multiplier = 3;
    auto byValue = [multiplier](int n) { return n * multiplier; };
    auto byRef = [&multiplier](int n) { return n * multiplier; };

    multiplier = 10;
    std::cout << "byValue(5) (uses captured copy, still 3): " << byValue(5) << std::endl;
    std::cout << "byRef(5) (uses current value via reference, now 10): " << byRef(5) << std::endl;

    std::cout << "\n--- std::function ---" << std::endl;
    std::function<int(int, int)> add = [](int a, int b) { return a + b; };
    std::cout << "add(2, 3): " << add(2, 3) << std::endl;

    std::cout << "\n--- <algorithm> with a lambda (like .map()) ---" << std::endl;
    std::vector<int> numbers = {1, 2, 3, 4, 5};
    std::vector<int> doubled;
    std::transform(numbers.begin(), numbers.end(), std::back_inserter(doubled),
        [](int n) { return n * 2; });
    std::cout << "doubled: ";
    for (const auto& n : doubled) std::cout << n << " ";
    std::cout << std::endl;

    return 0;
}
