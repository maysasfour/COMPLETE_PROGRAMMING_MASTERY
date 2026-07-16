// example.cpp - raw new/delete vs smart pointers, and the Rule of Five in action.
#include <iostream>
#include <memory>
#include <string>

class Resource {
    std::string name;
public:
    Resource(const std::string& name) : name(name) {
        std::cout << "  Resource '" << name << "' acquired" << std::endl;
    }
    ~Resource() {
        std::cout << "  Resource '" << name << "' released" << std::endl;
    }
    void use() const {
        std::cout << "  Using resource '" << name << "'" << std::endl;
    }
};

void leaky() {
    Resource* r = new Resource("leaked"); // BAD: never deleted if an exception is thrown before delete
    r->use();
    // throw std::runtime_error("oops"); // if uncommented, `r` is leaked -- delete below never runs
    delete r;
}

void safe() {
    auto r = std::make_unique<Resource>("RAII-managed"); // automatically deleted, even on exception
    r->use();
    // throw std::runtime_error("oops"); // if uncommented, r's destructor STILL runs during unwinding
} // r's destructor runs here automatically

class SharedCounter {
    std::shared_ptr<int> count;
public:
    SharedCounter() : count(std::make_shared<int>(0)) {}
    void increment() { (*count)++; }
    int value() const { return *count; }
    long useCount() const { return count.use_count(); }
};

int main() {
    std::cout << "--- raw new/delete (manual, error-prone) ---" << std::endl;
    leaky();

    std::cout << "\n--- std::unique_ptr (RAII, automatic) ---" << std::endl;
    safe();

    std::cout << "\n--- std::shared_ptr (reference-counted ownership) ---" << std::endl;
    SharedCounter a;
    a.increment();
    SharedCounter b = a; // copies the SharedCounter, but the underlying shared_ptr is SHARED
    b.increment();
    std::cout << "a.value(): " << a.value() << " (both a and b share the same underlying int)" << std::endl;
    std::cout << "a's shared_ptr use_count: " << a.useCount() << std::endl;

    return 0;
}
