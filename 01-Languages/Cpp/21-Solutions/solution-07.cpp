// solution-07.cpp - Exercise 07: the Rule of Five written out by hand, contrasted with
// the Rule of Zero achieved by composing from std::vector instead.
#include <iostream>
#include <vector>
#include <utility>

class Buffer {
    int* data;
    size_t length;
public:
    explicit Buffer(size_t len) : data(new int[len]{}), length(len) {
        std::cout << "  Buffer(size_t) constructed, length=" << length << std::endl;
    }

    // 1) Destructor
    ~Buffer() {
        delete[] data; // safe even if data is nullptr (a moved-from Buffer) -- delete[] on nullptr is a no-op
        std::cout << "  ~Buffer() destructed" << std::endl;
    }

    // 2) Copy constructor -- must deep-copy the array, or two Buffers would both
    // delete[] the SAME pointer when destroyed (a double-free).
    Buffer(const Buffer& other) : data(new int[other.length]), length(other.length) {
        std::copy(other.data, other.data + other.length, data);
        std::cout << "  Buffer(const Buffer&) copy-constructed (deep copy)" << std::endl;
    }

    // 3) Copy assignment -- same deep-copy requirement, plus must free the LHS's
    // existing array first (or leak it) and guard against self-assignment.
    Buffer& operator=(const Buffer& other) {
        if (this == &other) return *this;
        int* newData = new int[other.length];
        std::copy(other.data, other.data + other.length, newData);
        delete[] data;
        data = newData;
        length = other.length;
        std::cout << "  operator=(const Buffer&) copy-assigned (deep copy)" << std::endl;
        return *this;
    }

    // 4) Move constructor -- STEALS the source's pointer instead of copying, and nulls
    // the source out so its destructor's delete[] is a safe no-op.
    Buffer(Buffer&& other) noexcept : data(other.data), length(other.length) {
        other.data = nullptr;
        other.length = 0;
        std::cout << "  Buffer(Buffer&&) move-constructed (pointer stolen)" << std::endl;
    }

    // 5) Move assignment -- same steal, plus free the LHS's own existing array first.
    Buffer& operator=(Buffer&& other) noexcept {
        if (this == &other) return *this;
        delete[] data;
        data = other.data;
        length = other.length;
        other.data = nullptr;
        other.length = 0;
        std::cout << "  operator=(Buffer&&) move-assigned (pointer stolen)" << std::endl;
        return *this;
    }

    void set(size_t index, int value) { data[index] = value; }
    int get(size_t index) const { return data[index]; }
    bool isMovedFrom() const { return data == nullptr; }
};

// Rule of Zero: BufferZero defines NONE of the five special members. The compiler
// generates all five, and each one just calls std::vector<int>'s own (already-correct)
// version -- copy deep-copies the vector, move steals the vector's internal buffer,
// the destructor frees it. There is nothing left for a human to get wrong here.
class BufferZero {
    std::vector<int> data;
public:
    explicit BufferZero(size_t len) : data(len, 0) {}
    void set(size_t index, int value) { data[index] = value; }
    int get(size_t index) const { return data[index]; }
};

int main() {
    std::cout << "--- Buffer: Rule of Five, hand-written ---" << std::endl;
    Buffer original(3);
    original.set(0, 10);
    original.set(1, 20);
    original.set(2, 30);

    std::cout << "\n  -- copy --" << std::endl;
    Buffer copy = original;
    copy.set(0, 999);
    std::cout << "  original[0]=" << original.get(0) << " (unaffected), copy[0]=" << copy.get(0)
              << " (mutated independently -- proves the copy was deep)" << std::endl;

    std::cout << "\n  -- move --" << std::endl;
    Buffer moved = std::move(original);
    std::cout << "  moved[0]=" << moved.get(0)
              << ", original.isMovedFrom()=" << std::boolalpha << original.isMovedFrom()
              << " (source's pointer was nulled out -- safe to destroy)" << std::endl;

    std::cout << "\n--- BufferZero: Rule of Zero, composed from std::vector ---" << std::endl;
    BufferZero zOriginal(3);
    zOriginal.set(0, 10);
    BufferZero zCopy = zOriginal; // compiler-generated copy ctor, correct because vector's is correct
    zCopy.set(0, 999);
    std::cout << "  zOriginal[0]=" << zOriginal.get(0) << " (unaffected), zCopy[0]=" << zCopy.get(0)
              << " (also a genuine deep copy, with zero hand-written special members)" << std::endl;

    return 0;
}
