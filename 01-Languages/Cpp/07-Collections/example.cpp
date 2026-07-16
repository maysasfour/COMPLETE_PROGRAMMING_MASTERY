// example.cpp - vector/map/set, operator[] vs .at(), <algorithm> functions.
#include <iostream>
#include <vector>
#include <map>
#include <set>
#include <algorithm>
#include <numeric>
#include <string>
#include <stdexcept>

int main() {
    std::cout << "--- vector, map, set ---" << std::endl;
    std::vector<int> scores = {95, 88, 76};
    scores.push_back(100);
    std::cout << "scores[0]: " << scores[0] << std::endl;
    std::cout << "scores.at(0): " << scores.at(0) << std::endl;
    try {
        int unused = scores.at(100); // out of range -- throws, unlike scores[100] which would be UB
        (void)unused;
    } catch (const std::out_of_range& e) {
        std::cout << "scores.at(100) correctly threw: " << e.what() << std::endl;
    }

    std::map<std::string, int> ages = {{"Ada", 30}};
    std::cout << "ages[\"Ada\"]: " << ages["Ada"] << std::endl;
    std::cout << "ages.count(\"Unknown\"): " << ages.count("Unknown") << " (safe existence check)" << std::endl;

    std::set<std::string> uniqueTags = {"js", "css", "js"};
    std::cout << "uniqueTags.size() (duplicates removed): " << uniqueTags.size() << std::endl;

    std::cout << "\n--- <algorithm> functions ---" << std::endl;
    std::vector<int> numbers = {1, 2, 3, 4, 5};

    std::sort(numbers.begin(), numbers.end(), std::greater<int>());
    std::cout << "sorted descending: ";
    for (const auto& n : numbers) std::cout << n << " ";
    std::cout << std::endl;

    int total = std::accumulate(numbers.begin(), numbers.end(), 0);
    int evenCount = std::count_if(numbers.begin(), numbers.end(), [](int n) { return n % 2 == 0; });
    bool hasEven = std::any_of(numbers.begin(), numbers.end(), [](int n) { return n % 2 == 0; });

    std::cout << "total: " << total << std::endl;
    std::cout << "evenCount: " << evenCount << std::endl;
    std::cout << "hasEven: " << hasEven << std::endl;

    return 0;
}
