// solution-03.cpp - Exercise 03: word frequency counter with std::map + <algorithm>.
#include <iostream>
#include <vector>
#include <map>
#include <string>
#include <algorithm>
#include <cctype>

std::string toLower(const std::string& word) {
    std::string result = word;
    // std::transform + a lambda, not a hand-rolled index loop -- the <algorithm>-idiom
    // this course keeps steering toward instead of manual for(i=0;...) loops.
    std::transform(result.begin(), result.end(), result.begin(),
                    [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
    return result;
}

// std::map (a red-black tree) keeps keys in sorted order automatically -- iterating it
// yields words alphabetically for free. std::unordered_map (a hash table) would be
// faster for pure lookups but gives NO ordering guarantee at all; here, sorted output
// is exactly what we want, so std::map is the right STL container, not just "a" container.
std::map<std::string, int> countFrequencies(const std::vector<std::string>& words) {
    std::map<std::string, int> freq;
    for (const auto& word : words) {
        freq[toLower(word)]++;
    }
    return freq;
}

int main() {
    std::vector<std::string> words = {
        "The", "quick", "brown", "fox", "jumps", "over",
        "the", "lazy", "dog", "The", "fox", "runs", "the"
    };

    auto freq = countFrequencies(words);

    std::cout << "--- frequency table (sorted alphabetically, courtesy of std::map) ---" << std::endl;
    for (const auto& [word, count] : freq) {
        std::cout << "  " << word << ": " << count << std::endl;
    }

    // max_element over the map's iterators, comparing by ->second (the count) --
    // an <algorithm> call, not a hand-rolled "best so far" loop.
    auto mostFrequent = std::max_element(
        freq.begin(), freq.end(),
        [](const auto& a, const auto& b) { return a.second < b.second; });

    std::cout << "\nMost frequent word: \"" << mostFrequent->first
              << "\" (" << mostFrequent->second << " occurrences)" << std::endl;

    return 0;
}
