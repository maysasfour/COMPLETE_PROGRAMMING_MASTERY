# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 — solve those first if you haven't, then come back here for problems that pull in RAII/smart pointers, templates with concepts, value-semantics/slicing awareness, STL containers, and custom exception hierarchies — the themes this course leans on hardest and that no other language course in this repository has to think about the same way.

Attempt each problem yourself in a scratch `.cpp` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`exercise-01` &harr; `solution-01.cpp`).

## Exercise 01 — Raw `new`/`delete` vs. `std::unique_ptr` (Beginner)

**Lessons used:** Error Handling / RAII (09), Best Practices (19)

Write a small `Logger` class whose constructor prints `"Logger opened"` and whose destructor prints `"Logger closed"`. Write two functions:

- `void writeLogsRaw(bool shouldThrow)` — allocates a `Logger*` with raw `new`, calls a method on it, and `delete`s it manually at the end. If `shouldThrow` is `true`, throw a `std::runtime_error` *after* the `new` but *before* the `delete`.
- `void writeLogsSafe(bool shouldThrow)` — does the same thing but owns the `Logger` via `std::make_unique`, with no manual `delete` anywhere.

In `main`, call both functions with `shouldThrow = true` inside a `try`/`catch`, and print whether `"Logger closed"` was seen before the `catch` block runs in each case. Explain in a comment (not just code) why one leaks and the other doesn't.

## Exercise 02 — Slicing: Reproduce It, Then Fix It (Beginner/Intermediate)

**Lessons used:** Variables and Data Types (03), OOP (11)

Define an abstract base class `Shape` with a pure virtual `double area() const` and a virtual `std::string describe() const` returning `"Shape"`. Derive `Circle` (stores a radius) and `Square` (stores a side length), each overriding both methods with their own `describe()` string and correct area formula.

- Write a function `void printSlicedArea(Shape s)` that takes a `Shape` **by value** and calls `describe()`/`area()` on it. Call it with a `Circle` argument and observe (print, don't just assert) that it prints `"Shape"` and the wrong area — this is slicing, reproduced live.
- Write a second function `void printCorrectArea(const Shape& s)` taking a `Shape` **by reference**, call it with the same `Circle`, and show it correctly prints `"Circle"` and the right area.

## Exercise 03 — Word Frequency Counter with STL (Intermediate)

**Lessons used:** Collections (07), Strings (08), Functional Concepts (12)

Given a hardcoded `std::vector<std::string> words` (at least 12 words, with several repeats and mixed case), write a function `std::map<std::string, int> countFrequencies(const std::vector<std::string>& words)` that:

- lowercases each word before counting (so `"The"` and `"the"` count together)
- returns a `std::map<std::string, int>` (naturally sorted by key — call out in a comment why `std::map` gives you this for free, unlike `std::unordered_map`)

Then, using `<algorithm>` (not a hand-rolled loop over the whole thing), find and print the single most frequent word and its count. Also print the full frequency table using a range-based `for` with structured bindings (`for (const auto& [word, count] : freq)`).

## Exercise 04 — A Custom Exception Hierarchy (Intermediate)

**Lessons used:** Error Handling (09), OOP (11)

Model a small set of "application errors" for a hypothetical file-processing tool:

- `class AppException : public std::exception` — a base with a stored `std::string message`, overriding `what() const noexcept`.
- `class FileNotFoundError : public AppException` — takes a filename in its constructor and builds a message like `"File not found: <name>"`.
- `class InvalidFormatError : public AppException` — takes a filename and a reason, builds a message like `"Invalid format in <name>: <reason>"`.

Write a function `void processFile(const std::string& name)` that throws `FileNotFoundError` if `name` doesn't end in `.txt`, otherwise throws `InvalidFormatError` with reason `"empty file"` if `name == "empty.txt"`, otherwise "succeeds" (just prints a success message). Call it three times (one of each outcome) inside a single `try`/`catch` that catches `const AppException&` (**not** the two derived types individually) and prints `e.what()` — demonstrating that catching the *base* type is enough to handle every derived exception polymorphically.

## Exercise 05 — Generic `Stack<T>` Constrained with a Concept, Plus a Custom Exception (Advanced)

**Lessons used:** Generics (13), Error Handling (09)

Write a class template `template <typename T> requires std::copyable<T> class BoundedStack` with a fixed maximum capacity (passed to the constructor):

- `void push(const T& item)` — throws a custom `StackFullException` (your own type, derived from `std::exception`) if the stack is already at capacity.
- `T pop()` — throws a custom `StackEmptyException` if the stack is empty.
- `size_t size() const`.

Instantiate it with `BoundedStack<int>` (capacity 3) and demonstrate: filling it to capacity, catching `StackFullException` on a 4th push, popping all 3 items back out in LIFO order, then catching `StackEmptyException` on an extra pop. Also instantiate `BoundedStack<std::string>` to show the same template works unmodified for a different type.

## Exercise 06 — `shared_ptr` Reference Counting with a `weak_ptr` to Break a Cycle (Advanced)

**Lessons used:** Best Practices (19)

Model a minimal `Parent`/`Child` relationship where a `Parent` owns its `Child`ren via `std::shared_ptr<Child>`, and each `Child` needs a back-reference to its `Parent`.

- First, write it with `Child` holding a `std::shared_ptr<Parent> parent` back-reference, and show (by printing `.use_count()` before and after a scope ends) that the `Parent` object's destructor **never runs** — a genuine reference-cycle leak, reproduced live, not just described.
- Then fix it by changing `Child`'s back-reference to `std::weak_ptr<Parent>`, re-run the same scope-exit test, and show the `Parent`'s destructor **does** now run. Use `.lock()` on the `weak_ptr` to safely access the parent when needed, checking the returned `shared_ptr` for null in case the parent is already gone.

## Exercise 07 — Rule of Five (by Hand) vs. Rule of Zero (Advanced)

**Lessons used:** Best Practices (19), Modules and Packages (15's header/source split, optional)

Write a class `Buffer` that manages a raw `int*` array allocated with `new int[]` in its constructor and freed with `delete[]` in its destructor, implementing **all five** special member functions by hand (destructor, copy constructor, copy assignment, move constructor, move assignment) so that copying a `Buffer` deep-copies the array and moving one steals the pointer and nulls out the source. Prove it works: copy a `Buffer`, mutate the copy, and show the original is unaffected; move a `Buffer` and show the moved-from object's internal pointer is now `nullptr` (safe to destroy).

Then write a second class, `BufferZero`, that stores its data in a `std::vector<int>` member instead of a raw pointer, and defines **none** of the five special members — let the compiler generate all of them. Show it behaves identically (deep copy on copy, correct move) with a fraction of the code, and explain in a comment why this is possible (the Rule of Zero: `std::vector` already correctly implements all five itself, so composing from it makes `BufferZero`'s own five come along for free).

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
