// solution-04.cpp - Exercise 04: a custom exception hierarchy, caught polymorphically.
#include <iostream>
#include <string>
#include <exception>

class AppException : public std::exception {
protected:
    std::string message;
public:
    explicit AppException(std::string msg) : message(std::move(msg)) {}
    const char* what() const noexcept override { return message.c_str(); }
};

class FileNotFoundError : public AppException {
public:
    explicit FileNotFoundError(const std::string& name)
        : AppException("File not found: " + name) {}
};

class InvalidFormatError : public AppException {
public:
    InvalidFormatError(const std::string& name, const std::string& reason)
        : AppException("Invalid format in " + name + ": " + reason) {}
};

void processFile(const std::string& name) {
    if (name.size() < 4 || name.substr(name.size() - 4) != ".txt") {
        throw FileNotFoundError(name);
    }
    if (name == "empty.txt") {
        throw InvalidFormatError(name, "empty file");
    }
    std::cout << "  Processed \"" << name << "\" successfully" << std::endl;
}

int main() {
    // Deliberately hitting all three outcomes with ONE catch clause on the BASE type --
    // this is the point of the exercise: AppException& binds to any derived exception
    // object polymorphically, exactly like catching a base-class reference/pointer
    // dispatches virtual calls to the derived override (Lesson 11's slicing lesson,
    // applied here to exceptions instead of shapes).
    for (const std::string& name : {"report.txt", "data", "empty.txt"}) {
        try {
            std::cout << "processFile(\"" << name << "\"):" << std::endl;
            processFile(name);
        } catch (const AppException& e) {
            std::cout << "  Caught (via base AppException&): " << e.what() << std::endl;
        }
    }

    return 0;
}
