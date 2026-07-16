# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read and write text files with `std::fs`.
- Understand Rust's standard library has no built-in JSON — like Java/C++, `serde`/`serde_json` (external crates) are needed.
- Handle a missing file via `Result`, following Lesson 09's pattern.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

`std::fs::read_to_string`/`std::fs::write` provide simple whole-file text operations, returning `Result<T, std::io::Error>` — following Lesson 09's pattern directly. Like Java and C++ (and unlike Go/Python/JavaScript/C#), **Rust's standard library has no built-in JSON support** — `serde` (a serialization/deserialization framework) plus `serde_json` (its JSON backend) is the near-universal ecosystem answer, but is a Cargo dependency, not part of `std`.

## Reading and Writing Text Files

```rust
use std::fs;

fs::write("notes.txt", "Hello, file system!\n")?; // returns Result<(), std::io::Error>
let contents = fs::read_to_string("notes.txt")?;    // returns Result<String, std::io::Error>
println!("{}", contents);
```

## Handling a Missing File

```rust
match fs::read_to_string("does-not-exist.txt") {
    Ok(contents) => println!("{}", contents),
    Err(e) if e.kind() == std::io::ErrorKind::NotFound => {
        println!("File doesn't exist -- using defaults");
    }
    Err(e) => println!("Unexpected error: {}", e),
}
```

`e.kind() == std::io::ErrorKind::NotFound` is Rust's specific-error-check idiom, directly analogous to Go's `os.IsNotExist(err)` and Java's catching `NoSuchFileException` specifically rather than a broad `IOException`.

## `serde`/`serde_json` (Not Built-In)

```rust
// Requires the `serde` and `serde_json` crates (Cargo.toml dependencies) -- NOT part of std.
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct Config {
    theme: String,
    font_size: i32,
}

let config = Config { theme: "dark".to_string(), font_size: 14 };
let json = serde_json::to_string(&config)?;
let loaded: Config = serde_json::from_str(&json)?;
```

`#[derive(Serialize, Deserialize)]` is a Rust **derive macro** — it auto-generates the serialization/deserialization code for the struct at compile time, requiring no manual field-by-field mapping code, similar in convenience to Go's struct tags but generating actual code rather than being read via reflection at runtime.

## Detailed Example

See [main.rs](main.rs) — writes and reads a text file, and handles a genuinely missing file via `Result`. (This lesson's example sticks to text-file I/O, which `std` supports natively, rather than introducing a `serde` dependency just for one lesson — matching the Java course's equivalent choice.)

## Expected Output

Compiling and running `main.rs` prints round-tripped text content and confirms a missing file is detected via `ErrorKind::NotFound`, handled gracefully rather than crashing.

## Common Mistakes

- Assuming Rust's standard library includes JSON support the way Go/Python/JavaScript/C# do — it doesn't; `serde`/`serde_json` (a Cargo dependency) is needed, matching Java/C++'s equivalent gap.
- Using `.unwrap()` on a file operation's `Result` instead of properly handling a plausible failure (like a missing file) — panics immediately instead of allowing graceful handling.
- Checking only the broad `Err` case instead of `e.kind() == ErrorKind::NotFound` specifically, when only a missing file should be handled specially.

## Best Practices

- Use `?` to propagate file-operation errors up to a caller equipped to handle them, rather than `.unwrap()`-ing at the point of the I/O call.
- Check `e.kind()` for the specific `std::io::ErrorKind` variant relevant to the situation you're actually prepared to handle.

## Real-World Usage

`serde`/`serde_json` is essentially the de facto standard for JSON (and many other formats, via other `serde` backends) throughout the Rust ecosystem — nearly every Rust project touching JSON adds it as a dependency, exactly like Java projects nearly universally add Jackson.

## Summary

- `std::fs` provides simple, `Result`-returning whole-file text I/O, built into the standard library.
- Rust's standard library has **no built-in JSON support** — `serde`/`serde_json` (external crates) are the near-universal solution, matching Java/C++'s equivalent gaps.
- `e.kind() == ErrorKind::NotFound` is Rust's specific-error-check idiom for a missing file.

## Key Terms

- **`std::fs`** — Rust's standard library module for file-system operations.
- **`serde`** — the de facto standard Rust serialization/deserialization framework, not part of the standard library.
- **Derive macro** — a Rust macro (like `#[derive(Serialize, Deserialize)]`) that auto-generates code for a type at compile time.

## Interview Questions

1. **Does Rust's standard library include JSON support?**
   No — like Java and C++, Rust's `std` has no built-in JSON parsing/serialization. `serde` combined with `serde_json` is the near-universal ecosystem solution, added as a Cargo dependency, using derive macros (`#[derive(Serialize, Deserialize)]`) to auto-generate the conversion code for a struct at compile time.

2. **How do you check for a specific kind of I/O error in Rust, like "file not found"?**
   Compare `err.kind()` against the relevant `std::io::ErrorKind` variant (e.g., `ErrorKind::NotFound`) — this is Rust's equivalent of Go's `os.IsNotExist(err)` or catching a specific exception subtype in Java/C#, letting you handle a specific, expected failure mode differently from a broad catch-all `Err` branch.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
