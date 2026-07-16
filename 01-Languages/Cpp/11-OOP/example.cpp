// example.cpp - virtual polymorphism, virtual destructors, and the slicing problem.
#include <iostream>
#include <string>

class Animal {
    std::string name;
public:
    Animal(const std::string& name) : name(name) {}
    virtual std::string speak() const { return name + " makes a sound"; }
    virtual ~Animal() = default;
};

class Dog : public Animal {
public:
    Dog(const std::string& name) : Animal(name) {}
    std::string speak() const override { return "Woof"; }
};

int main() {
    std::cout << "--- correct polymorphism through a reference ---" << std::endl;
    Dog dog("Rex");
    Animal& animalByRef = dog;
    std::cout << animalByRef.speak() << std::endl;

    std::cout << "\n--- slicing: polymorphism lost through a by-value copy ---" << std::endl;
    Animal animalByValue = dog; // SLICED here
    std::cout << animalByValue.speak() << " <- lost Dog-specific behavior, this is the slicing bug" << std::endl;

    std::cout << "\n--- pointer-based polymorphism (also correct, unlike by-value) ---" << std::endl;
    Animal* animalPtr = &dog;
    std::cout << animalPtr->speak() << std::endl;

    return 0;
}
