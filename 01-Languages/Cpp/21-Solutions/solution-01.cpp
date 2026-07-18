// solution-01.cpp - Exercise 01: raw new/delete vs std::unique_ptr under an exception.
#include <iostream>
#include <memory>
#include <stdexcept>

class Logger {
public:
    Logger() { std::cout << "  Logger opened" << std::endl; }
    ~Logger() { std::cout << "  Logger closed" << std::endl; }
    void write(const std::string& msg) const { std::cout << "  [log] " << msg << std::endl; }
};

// Raw new/delete: the delete at the bottom is only reached on the path where nothing
// throws. An exception between `new` and `delete` skips it entirely -- the Logger
// (and whatever it holds, e.g. an open file handle in a real logger) is leaked.
void writeLogsRaw(bool shouldThrow) {
    Logger* log = new Logger();
    log->write("first entry");
    if (shouldThrow) {
        throw std::runtime_error("writeLogsRaw failed");
        // delete log; is unreachable from here -- this is the leak, not a hypothetical one
    }
    delete log;
}

// std::unique_ptr ties the Logger's lifetime to the *scope*, not to a manually-written
// delete statement -- stack unwinding during the throw still runs `log`'s destructor,
// because unwinding destroys every fully-constructed local object regardless of how
// the scope is exited (normal return or exception).
void writeLogsSafe(bool shouldThrow) {
    auto log = std::make_unique<Logger>();
    log->write("first entry");
    if (shouldThrow) {
        throw std::runtime_error("writeLogsSafe failed");
    }
}

int main() {
    std::cout << "--- raw new/delete, exception thrown before delete ---" << std::endl;
    try {
        writeLogsRaw(true);
    } catch (const std::exception& e) {
        // Notice "Logger closed" never printed above this line: the Logger leaked.
        std::cout << "Caught: " << e.what() << " (no \"Logger closed\" was printed -- LEAKED)" << std::endl;
    }

    std::cout << "\n--- std::unique_ptr, exception thrown, RAII still cleans up ---" << std::endl;
    try {
        writeLogsSafe(true);
    } catch (const std::exception& e) {
        // "Logger closed" DID print above this line, during stack unwinding, before
        // control ever reached this catch block.
        std::cout << "Caught: " << e.what() << " (\"Logger closed\" WAS printed during unwinding)" << std::endl;
    }

    return 0;
}
