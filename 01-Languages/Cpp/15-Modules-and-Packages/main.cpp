// main.cpp - a separate translation unit, only sees mathutils.hpp's DECLARATIONS at compile time;
// the actual implementations are resolved by the LINKER from mathutils.cpp's compiled object file.
#include <iostream>
#include "mathutils.hpp"

int main() {
    std::cout << "mathutils::add(2, 3): " << mathutils::add(2, 3) << std::endl;
    std::cout << "mathutils::multiply(4, 5): " << mathutils::multiply(4, 5) << std::endl;
    return 0;
}
