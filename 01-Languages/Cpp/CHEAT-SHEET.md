# C++ Cheat Sheet

[Back to course overview](README.md)

## Variables and Types (Value Semantics by Default!)

```cpp
int age = 30;
auto name = std::string("Ada"); // inferred, still static
const int maxRetries = 3;

std::vector<int> a = {1,2,3};
std::vector<int> b = a; // COPIES -- unlike every managed language

int& ref = x;     // reference: non-null, non-reseatable alias
int* ptr = &x;    // pointer: nullable, reassignable, needs * to dereference
```

## Operators

```cpp
int* p = nullptr;       // always use nullptr, never NULL/0
a == b; a < b ? x : y;
*(p + 1);                 // pointer arithmetic -- NO bounds checking
```

## Control Flow

```cpp
if (x > 0) { } else { }
switch (x) { case 1: /*...*/ break; default: break; } // fall-through by default

for (const auto& item : container) { } // avoids copying
auto [a, b] = somePair;                  // structured binding
```

## Functions

```cpp
std::string greet(std::string name = "World") { return "Hello, " + name; }
void byValue(int x);              // copies
void byRef(int& x);                 // modifies caller's variable
void byConstRef(const std::string& s); // efficient, read-only
```

## Collections and Algorithms

```cpp
std::vector<int> v = {1,2,3};
v.at(0);           // bounds-checked, throws
v[0];               // NOT bounds-checked, UB if out of range

std::map<std::string,int> m;
m.count("key");     // safe existence check

std::sort(v.begin(), v.end());
std::accumulate(v.begin(), v.end(), 0);
std::count_if(v.begin(), v.end(), [](int n){ return n%2==0; });
```

## Strings (MUTABLE, unlike other languages!)

```cpp
std::string s = "hello";
s += " world";   // genuinely mutates in place
s[0] = 'H';

std::string_view sv = "no copy, read-only view";
```

## Error Handling (No `finally` — Use RAII)

```cpp
try {
    throw std::runtime_error("oops");
} catch (const std::exception& e) { // ALWAYS catch by const&
    std::cout << e.what();
}

class Guard {
public:
    ~Guard() { /* cleanup runs automatically on scope exit */ }
};
```

## OOP (Explicit `virtual`, Watch for Slicing!)

```cpp
class Animal {
public:
    virtual std::string speak() const { return "..."; }
    virtual ~Animal() = default; // REQUIRED for polymorphic base classes
};
class Dog : public Animal {
public:
    std::string speak() const override { return "Woof"; }
};

Animal& a = dog;   // correct polymorphism
Animal a2 = dog;    // SLICED -- lost Dog behavior
```

## Generics (Templates — Compile-Time, Not Erased)

```cpp
template <typename T>
T first(const std::vector<T>& v) { return v[0]; }

template <typename T>
class Stack { /* ... */ };
```

## Concurrency

```cpp
std::thread t(fn); t.join(); // must join() or detach(), or std::terminate()!
auto f = std::async(std::launch::async, fn);
f.get();
std::lock_guard<std::mutex> lock(mtx); // RAII locking
```

## Best Practices

```cpp
auto r = std::make_unique<Resource>(); // prefer over raw new/delete
// Rule of Zero: compose from RAII members, don't manage raw resources yourself
```

## Compiling

```bash
g++ -std=c++20 -Wall file.cpp -o app && ./app
cl /EHsc /std:c++20 /Zc:__cplusplus file.cpp && file.exe   # MSVC -- note /Zc:__cplusplus!
```
