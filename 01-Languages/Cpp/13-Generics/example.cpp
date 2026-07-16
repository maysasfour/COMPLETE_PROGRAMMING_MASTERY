// example.cpp - function templates, class templates, C++20 concepts.
#include <iostream>
#include <vector>
#include <string>
#include <concepts>

template <typename T>
T first(const std::vector<T>& items) {
    return items[0];
}

template <typename T>
class Stack {
    std::vector<T> items;
public:
    void push(const T& item) { items.push_back(item); }
    T pop() {
        T item = items.back();
        items.pop_back();
        return item;
    }
    size_t size() const { return items.size(); }
};

template <typename T>
requires std::totally_ordered<T>
T maxOf(const T& a, const T& b) {
    return (a > b) ? a : b;
}

int main() {
    std::cout << "--- function template with deduction ---" << std::endl;
    std::cout << first(std::vector<int>{1, 2, 3}) << std::endl;
    std::cout << first(std::vector<std::string>{"a", "b"}) << std::endl;

    std::cout << "\n--- class template Stack<T> ---" << std::endl;
    Stack<int> numberStack;
    numberStack.push(1);
    numberStack.push(2);
    numberStack.push(3);
    std::cout << "numberStack.size(): " << numberStack.size() << std::endl;
    std::cout << "numberStack.pop(): " << numberStack.pop() << std::endl;

    Stack<std::string> stringStack;
    stringStack.push("a");
    stringStack.push("b");
    std::cout << "stringStack.pop(): " << stringStack.pop() << std::endl;

    std::cout << "\n--- concept-constrained template ---" << std::endl;
    std::cout << "maxOf(3, 7): " << maxOf(3, 7) << std::endl;
    std::cout << "maxOf(std::string): " << maxOf(std::string("apple"), std::string("banana")) << std::endl;

    return 0;
}
