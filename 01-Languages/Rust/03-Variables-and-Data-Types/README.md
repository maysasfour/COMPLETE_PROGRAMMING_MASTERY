# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Understand **ownership**: every value has exactly one owner, and the value is dropped when its owner goes out of scope.
- Understand **moves**: assigning/passing a non-`Copy` value transfers ownership, invalidating the original binding.
- Use **borrowing** (`&`/`&mut`) to access a value without taking ownership.
- Understand immutability by default, and `mut` for opting into mutation.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

This is the single most important lesson in this entire course, and the concept that makes Rust genuinely different from every other language covered in this repository. **Ownership**: every value has exactly one owner (a variable binding); when that owner goes out of scope, the value is automatically dropped (freed) — like C++'s RAII, but enforced by the compiler, not just convention. **Moves**: assigning a non-`Copy` value to another variable, or passing it to a function by value, **transfers ownership** — the original binding becomes invalid and using it afterward is a compile error, not a runtime bug. **Borrowing**: `&value` creates a reference that can access the value without taking ownership, subject to strict compile-time rules preventing data races.

## Ownership and Moves

```rust
let s1 = String::from("hello");
let s2 = s1; // MOVE: ownership transfers from s1 to s2

// println!("{}", s1); // COMPILE ERROR: s1's value was moved into s2, s1 is no longer valid
println!("{}", s2); // fine -- s2 owns the value now
```

This is fundamentally different from every other language course in this repository: Python/JavaScript/Java/C#/Go would all let you keep using the original variable (either aliasing the same object, or — for Go/C++ — copying it). Rust's move semantics mean the *compiler* tracks exactly one valid owner at all times, and using a moved-from variable is caught before the program ever runs.

## Borrowing: Using a Value Without Taking Ownership

```rust
let s1 = String::from("hello");
let len = calculate_length(&s1); // BORROW -- s1 is still valid afterward
println!("{} has length {}", s1, len); // s1 is fine to use here

fn calculate_length(s: &String) -> usize {
    s.len()
} // s (the reference) goes out of scope here, but it doesn't own the data, so nothing is dropped
```

## The Borrowing Rules

At any given time, for a particular piece of data, you can have **either**:
- Any number of immutable references (`&T`), **or**
- Exactly one mutable reference (`&mut T`)

...but never both simultaneously. This is checked entirely at compile time by the "borrow checker" and is precisely what makes data races impossible in safe Rust — two simultaneous mutable accesses (or a mutable access alongside a read) to the same data is exactly the pattern that causes races in other languages, and Rust simply refuses to compile it.

```rust
let mut x = 5;
let r1 = &x; // immutable borrow
let r2 = &x; // ANOTHER immutable borrow -- fine, multiple immutable borrows are allowed
println!("{} {}", r1, r2);

let r3 = &mut x; // mutable borrow -- fine NOW that r1/r2 are no longer used (non-lexical lifetimes)
*r3 += 1;
println!("{}", x);
```

## `mut` and Immutability by Default

```rust
let x = 5;
// x = 6; // COMPILE ERROR: x is immutable by default

let mut y = 5;
y = 6; // fine -- explicitly marked mutable
```

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints a demonstration of ownership/moves (with a commented-out line showing what would fail to compile), borrowing without taking ownership, and the borrowing rules in action.

## Common Mistakes

- Trying to use a variable after its value has been moved — a compile error (`E0382: use of moved value`), not a runtime bug; this is the single most common "fighting the borrow checker" experience for Rust beginners.
- Trying to have a mutable and immutable borrow of the same data active at the same time — another compile error, specifically preventing the exact pattern that causes data races in other languages.
- Reaching for `.clone()` reflexively to silence a move/borrow error, when restructuring the code to borrow instead would be more idiomatic and efficient.

## Best Practices

- Prefer borrowing (`&T`/`&mut T`) over moving/cloning wherever a function only needs temporary access to a value.
- Understand a "cannot borrow as mutable" or "use of moved value" error as the compiler correctly preventing a genuine bug, not an obstacle to work around — the fix is almost always restructuring ownership, not finding a trick.
- Use `.clone()` deliberately, when an independent copy is genuinely needed, not as a reflexive fix for compiler errors you don't yet understand.

## Real-World Usage

Ownership and borrowing are why Rust can guarantee memory safety and data-race-freedom with zero runtime overhead — no garbage collector, no runtime bounds/lock checking beyond what's needed — making it competitive with C++ for performance while eliminating an entire category of C++'s most dangerous bugs (use-after-free, double-free, data races) at compile time instead of relying on programmer discipline.

## Summary

- Every value has exactly one owner; the value is dropped automatically when its owner goes out of scope.
- Assigning/passing a non-`Copy` value moves ownership, invalidating the original binding — checked at compile time.
- Borrowing (`&`/`&mut`) accesses a value without taking ownership, under strict rules (any number of immutable borrows, XOR exactly one mutable borrow) that make data races impossible in safe Rust.
- Variables are immutable by default; `mut` opts into mutability explicitly.

## Key Terms

- **Ownership** — the rule that every value has exactly one owner, responsible for its cleanup.
- **Move** — transferring ownership of a value to a new binding, invalidating the original.
- **Borrow** — a reference (`&T`/`&mut T`) granting temporary access to a value without taking ownership.
- **Borrow checker** — the part of the Rust compiler enforcing ownership/borrowing rules at compile time.

## Review Questions

1. Why does using a variable after its value has moved produce a compile error instead of a runtime bug?
2. Why can Rust allow multiple simultaneous immutable borrows but only one mutable borrow?
3. When would restructuring code to borrow be preferable to calling `.clone()`?

## Interview Questions

1. **What happens when you assign a `String` to another variable in Rust, and why?**
   The value is *moved* — ownership transfers to the new variable, and the original variable becomes invalid; using it afterward is a compile error. This happens because `String` owns heap-allocated data and doesn't implement the `Copy` trait — Rust defaults to moving (rather than deep-copying) non-`Copy` types on assignment, specifically to avoid the cost of an implicit, potentially expensive deep copy, and to keep ownership unambiguous (always exactly one owner).

2. **What are the two borrowing rules that make data races impossible in safe Rust?**
   At any given time, a piece of data can have either any number of immutable references (`&T`) or exactly one mutable reference (`&mut T`), but never both kinds simultaneously. Since a data race requires at least one write happening concurrently with another access to the same memory, and the compiler statically forbids a mutable borrow from coexisting with any other borrow, this specific pattern simply cannot compile in safe Rust.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
