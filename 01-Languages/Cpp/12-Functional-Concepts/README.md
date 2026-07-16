# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Write lambda expressions and understand capture modes (`[=]`, `[&]`, specific captures).
- Use `std::function` for a type-erased callable wrapper.
- Use `<algorithm>` functions with lambdas (extending Lesson 07).

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

C++11 lambdas are the language's answer to first-class functions, with one feature no other language course's closures need to think about explicitly: **capture mode** — lambdas must explicitly declare whether they capture surrounding variables **by value** (`[=]`, a copy, consistent with Lesson 03's value semantics) or **by reference** (`[&]`), since C++ has no automatic garbage collection to keep a captured reference's target alive.

## Lambda Capture Modes

```cpp
int multiplier = 3;

auto byValue = [multiplier](int n) { return n * multiplier; };   // captures a COPY of multiplier
auto byRef = [&multiplier](int n) { return n * multiplier; };     // captures a REFERENCE to multiplier

multiplier = 10;
std::cout << byValue(5) << std::endl; // 15 -- still uses the captured copy (3), unaffected by the change
std::cout << byRef(5) << std::endl;    // 50 -- uses the current value via reference (10)
```

Capturing by reference to a variable that goes out of scope before the lambda is called (e.g., a lambda returned from a function, capturing a local by reference) is a dangling-reference bug — a distinctly C++ risk with no equivalent in garbage-collected closures.

## `std::function`

```cpp
#include <functional>

std::function<int(int, int)> add = [](int a, int b) { return a + b; };
std::cout << add(2, 3) << std::endl;
```

`std::function<Signature>` is a type-erased wrapper that can hold any callable (a lambda, a function pointer, a functor) matching a given signature — analogous to `Func<>`/`Action<>` in C# and `Function<>`/`Predicate<>` in Java, at the cost of some runtime overhead (type erasure isn't free in C++, unlike a plain lambda used directly).

## `<algorithm>` with Lambdas

```cpp
#include <algorithm>
#include <vector>

std::vector<int> numbers = {1, 2, 3, 4, 5};
std::vector<int> doubled;
std::transform(numbers.begin(), numbers.end(), std::back_inserter(doubled),
    [](int n) { return n * 2; }); // like .map()
```

## Detailed Example

See [example.cpp](example.cpp).

## Expected Output

Compiling and running `example.cpp` prints the by-value vs. by-reference capture contrast (concretely, after mutating the captured variable), a `std::function`-wrapped lambda, and `std::transform` used with a lambda.

## Common Mistakes

- Capturing by reference (`[&]`) a local variable, then calling the lambda after that variable's scope has ended — a dangling reference, undefined behavior, with no runtime safety net.
- Using `[=]`/`[&]` (capturing *everything* by value/reference) as a default habit instead of naming specific captures — less explicit about what the lambda actually depends on, and riskier for by-reference captures specifically.

## Best Practices

- Prefer naming specific captures (`[multiplier]`, `[&multiplier]`) over blanket `[=]`/`[&]`, making a lambda's dependencies explicit and easier to review for dangling-reference risk.
- Use plain lambdas directly (with `auto`) where possible; reserve `std::function` for cases genuinely needing type erasure (e.g., storing different callable types in the same container, or a class member holding a callback).

## Real-World Usage

Lambdas combined with `<algorithm>` are the modern, idiomatic C++ way to express the same filter/map/reduce-style operations covered in every other language course's collections lesson; `std::function` callback members are common in C++ APIs needing to store a caller-provided callback (e.g., an event handler).

## Summary

- C++ lambdas require explicit capture mode (`[=]`/`[&]`/named captures) — a genuinely C++-specific concern tied to its lack of garbage collection.
- `std::function<Signature>` is a type-erased callable wrapper, analogous to `Func<>`/`Function<>` in the C#/Java courses.
- `<algorithm>` functions combined with lambdas are the idiomatic modern way to transform collections.

## Key Terms

- **Lambda capture** — how a lambda accesses surrounding variables: by value (a copy) or by reference (an alias, risking dangling references if the target's scope ends first).
- **`std::function`** — a type-erased wrapper holding any callable matching a given signature.

## Interview Questions

1. **What's the difference between capturing a variable by value (`[x]`) and by reference (`[&x]`) in a C++ lambda?**
   `[x]` captures a copy of `x` at the moment the lambda is created — later changes to the original `x` don't affect the lambda's captured copy. `[&x]` captures a reference to `x` itself — the lambda always sees `x`'s current value, but this is only safe as long as `x` remains alive; calling the lambda after `x` has gone out of scope is a dangling reference and undefined behavior.

2. **What is `std::function`, and when would you reach for it instead of `auto`?**
   `std::function<Signature>` is a type-erased wrapper that can hold any callable (lambda, function pointer, functor) matching a given call signature, at some runtime overhead compared to a plain lambda. Use it when you need to store callables of different concrete types uniformly (e.g., in a container, or as a class member holding a caller-provided callback) — `auto` alone can't do this, since each lambda has its own unique, unnameable compiler-generated type.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
