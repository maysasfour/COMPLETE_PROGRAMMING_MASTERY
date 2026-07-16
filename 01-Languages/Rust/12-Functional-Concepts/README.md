# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Write closures and understand Rust's three closure traits (`Fn`, `FnMut`, `FnOnce`) reflect ownership/borrowing.
- Use iterator adapters in depth (extending Lesson 07).
- Pass closures and functions as parameters.

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Rust closures capture their environment, but — consistent with Lesson 03's ownership model — **how** they capture (by reference, by mutable reference, or by value/move) determines which of three closure traits they implement: `Fn` (can be called multiple times, borrows immutably), `FnMut` (can be called multiple times, borrows mutably), `FnOnce` (can only be called once, takes ownership). This is a much more precise, compiler-enforced version of the capture-mode distinction the C++ course covers informally (`[=]` vs. `[&]`).

## Closures and Capture Modes

```rust
let multiplier = 3;
let by_reference = |n: i32| n * multiplier; // borrows multiplier immutably -- implements Fn

let mut count = 0;
let mut by_mut_reference = || { count += 1; count }; // borrows count mutably -- implements FnMut

let s = String::from("hello");
let by_move = move || println!("{}", s); // MOVES s into the closure -- implements FnOnce (or Fn, if not consumed)
```

The `move` keyword forces a closure to take ownership of everything it captures, rather than borrowing — necessary, for example, when a closure needs to outlive the scope it was created in (a common requirement for closures passed to a new thread, Lesson 14).

## Iterator Adapters in Depth

```rust
let numbers = vec![1, 2, 3, 4, 5];

let result: i32 = numbers
    .iter()
    .filter(|&&n| n % 2 == 0)
    .map(|n| n * n)
    .sum();
println!("{}", result); // sum of squares of evens
```

## Passing Functions and Closures as Parameters

```rust
fn apply<F: Fn(i32) -> i32>(f: F, x: i32) -> i32 { // generic over any Fn(i32) -> i32
    f(x)
}

let double = |n| n * 2;
println!("{}", apply(double, 5)); // 10
```

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints closures capturing by reference and by mutable reference, a `move` closure taking ownership, an iterator adapter chain (`filter`/`map`/`sum`), and a generic function accepting any `Fn(i32) -> i32`.

## Common Mistakes

- Forgetting `move` when a closure needs to outlive its creating scope (e.g., passed to `std::thread::spawn`, Lesson 14) — without it, the closure borrows, and the borrow checker will reject code where the borrowed data doesn't live long enough.
- Confusing `Fn`/`FnMut`/`FnOnce` — a function generic over `Fn` cannot accept a closure that only implements `FnMut`/`FnOnce` (since `Fn` requires being callable multiple times without mutation), a compile-time-enforced distinction with no equivalent in the JavaScript/Python/Java/C# courses' closures.

## Best Practices

- Let type inference determine the appropriate closure trait bound where possible; use `move` explicitly whenever a closure needs to own its captured data (especially before passing it across a thread boundary).
- Prefer iterator adapter chains over manual loops for collection transformations, mirroring the idiom from every other language course.

## Real-World Usage

The `Fn`/`FnMut`/`FnOnce` distinction is central to Rust's standard library APIs that accept callbacks (like `Iterator::for_each`, `Option::map`, or a thread's spawned closure) — understanding which trait a given API requires (and why) is part of fluently reading Rust function signatures.

## Summary

- Rust closures capture by reference, mutable reference, or by move (with the `move` keyword), determining whether they implement `Fn`, `FnMut`, or `FnOnce`.
- Iterator adapters (`.filter`, `.map`, `.sum`, etc.) chain lazily, mirroring the idiom from every other language course's collections lesson.
- Generic functions can accept any closure/function matching a trait bound like `Fn(i32) -> i32`.

## Key Terms

- **`Fn`/`FnMut`/`FnOnce`** — the three closure traits, reflecting whether a closure borrows immutably, borrows mutably, or takes ownership of its captured environment.
- **`move` closure** — a closure that takes ownership of everything it captures, rather than borrowing.

## Interview Questions

1. **What's the difference between `Fn`, `FnMut`, and `FnOnce` in Rust?**
   They describe how a closure interacts with its captured environment, and correspondingly how many times/how it can be called. `Fn` closures borrow captured variables immutably and can be called any number of times. `FnMut` closures borrow mutably (can modify captured state) and can also be called multiple times. `FnOnce` closures take ownership of (move) captured variables and can only be called once, since calling them consumes the captured data. Every closure implements at least `FnOnce`; whether it also implements `FnMut`/`Fn` depends on how it actually uses its captures.

2. **When would you use the `move` keyword on a closure?**
   When the closure needs to take ownership of its captured variables rather than borrowing them — most commonly when the closure must outlive the scope it was created in (e.g., passed to a new thread via `std::thread::spawn`, Lesson 14), where borrowing would risk the referenced data going out of scope while the closure (running on another thread) might still need it — a scenario the borrow checker would otherwise reject.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
