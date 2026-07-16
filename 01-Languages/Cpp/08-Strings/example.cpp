// example.cpp - mutable std::string, common methods, string_view.
#include <iostream>
#include <string>
#include <string_view>
#include <algorithm>
#include <cctype>

void printFirstWord(std::string_view text) {
    auto spacePos = text.find(' ');
    std::cout << "  first word: " << text.substr(0, spacePos) << std::endl;
}

int main() {
    std::cout << "--- std::string is mutable ---" << std::endl;
    std::string s = "hello";
    s += " world";
    s[0] = 'H';
    std::cout << s << std::endl;

    std::cout << "\n--- common methods ---" << std::endl;
    std::string text = "  hello  ";
    std::cout << "size(): " << text.size() << std::endl;
    std::cout << "substr(2, 5): [" << text.substr(2, 5) << "]" << std::endl;

    std::string upper = text;
    std::transform(upper.begin(), upper.end(), upper.begin(),
        [](unsigned char c) { return std::toupper(c); });
    std::cout << "uppercased via <algorithm>: [" << upper << "]" << std::endl;

    std::cout << "\n--- string_view: works with a literal and a std::string, no copy ---" << std::endl;
    printFirstWord("hello world");
    printFirstWord(std::string("hi there"));

    return 0;
}
