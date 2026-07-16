# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Write generic functions and structs.
- Use trait bounds to constrain generic type parameters.
- Understand **monomorphization** — Rust's compile-time strategy for generics, closest to C++'s templates among this repository's languages.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

Rust generics are resolved via **monomorphization**: like C++ templates, the compiler generates a separate, fully-specialized version of a generic function/struct for every distinct concrete type it's used with — `Stack<i32>` and `Stack<String>` become genuinely separate compiled code, with zero runtime overhead or type-erasure limitations (unlike Java's fully-erased generics, and closer to — though implemented differently than — C#'s reification). This is the fourth distinct generics implementation strategy covered across this repository's language courses (Java: erasure; C#: partial reification; C++: monomorphization via templates; Rust: monomorphization via trait-bound-checked generics).

## Generic Functions

```rust
fn first<T>(items: &[T]) -> &T {
    &items[0]
}

println!("{}", first(&[1, 2, 3]));           // T inferred as i32
println!("{}", first(&["a", "b"]));           // T inferred as &str
```

## Trait Bounds: Constraining Generics

```rust
use std::cmp::PartialOrd;

fn largest<T: PartialOrd + Copy>(items: &[T]) -> T { // T must support ordering AND be Copy-able
    let mut largest = items[0];
    for &item in items {
        if item > largest {
            largest = item;
        }
    }
    largest
}

println!("{}", largest(&[3, 7, 2, 9, 4]));
```

`T: PartialOrd + Copy` is a **trait bound** — it restricts `T` to types implementing both `PartialOrd` (supports `<`/`>` comparisons) and `Copy` (can be duplicated cheaply, bit-for-bit, rather than moved) — directly analogous to Java's `<T extends Comparable<T>>`, C#'s `where T : IComparable<T>`, and C++'s `concepts`, each expressing the same underlying idea through their own generics model.

## Generic Structs

```rust
struct Stack<T> {
    items: Vec<T>,
}

impl<T> Stack<T> {
    fn new() -> Self {
        Stack { items: Vec::new() }
    }
    fn push(&mut self, item: T) {
        self.items.push(item);
    }
    fn pop(&mut self) -> Option<T> { // Option, not a panic -- an empty stack is a normal case
        self.items.pop()
    }
}
```

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints a generic `first<T>` function correctly inferring `i32` and `&str`, a trait-bounded `largest<T: PartialOrd + Copy>` function, and a generic `Stack<T>` used with two concrete types, including its `Option`-returning `pop()`.

## Common Mistakes

- Forgetting a needed trait bound, then being unable to call a method (like `>`, requiring `PartialOrd`) inside the generic function body — the compiler will name exactly which bound is missing.
- Assuming Rust generics behave like Java's fully-erased ones — Rust generates genuinely separate compiled code per concrete type (monomorphization), with no runtime type-erasure limitations, much closer to C++ templates in strategy (though Rust's trait-bound system gives clearer, more localized error messages than unconstrained C++ templates typically did before C++20 concepts).

## Best Practices

- Add the narrowest trait bound(s) a generic function/struct actually needs.
- Prefer `Option<T>`-returning methods (like `Vec::pop`) over panicking ones for operations that have a normal "empty"/"absent" case.

## Real-World Usage

`Vec<T>`, `HashMap<K, V>`, `Option<T>`, and `Result<T, E>` are all themselves generic types built using exactly this mechanism — understanding generic structs and trait bounds is prerequisite to reading almost any non-trivial Rust function signature or standard library type.

## Summary

- Rust generics use monomorphization — the compiler generates fully-specialized code per concrete type, similar in strategy to C++ templates, unlike Java's erasure.
- Trait bounds (`T: Trait1 + Trait2`) constrain a generic type parameter to types implementing the required traits, directly analogous to bounded generics in every other statically-typed language course here.
- Generic structs (`Stack<T>`) combined with an `impl<T>` block provide reusable, type-safe containers.

## Key Terms

- **Monomorphization** — Rust's (and C++ templates') strategy of generating a separate, fully-specialized compiled implementation per concrete generic type argument.
- **Trait bound** — a constraint (`T: SomeTrait`) restricting a generic type parameter to types implementing specific traits.

## Interview Questions

1. **What is monomorphization, and how does it relate to Rust's zero-cost-abstraction philosophy?**
   Monomorphization is the compile-time process of generating a separate, fully-specialized version of a generic function/struct for each concrete type it's actually used with in the program — `Stack<i32>` and `Stack<String>` become entirely independent compiled code with no shared runtime representation or dispatch overhead. This is what lets Rust generics be a "zero-cost abstraction": the generated code is just as efficient as if you'd hand-written a separate, non-generic version for each type, with none of Java's runtime type-erasure overhead/limitations.

2. **What's a trait bound, and how does it compare to Java's `<T extends Comparable<T>>` or C#'s `where T : IComparable<T>`?**
   A trait bound (`T: SomeTrait`, or with multiple bounds `T: Trait1 + Trait2`) restricts a generic type parameter to only types implementing the specified trait(s), letting the generic function/struct body safely call any method those traits require. This serves exactly the same purpose as Java's bounded generics or C#'s `where` clauses — restricting what a generic parameter can be so the compiler can verify the generic code's correctness — just expressed through Rust's trait system specifically.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
