# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else` as expressions (recap and extension from Lesson 02).
- Use `match` — Rust's exhaustive, compiler-enforced pattern matching, more powerful than any other language course's `switch`.
- Use `loop`, `while`, and `for`.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Rust's `match` is the most powerful pattern-matching construct covered in any language course in this repository — and critically, it's **exhaustive by compiler enforcement**: every possible case of the matched value's type must be handled, or the code fails to compile. This is a stronger guarantee than C#/Java's exhaustiveness-checked `switch` expressions (which only warn/error for specific patterns like sealed enums) — Rust enforces it universally, for every `match`.

## `match`: Exhaustive by Compiler Enforcement

```rust
enum Direction {
    North,
    South,
    East,
    West,
}

fn describe(d: Direction) -> &'static str {
    match d {
        Direction::North => "going up",
        Direction::South => "going down",
        Direction::East => "going right",
        Direction::West => "going left",
        // omitting any variant here is a COMPILE ERROR: non-exhaustive patterns
    }
}
```

If a new variant is later added to `Direction` without updating every `match` on it, **every one of those `match` expressions fails to compile** until updated — turning "forgot to handle a new case" into an immediate, unavoidable compile error across the entire codebase, not just a single opt-in check.

## `match` with Guards, Ranges, and Binding

```rust
let n = 5;
let description = match n {
    x if x < 0 => "negative",
    0 => "zero",
    1..=9 => "single digit", // inclusive range pattern
    _ => "large number",
};
println!("{}", description);
```

## Loops: `loop`, `while`, `for`

```rust
let mut count = 0;
loop { // infinite loop -- Rust's explicit "loop forever" keyword
    if count >= 3 { break; }
    println!("{}", count);
    count += 1;
}

while count < 6 {
    println!("{}", count);
    count += 1;
}

for i in 0..3 { // range-based for -- 0..3 is exclusive of 3
    println!("{}", i);
}

for item in vec![10, 20, 30].iter() {
    println!("{}", item);
}
```

`loop` can also return a value via `break value;` — a genuinely useful expression-oriented feature no other language course in this repository has in quite this form.

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints exhaustive `match` results (including guards and range patterns), and all three loop forms, including `loop` returning a value via `break`.

## Common Mistakes

- Forgetting a variant in a `match` over an enum — a compile error (`non-exhaustive patterns`), not a silent runtime gap, though it's still worth understanding as a "mistake" in the sense that the compiler will stop you and require a fix.
- Using `_` (the wildcard/catch-all pattern) too eagerly, silencing the exhaustiveness check's real value — if you actually want to be forced to update every `match` when a new variant is added, avoid `_` and list every variant explicitly.

## Best Practices

- Avoid a catch-all `_` arm in a `match` over your own enum types when you specifically want the compiler to force every future variant to be handled explicitly.
- Use `loop { ... break value; }` for a loop that computes and returns a value, rather than a mutable variable set inside the loop and read afterward.

## Real-World Usage

Exhaustive `match` over enums is one of Rust's most-cited advantages for maintainability — adding a new variant to an enum representing, say, application states or API response types immediately surfaces every place in the codebase that needs updating, as compile errors, rather than a runtime gap discovered later (or never).

## Summary

- `match` is exhaustive by compiler enforcement for every match, not just an opt-in check — omitting a variant is always a compile error.
- `match` supports guards (`if` conditions), inclusive ranges (`1..=9`), and binding, all in one unified construct.
- `loop`, `while`, and `for` are Rust's three loop forms; `loop` can return a value via `break value;`.

## Key Terms

- **Exhaustiveness (in `match`)** — the compiler-enforced requirement that every possible case of a matched value's type is handled.
- **`loop`** — Rust's explicit infinite-loop keyword, which can return a value via `break value;`.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **How does Rust's `match` exhaustiveness compare to `switch` in other languages?**
   Rust's `match` is exhaustive by compiler enforcement for every single `match` expression — omitting a variant of the matched type (unless a wildcard `_` arm is present) is always a compile error, with no opt-in required. This is stronger than most other languages' switch-exhaustiveness features (like C#'s pattern-matching switch, which primarily warns for sealed/enum types), and it means adding a new enum variant anywhere in a Rust codebase immediately surfaces every unhandled `match` as a compile error.

2. **Can a Rust `loop` return a value, and how?**
   Yes — `break value;` inside a `loop` makes the entire `loop` expression evaluate to `value`, letting you write `let result = loop { ... break computed_value; };` directly. This is a distinctly Rust feature, connecting back to Lesson 02's "everything is an expression" philosophy — `while` and `for` loops, by contrast, cannot return a value this way (they always evaluate to `()`).

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
