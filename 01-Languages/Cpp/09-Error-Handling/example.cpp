// example.cpp - try/catch/throw, custom exceptions, RAII replacing finally.
#include <iostream>
#include <stdexcept>
#include <string>

double divide(double a, double b) {
    if (b == 0) throw std::invalid_argument("Cannot divide by zero");
    return a / b;
}

class ValidationError : public std::exception {
    std::string message;
public:
    ValidationError(const std::string& msg) : message(msg) {}
    const char* what() const noexcept override { return message.c_str(); }
};

int validateAge(int age) {
    if (age < 0) throw ValidationError("Age cannot be negative");
    return age;
}

class ResourceGuard {
public:
    ResourceGuard() { std::cout << "  Resource acquired" << std::endl; }
    ~ResourceGuard() { std::cout << "  Resource released (automatically, via RAII)" << std::endl; }
};

void doWork() {
    ResourceGuard guard;
    throw std::runtime_error("something went wrong");
}

int main() {
    std::cout << "--- standard exception, caught by const& ---" << std::endl;
    try {
        divide(10, 0);
    } catch (const std::invalid_argument& e) {
        std::cout << "Caught: " << e.what() << std::endl;
    }

    std::cout << "\n--- custom exception ---" << std::endl;
    try {
        validateAge(-5);
    } catch (const ValidationError& e) {
        std::cout << "Caught: " << e.what() << std::endl;
    }

    std::cout << "\n--- RAII: resource released even during exception unwinding ---" << std::endl;
    try {
        doWork();
    } catch (const std::runtime_error& e) {
        std::cout << "Caught after unwinding: " << e.what() << std::endl;
    }

    return 0;
}
