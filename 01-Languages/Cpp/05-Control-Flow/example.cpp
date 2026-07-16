// example.cpp - if/switch, range-based for with const auto&, structured bindings.
#include <iostream>
#include <vector>
#include <utility>
#include <string>

int main() {
    std::cout << "--- if/else ---" << std::endl;
    int temperature = 20;
    if (temperature > 30) std::cout << "hot" << std::endl;
    else if (temperature > 15) std::cout << "warm" << std::endl;
    else std::cout << "cool" << std::endl;

    std::cout << "\n--- switch (fall-through requires break) ---" << std::endl;
    switch (temperature) {
        case 30:
            std::cout << "exactly 30" << std::endl;
            break;
        default:
            std::cout << "not exactly 30" << std::endl;
            break;
    }

    std::cout << "\n--- range-based for with const auto& (no copies) ---" << std::endl;
    std::vector<int> numbers = {1, 2, 3};
    for (const auto& n : numbers) {
        std::cout << n << " ";
    }
    std::cout << std::endl;

    std::cout << "\n--- structured binding ---" << std::endl;
    std::pair<int, std::string> entry = {1, "Ada"};
    auto [id, name] = entry;
    std::cout << "id=" << id << ", name=" << name << std::endl;

    return 0;
}
