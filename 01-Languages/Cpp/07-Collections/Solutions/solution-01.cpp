// solution-01.cpp - word frequency counting with std::map, ranked via std::sort.
#include <iostream>
#include <string>
#include <map>
#include <vector>
#include <algorithm>
#include <sstream>
#include <cctype>

std::map<std::string, int> wordFrequency(const std::string& text) {
    std::string cleaned;
    for (char c : text) {
        if (c == '.' || c == ',' || c == '!' || c == '?') continue;
        cleaned += static_cast<char>(std::tolower(static_cast<unsigned char>(c)));
    }

    std::map<std::string, int> freq;
    std::istringstream stream(cleaned);
    std::string word;
    while (stream >> word) {
        freq[word]++;
    }
    return freq;
}

std::vector<std::pair<std::string, int>> topN(const std::map<std::string, int>& freq, int n) {
    std::vector<std::pair<std::string, int>> entries(freq.begin(), freq.end());
    std::sort(entries.begin(), entries.end(), [](const auto& a, const auto& b) {
        if (a.second != b.second) return a.second > b.second;
        return a.first < b.first;
    });
    if (static_cast<int>(entries.size()) > n) entries.resize(n);
    return entries;
}

int main() {
    auto freq = wordFrequency("Cats, cats, and dogs. Dogs love cats!");
    for (const auto& [word, count] : topN(freq, 2)) {
        std::cout << word << ": " << count << std::endl;
    }
    return 0;
}
