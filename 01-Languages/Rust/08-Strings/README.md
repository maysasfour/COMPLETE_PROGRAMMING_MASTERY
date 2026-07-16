# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Distinguish `String` (owned, growable) from `&str` (borrowed string slice) precisely.
- Use common string operations.
- Understand Rust strings are UTF-8 and cannot be indexed by integer position directly — a stricter, compile-time-enforced version of the Go course's byte-vs-rune distinction.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

`String` is an owned, heap-allocated, growable string (conceptually similar to Java's `StringBuilder` or C++'s `std::string` in mutability, but Rust-specific in its ownership implications). `&str` ("string slice") is a borrowed, immutable view into string data — owned by something else (a `String`, a string literal embedded in the binary, etc.). Every Rust string is guaranteed valid UTF-8, and — going further than the Go course's byte-vs-rune distinction — **Rust doesn't even allow direct integer indexing into a string** (`s[0]` is a compile error), specifically because a byte index might land in the middle of a multi-byte character, and Rust's design philosophy prevents that class of bug at compile time rather than leaving it as a runtime footgun.

## `String` vs. `&str`

```rust
let owned: String = String::from("hello"); // owned, growable
let borrowed: &str = "hello";                  // a string literal is already a &str

fn takes_str(s: &str) -> usize { // &str parameter accepts BOTH a &String and a literal
    s.len()
}
takes_str(&owned);   // &String coerces to &str automatically
takes_str(borrowed); // already a &str
```

## No Direct Integer Indexing

```rust
let s = String::from("héllo");
// let first_char = s[0]; // COMPILE ERROR: `String` cannot be indexed by `{integer}`

let first_char = s.chars().next(); // the correct way: iterate as chars (Unicode scalar values)
println!("{:?}", first_char); // Some('h')

println!("byte length: {}", s.len()); // 6 -- byte length, since 'é' is 2 bytes in UTF-8
println!("char count: {}", s.chars().count()); // 5 -- actual character count
```

This is a stronger guarantee than Go's situation (Lesson 08 of the Go course): Go *allows* byte-indexing a string (`s[i]`), which can silently return part of a multi-byte character; Rust makes the equivalent operation a **compile error**, forcing you to use `.chars()` (or explicit byte-level APIs, when genuinely needed) instead.

## Common String Operations

```rust
let s = "  hello  ";
println!("{}", s.trim());
println!("{}", s.to_uppercase());
println!("{}", s.contains("ell"));
println!("{:?}", "a,b,c".split(',').collect::<Vec<&str>>());
println!("{}", ["a", "b"].join("-"));
```

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints `String`/`&str` usage, common operations, and a byte-length-vs-character-count contrast for a string containing a multi-byte character.

## Common Mistakes

- Trying to index a string directly (`s[0]`) — a compile error in Rust, not a runtime footgun the way it can be in Go/C++.
- Using `s.len()` and assuming it's the character count — like Go, it's always the **byte** length.
- Taking `&String` as a parameter type instead of `&str` — `&str` is strictly more flexible, since it accepts both `&String` (via automatic deref coercion) and string literals directly.

## Best Practices

- Prefer `&str` for function parameters over `&String`, for maximum caller flexibility.
- Use `.chars()` to iterate actual characters; use `.len()` only when you specifically need the byte length (e.g., for byte-buffer sizing).
- Reach for `String` when you need to own/build/mutate string data; use `&str` for read-only views.

## Real-World Usage

The `String`/`&str` split is one of the first ownership-related distinctions every Rust developer internalizes, since it appears in virtually every function signature touching text — getting it right (borrowing with `&str` wherever ownership isn't genuinely needed) is a hallmark of idiomatic Rust code.

## Summary

- `String` is owned/growable; `&str` is a borrowed, immutable string slice — prefer `&str` for function parameters.
- Rust strings are guaranteed valid UTF-8 and cannot be indexed by integer position at all (a compile error), a stricter guarantee than the Go course's byte-indexing-is-allowed-but-risky situation.
- `.len()` returns byte length; `.chars().count()` returns actual character count.

## Key Terms

- **`String`** — Rust's owned, growable, heap-allocated string type.
- **`&str` (string slice)** — a borrowed, immutable view into UTF-8 string data.

## Interview Questions

1. **What's the difference between `String` and `&str` in Rust?**
   `String` is an owned, growable, heap-allocated string — you have full ownership and can mutate/extend it. `&str` is a borrowed, immutable reference to string data owned by something else (a `String`, a string literal, or a slice of either) — it's the more flexible type to accept as a function parameter, since a `&String` automatically coerces to `&str`, but not vice versa.

2. **Why can't you index a Rust `String` with an integer, unlike most other languages (including Go)?**
   Because Rust strings are guaranteed valid UTF-8, and a byte-position index might land in the middle of a multi-byte character, producing an invalid, meaningless partial character. Rather than allowing this and leaving it as a runtime risk (as Go does, where `s[i]` is legal but can slice a multi-byte character), Rust makes direct integer indexing into a string a compile error entirely, forcing you to use `.chars()` (or explicit, clearly-labeled byte-level APIs) instead.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
