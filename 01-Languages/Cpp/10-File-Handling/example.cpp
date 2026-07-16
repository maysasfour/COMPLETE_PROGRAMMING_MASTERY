// example.cpp - <fstream> text I/O with RAII, and the stream-state (not exception) missing-file pattern.
#include <iostream>
#include <fstream>
#include <string>
#include <cstdio>

int main() {
    const std::string path = "example-notes.txt";

    std::cout << "--- text file round-trip ---" << std::endl;
    {
        std::ofstream outFile(path);
        outFile << "Hello, file system!" << std::endl;
    } // outFile's destructor closes the file here (RAII), before we try to read it back

    {
        std::ifstream inFile(path);
        std::string line;
        std::getline(inFile, line);
        std::cout << "Read back: " << line << std::endl;
    }

    std::cout << "\n--- missing file: checked via stream state, NOT an exception ---" << std::endl;
    std::ifstream missing("does-not-exist-example.txt");
    if (!missing.is_open()) {
        std::cout << "File doesn't exist -- using defaults, handled gracefully" << std::endl;
    }

    std::remove(path.c_str());
    std::cout << "\nCleaned up temporary file." << std::endl;

    return 0;
}
