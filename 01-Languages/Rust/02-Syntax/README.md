# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Understand Rust is **expression-oriented** — most things that look like statements are actually expressions producing a value.
- Write comments (line, block, and doc comments).
- Understand the significance of a trailing semicolon (or its absence).

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

Rust is deeply **expression-oriented** — `if`, `match`, blocks (`{ }`), and even loops can all produce values directly, a much more pervasive version of what a ternary operator does in C-family languages. The presence or absence of a trailing semicolon is semantically significant: an expression **without** a trailing semicolon at the end of a block is that block's value; adding a semicolon turns it into a statement (discarding its value, evaluating to `()`, Rust's "unit" / empty-tuple type).

## Expressions Everywhere

```rust
let x = 5;
let y = if x > 0 { "positive" } else { "non-positive" }; // if is an EXPRESSION here
println!("{}", y);

let z = {
    let a = 1;
    let b = 2;
    a + b // no semicolon -- this is the block's VALUE, returned as z's value
};
println!("{}", z); // 3
```

## Comments

```rust
// single-line comment
/* block comment */

/// Doc comment -- generates documentation via `cargo doc`, attached to the item below.
fn greet() {}
```

## The Semicolon's Semantic Significance

```rust
fn add_one(x: i32) -> i32 {
    x + 1 // no semicolon -- this expression's value IS the function's return value
}

fn add_one_wrong(x: i32) -> i32 {
    x + 1; // semicolon turns this into a discarded statement -- COMPILE ERROR: expected i32, found ()
}
```

Unlike every C-family language in this repository, a missing semicolon in Rust isn't a mistake to fix — it's often exactly correct and meaningful, marking "this expression's value is what this block evaluates to."

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints results demonstrating `if` as an expression, a block producing a value, and a function returning its final expression's value with no explicit `return` needed.

## Common Mistakes

- Adding a trailing semicolon to a function's final expression when you meant for it to be the return value — this is a genuine compile error (type mismatch: expected the return type, found `()`), not just a style issue.
- Assuming Rust syntax requires `return` for every function — an explicit `return` is available (and needed for early returns) but a function's final, semicolon-less expression is the idiomatic way to return its "normal" result.

## Best Practices

- Prefer the final-expression-as-return-value style over explicit `return` for a function's normal, final result; use `return` only for early returns.
- Use `///` doc comments on public items — `cargo doc` generates browsable documentation from them, similar to Javadoc/XML doc comments in the Java/C# courses.

## Real-World Usage

Expression-oriented syntax is used pervasively throughout idiomatic Rust — `match` expressions (Lesson 05) producing values, iterator chains (Lesson 12) built from expressions, and error handling (Lesson 09) all lean on this "everything is an expression" foundation.

## Summary

- Rust is expression-oriented: `if`, `match`, and blocks can all produce values directly.
- A trailing semicolon turns an expression into a statement (discarding its value as `()`); omitting it makes the expression the block's value.
- A function's final, semicolon-less expression is its idiomatic return value — `return` is reserved for early returns.

## Key Terms

- **Expression-oriented** — a language style where most constructs (including `if`/`match`/blocks) produce values directly, rather than being pure statements.
- **Unit type (`()`)** — Rust's "no meaningful value" type, similar in spirit to `void`, but a genuine, nameable type — the value of any statement (an expression with a trailing semicolon).

## Interview Questions

1. **What does it mean that Rust is "expression-oriented"?**
   Most Rust constructs that look like statements in other languages — `if`/`else`, `match`, and even a `{ }` block — are actually expressions that produce a value, which can be assigned to a variable or used as a function's return value. This is a more pervasive version of what a ternary operator provides in C-family languages, extended to nearly every control-flow construct.

2. **What's the difference between a Rust function ending in `x + 1` versus `x + 1;`?**
   `x + 1` (no semicolon) is an expression — its value becomes the function's return value if it's the final line of the function body. `x + 1;` (with a semicolon) is a statement — the expression's value is discarded, and the statement itself evaluates to `()` (the unit type), which would be a compile error if the function's declared return type isn't `()`.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
