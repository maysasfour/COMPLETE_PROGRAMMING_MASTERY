# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use `Vec<T>` (Rust's dynamic array) and `HashMap<K, V>`.
- Use iterator adapters (`.map`, `.filter`, `.fold`) for transformations.
- Understand how ownership/borrowing rules apply to collections specifically (iterating by reference vs. by value).

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

`Vec<T>` is Rust's growable array (like `ArrayList`/`List<T>`/`std::vector` from the other language courses); `HashMap<K, V>` is Rust's hash map. Both fully participate in the ownership system from Lesson 03 — iterating a `Vec<T>` by value (`for x in vec`) *moves* each element out and consumes the vector, while iterating by reference (`for x in &vec`) borrows each element, leaving the vector usable afterward. This distinction doesn't exist in any of the garbage-collected language courses in this repository.

## `Vec<T>`

```rust
let mut scores = vec![95, 88, 76]; // the vec! macro
scores.push(100);
println!("{}", scores[0]); // indexing -- PANICS on out-of-bounds, not undefined behavior like C++
println!("{:?}", scores.get(0)); // .get() returns Option<&T> -- safe, no panic
```

`.get(index)` returns `Option<&T>` (`Some(&value)` or `None`) instead of panicking on an out-of-range index — the safe, `Option`-based alternative to indexing, directly connecting back to Lesson 04's "no null, use `Option`" theme.

## `HashMap<K, V>`

```rust
use std::collections::HashMap;

let mut ages: HashMap<String, i32> = HashMap::new();
ages.insert(String::from("Ada"), 30);

match ages.get("Ada") {
    Some(age) => println!("Ada is {}", age),
    None => println!("not found"),
}
```

## Iterating: By Value vs. By Reference

```rust
let numbers = vec![1, 2, 3];

for n in &numbers { // borrows -- numbers still usable afterward
    println!("{}", n);
}
println!("{:?}", numbers); // fine -- only borrowed above

// for n in numbers { ... } // this would MOVE (consume) numbers -- unusable afterward
```

## Iterator Adapters: `.map`, `.filter`, `.fold`

```rust
let numbers = vec![1, 2, 3, 4, 5];

let doubled: Vec<i32> = numbers.iter().map(|n| n * 2).collect();
let evens: Vec<&i32> = numbers.iter().filter(|&&n| n % 2 == 0).collect();
let total: i32 = numbers.iter().fold(0, |acc, n| acc + n);
```

Like C++'s `<algorithm>` and Go/Java/C#'s Streams/LINQ, Rust's iterator adapters are **lazy** — `.map`/`.filter` build up a chain that only actually executes when a terminal operation (`.collect()`, `.fold()`, `.sum()`) consumes it.

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints `Vec`/`HashMap` usage (including safe `.get()` vs. panicking indexing), a demonstration that borrowing-based iteration leaves a `Vec` usable afterward, and iterator adapters transforming a collection.

## Common Mistakes

- Indexing a `Vec` with `[i]` on a possibly-out-of-range index instead of using `.get(i)` when out-of-range is a plausible, recoverable case — `[i]` panics immediately.
- Iterating a `Vec` by value (`for x in vec`) when you still need the vector afterward — this consumes (moves) it; use `for x in &vec` to borrow instead.
- Forgetting iterator adapters are lazy — a chain of `.map`/`.filter` alone does nothing until a terminal operation like `.collect()` actually runs it.

## Best Practices

- Use `.get()` (returning `Option<&T>`) instead of indexing whenever an out-of-range access is a real possibility you want to handle, not crash on.
- Iterate by reference (`&vec`/`.iter()`) by default; only iterate by value (consuming the collection) when you specifically intend to give up ownership of it.
- Chain iterator adapters for data transformation, mirroring the same idiom from every other language course's collections lesson.

## Real-World Usage

Rust's iterator adapters are frequently cited as one of the language's best-designed features — despite compiling to code as fast as a hand-written loop (a "zero-cost abstraction"), they read as clearly as the equivalent Stream/LINQ/`<algorithm>` code from this repository's other language courses.

## Summary

- `Vec<T>`/`HashMap<K,V>` are Rust's core dynamic collections, fully participating in ownership/borrowing.
- `.get()` returns `Option<&T>` safely; indexing (`[i]`) panics on out-of-range access.
- Iterating by reference (`&vec`) borrows; iterating by value (`vec`) moves/consumes the collection.
- Iterator adapters (`.map`/`.filter`/`.fold`) are lazy, mirroring the idiom from every other language course.

## Key Terms

- **`Vec<T>`** — Rust's growable array type.
- **Iterator adapter** — a lazy, chainable collection-transformation method (`.map`, `.filter`, etc.), requiring a terminal operation to actually execute.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between indexing a `Vec` with `[i]` and calling `.get(i)`?**
   `vec[i]` panics immediately at runtime if `i` is out of bounds — an unrecoverable crash unless caught via `std::panic::catch_unwind` (rarely used for this). `.get(i)` returns `Option<&T>` — `Some(&value)` if `i` is valid, `None` otherwise — letting you handle an out-of-range access gracefully via pattern matching, without any panic at all.

2. **What's the difference between `for x in vec` and `for x in &vec`?**
   `for x in vec` iterates by value, moving (consuming) the vector — after the loop, `vec` is no longer usable. `for x in &vec` iterates by reference, borrowing each element — the vector remains fully valid and usable after the loop. This distinction is a direct application of Lesson 03's ownership/borrowing model to collection iteration specifically.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
