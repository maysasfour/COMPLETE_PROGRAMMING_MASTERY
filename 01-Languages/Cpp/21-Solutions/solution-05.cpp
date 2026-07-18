// solution-05.cpp - Exercise 05: a concept-constrained generic BoundedStack<T> with
// custom exceptions for the two failure modes a fixed-capacity stack actually has.
#include <iostream>
#include <vector>
#include <string>
#include <concepts>
#include <exception>

class StackFullException : public std::exception {
    std::string message;
public:
    explicit StackFullException(size_t capacity)
        : message("Stack is full (capacity " + std::to_string(capacity) + ")") {}
    const char* what() const noexcept override { return message.c_str(); }
};

class StackEmptyException : public std::exception {
public:
    const char* what() const noexcept override { return "Stack is empty"; }
};

// std::copyable is the constraint: a bounded stack copies elements in on push() and
// out on pop() by value, so T must genuinely support that -- the constraint documents
// the requirement AT THE TEMPLATE DECLARATION, producing a readable compile error at
// the instantiation site instead of a wall of template-internals errors deep inside
// push()'s body if someone tries BoundedStack<SomeNonCopyableType>.
template <typename T>
requires std::copyable<T>
class BoundedStack {
    std::vector<T> items;
    size_t capacity;
public:
    explicit BoundedStack(size_t cap) : capacity(cap) { items.reserve(cap); }

    void push(const T& item) {
        if (items.size() >= capacity) {
            throw StackFullException(capacity);
        }
        items.push_back(item);
    }

    T pop() {
        if (items.empty()) {
            throw StackEmptyException();
        }
        T item = items.back();
        items.pop_back();
        return item;
    }

    size_t size() const { return items.size(); }
};

int main() {
    std::cout << "--- BoundedStack<int>, capacity 3 ---" << std::endl;
    BoundedStack<int> intStack(3);
    intStack.push(1);
    intStack.push(2);
    intStack.push(3);
    std::cout << "  size after 3 pushes: " << intStack.size() << std::endl;

    try {
        intStack.push(4);
    } catch (const StackFullException& e) {
        std::cout << "  Caught on 4th push: " << e.what() << std::endl;
    }

    std::cout << "  popping LIFO: ";
    while (intStack.size() > 0) {
        std::cout << intStack.pop() << " ";
    }
    std::cout << std::endl;

    try {
        intStack.pop();
    } catch (const StackEmptyException& e) {
        std::cout << "  Caught on extra pop: " << e.what() << std::endl;
    }

    std::cout << "\n--- BoundedStack<std::string>, same template, different T ---" << std::endl;
    BoundedStack<std::string> stringStack(2);
    stringStack.push("first");
    stringStack.push("second");
    std::cout << "  popping LIFO: " << stringStack.pop() << " " << stringStack.pop() << std::endl;

    return 0;
}
