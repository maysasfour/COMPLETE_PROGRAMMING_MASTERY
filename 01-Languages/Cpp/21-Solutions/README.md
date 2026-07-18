# 21 — Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

Worked solutions to all seven problems in [20-Exercises](../20-Exercises/README.md). Every file below was actually compiled with MSVC 19.51 (`cl /EHsc /std:c++20 /Zc:__cplusplus`) and run; the output blocks are copy-pasted from the real terminal, not written from imagination.

## How to Build and Run

From this folder, using a Developer Command Prompt (or after running `vcvars64.bat`):

```bash
cl /EHsc /std:c++20 /Zc:__cplusplus solution-01.cpp /Fe:solution-01.exe && solution-01.exe
# ...same pattern for solution-02.cpp through solution-07.cpp
```

or with g++/clang++:

```bash
g++ -std=c++20 solution-01.cpp -o solution-01 && ./solution-01
```

## Solution 01 — Raw `new`/`delete` vs. `std::unique_ptr`

See [solution-01.cpp](solution-01.cpp).

```
--- raw new/delete, exception thrown before delete ---
  Logger opened
  [log] first entry
Caught: writeLogsRaw failed (no "Logger closed" was printed -- LEAKED)

--- std::unique_ptr, exception thrown, RAII still cleans up ---
  Logger opened
  [log] first entry
  Logger closed
Caught: writeLogsSafe failed ("Logger closed" WAS printed during unwinding)
```

The genuinely interesting part isn't the code — it's the output ordering: `"Logger closed"` never appears in the raw-pointer run (a real leak, not a theoretical one), but appears in the `unique_ptr` run **before** the `catch` block even runs, proving cleanup happens during stack unwinding, not afterward.

## Solution 02 — Slicing: Reproduce It, Then Fix It

See [solution-02.cpp](solution-02.cpp).

```
--- pass-by-value: SLICED ---
  printSlicedArea -> describe(): Shape, area(): 0
  (expected "Circle" and area 12.5664 -- got "Shape" and area 0, because the Circle part was sliced off)

--- pass-by-reference: CORRECT ---
  printCorrectArea -> describe(): Circle, area(): 12.5664
  (correctly reports "Circle" and area 12.5664)
```

`Shape s` (by value) copy-constructs a plain `Shape` from the `Circle` argument, discarding the derived-class portion entirely — `describe()`/`area()` resolve against the sliced-down base object, printing `"Shape"` and `0`, not `"Circle"` and `12.5664`. `const Shape&` never copies anything; virtual dispatch reaches the real `Circle`.

## Solution 03 — Word Frequency Counter with STL

See [solution-03.cpp](solution-03.cpp).

```
--- frequency table (sorted alphabetically, courtesy of std::map) ---
  brown: 1
  dog: 1
  fox: 2
  jumps: 1
  lazy: 1
  over: 1
  quick: 1
  runs: 1
  the: 4

Most frequent word: "the" (4 occurrences)
```

`std::map<std::string, int>` iterates in sorted key order automatically (it's a balanced tree internally) — no explicit sort step was needed for the alphabetical table above, unlike `std::unordered_map`, which gives no ordering guarantee at all.

## Solution 04 — A Custom Exception Hierarchy

See [solution-04.cpp](solution-04.cpp).

```
processFile("report.txt"):
  Processed "report.txt" successfully
processFile("data"):
  Caught (via base AppException&): File not found: data
processFile("empty.txt"):
  Caught (via base AppException&): Invalid format in empty.txt: empty file
```

A single `catch (const AppException&)` clause caught both `FileNotFoundError` and `InvalidFormatError` — neither derived type needed its own `catch` clause, exactly like a single `Shape&` parameter dispatches to whichever derived class's override is actually present (Solution 02's fix, applied here to exceptions).

## Solution 05 — Generic `Stack<T>` Constrained with a Concept

See [solution-05.cpp](solution-05.cpp).

```
--- BoundedStack<int>, capacity 3 ---
  size after 3 pushes: 3
  Caught on 4th push: Stack is full (capacity 3)
  popping LIFO: 3 2 1 
  Caught on extra pop: Stack is empty

--- BoundedStack<std::string>, same template, different T ---
  popping LIFO: second first
```

`requires std::copyable<T>` is checked at the point `BoundedStack<int>`/`BoundedStack<std::string>` are actually instantiated — both `int` and `std::string` satisfy it, so both instantiations compile with the exact same template code, no duplication.

## Solution 06 — `shared_ptr` Reference Counting with a `weak_ptr` to Break a Cycle

See [solution-06.cpp](solution-06.cpp).

```
--- cyclic version: Parent and Child both own each other via shared_ptr ---
  parent use_count: 2 (1 local + 1 from child->parent)
  child use_count: 2 (1 local + 1 from parent->children)
  leaving scope now...
  (no destructor messages above this line -- both objects LEAKED, a true reference cycle)

--- fixed version: Child holds weak_ptr<Parent> instead ---
  parent use_count: 1 (only 1 -- child's weak_ptr doesn't count)
  leaf's parent is still alive: root
  leaving scope now...
  Parent 'root' destroyed
  (Parent destructor message above -- cycle broken)
  leaf's parent is already gone
  Child 'leaf' destroyed
```

This is the one result in this file that genuinely surprises people who assume `shared_ptr` "can't leak": in the cyclic version, neither `Parent` nor `Child` is ever destroyed, even though nothing outside the scope references either of them by the time it exits — each is kept at `use_count() == 1` forever by the other's `shared_ptr` back-reference. Swapping `Child::parent` to a `std::weak_ptr<Parent>` (which never increments the count) fixes it: the fixed run's `Parent` destructor genuinely fires the moment the local `shared_ptr<Parent>` goes out of scope.

## Solution 07 — Rule of Five (by Hand) vs. Rule of Zero

See [solution-07.cpp](solution-07.cpp).

```
--- Buffer: Rule of Five, hand-written ---
  Buffer(size_t) constructed, length=3

  -- copy --
  Buffer(const Buffer&) copy-constructed (deep copy)
  original[0]=10 (unaffected), copy[0]=999 (mutated independently -- proves the copy was deep)

  -- move --
  Buffer(Buffer&&) move-constructed (pointer stolen)
  moved[0]=10, original.isMovedFrom()=true (source's pointer was nulled out -- safe to destroy)

--- BufferZero: Rule of Zero, composed from std::vector ---
  zOriginal[0]=10 (unaffected), zCopy[0]=999 (also a genuine deep copy, with zero hand-written special members)
  ~Buffer() destructed
  ~Buffer() destructed
  ~Buffer() destructed
```

Note the three `~Buffer() destructed` lines all print together at the very end — that's `original`, `copy`, and `moved` all being destroyed in reverse-declaration order as `main` returns (`BufferZero` prints nothing on destruction since it never defined one; `std::vector`'s own destructor runs silently). `BufferZero` achieves identical deep-copy/move-steal behavior with zero hand-written special members, because every one of the five the compiler generates for it just forwards to `std::vector<int>`'s own already-correct version — this is the Rule of Zero made concrete, not just asserted in prose.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
