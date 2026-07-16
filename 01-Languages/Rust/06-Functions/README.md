# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Write functions with typed parameters and return types.
- Choose correctly between taking ownership, borrowing (`&T`), and mutably borrowing (`&mut T`) as a parameter.
- Use expression-based (no `return`) function bodies, recapping Lesson 02.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Every Rust function parameter's type must specify not just *what* type, but *how* it relates to ownership — a plain `String` parameter takes ownership (the caller can't use their variable afterward), `&String`/`&str` borrows immutably (the caller keeps their variable, read-only access), and `&mut String` borrows mutably (the caller keeps their variable, but the function can modify it). This is Lesson 03's ownership model applied directly to function signatures — no other language course in this repository has this three-way distinction built into every function's type signature.

## Ownership-Aware Parameters

```rust
fn takes_ownership(s: String) -> usize { // caller's variable is MOVED in, unusable afterward
    s.len()
}

fn borrows(s: &String) -> usize { // caller's variable is still valid afterward
    s.len()
}

fn mutably_borrows(s: &mut String) { // caller's variable is still valid, AND can be modified
    s.push_str(" (modified)");
}

let owned = String::from("hello");
let len = takes_ownership(owned);
// println!("{}", owned); // would fail to COMPILE -- owned was moved into the function

let mut s = String::from("world");
let len2 = borrows(&s);
println!("{} still valid, length {}", s, len2); // s is fine -- only borrowed

mutably_borrows(&mut s);
println!("{}", s); // "world (modified)"
```

## Expression-Based Return (Recap)

```rust
fn add(a: i32, b: i32) -> i32 {
    a + b // no semicolon, no `return` -- idiomatic
}
```

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints results from a function taking ownership (with a comment showing what would fail to compile afterward), a borrowing function leaving the caller's variable valid, and a mutably-borrowing function that actually modifies the caller's value.

## Common Mistakes

- Taking a parameter by value (`s: String`) when the function only needs to read it, forcing every caller to give up ownership (or clone) unnecessarily — prefer `&str`/`&T` unless ownership genuinely needs to transfer.
- Forgetting `&mut` (both in the function signature and at the call site, `&mut variable`) when a function needs to modify the caller's value — both sides must agree it's a mutable borrow.

## Best Practices

- Default to borrowing (`&T`, or `&str` specifically for string parameters) unless a function genuinely needs to take ownership (e.g., storing the value somewhere, or transforming and returning a new owned value).
- Use `&mut T` only when the function truly needs to mutate the caller's data in place.

## Real-World Usage

The ownership-aware parameter choice (`T` vs. `&T` vs. `&mut T`) is one of the first real design decisions every Rust function signature requires, and getting it right (borrowing wherever possible) is central to writing idiomatic, efficient Rust that doesn't force unnecessary clones or ownership transfers onto callers.

## Summary

- A Rust function parameter's type specifies its ownership relationship: `T` (takes ownership), `&T` (borrows immutably), `&mut T` (borrows mutably).
- Borrowing lets a function use a value without invalidating the caller's variable; taking ownership does invalidate it (unless the value implements `Copy`).
- A function's final, semicolon-less expression is its return value, per Lesson 02.

## Key Terms

- **Ownership-aware parameter** — a Rust function parameter's type, which specifies not just the data type but its ownership relationship (owned, immutably borrowed, or mutably borrowed).

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between a function parameter typed `String`, `&String`, and `&mut String`?**
   `String` takes ownership — the caller's variable is moved into the function and becomes invalid afterward (unless explicitly cloned first). `&String` borrows immutably — the function can read the value, but the caller's variable remains valid and unmodified. `&mut String` borrows mutably — the function can both read and modify the value in place, and the caller's variable remains valid (reflecting any changes) afterward, but the caller must also mark the borrow as mutable at the call site (`&mut variable`).

2. **Why would you prefer a `&str` parameter over a `String` parameter for a function that only reads a string?**
   Taking `&str` (or `&String`, though `&str` is more flexible since it also accepts string literals and slices) avoids forcing every caller to either give up ownership of their `String` or clone it just to call the function — the function gets read access without requiring the caller to make any ownership sacrifice, which is both more efficient and more ergonomic for callers.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
