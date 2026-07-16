# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Install Rust (via `rustup`) and verify it.
- Compile and run a single `.rs` file with `rustc`.
- Understand `cargo` as Rust's unified build tool/package manager (previewed here, expanded in Lesson 15).

## Prerequisites

None — entry point of the Rust course.

## Concept

Rust compiles directly to native machine code with no runtime/VM — like Go and C++, a compiled Rust binary has no external runtime dependency. `rustc` is the compiler itself (used directly for single-file lessons in this course); `cargo` is Rust's build tool and package manager, handling dependencies, building, testing, and more for real multi-file projects (Lesson 15 onward for anything needing external crates).

## Syntax

```rust
// main.rs
fn main() {
    println!("Hello, Rust");
}
```

```bash
rustc main.rs -o main && ./main
```

`fn main()` is the mandatory entry point, directly analogous to every other compiled language course's entry point. `println!` is a **macro** (indicated by the `!`), not an ordinary function — Rust's macro system enables compile-time-checked, printf-style string formatting directly in the standard library.

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints a greeting and the rustc version used to compile it.

## Common Mistakes

- Forgetting the `!` on `println!` — it's a macro, not a function; `println("...")` (no `!`) is a compile error.
- Assuming Rust needs a separate runtime installed on the deployment machine — like Go/C++, a compiled Rust binary is self-contained.

## Best Practices

- Use `rustc` directly for single-file scripts/lessons; use `cargo` for any real, multi-file, or dependency-needing project (Lesson 15).
- Run `cargo clippy` (or just be aware it exists) once working within a `cargo` project — Rust's official linter catches many idiom issues beyond what the compiler itself flags.

## Real-World Usage

Virtually all real Rust projects use `cargo`, even single-binary ones, specifically for its integrated dependency management, testing, and build profile support — `rustc` directly is primarily for learning/single-file scripts, exactly as used throughout most of this course.

## Summary

- Rust compiles to native, dependency-free binaries — no runtime/VM needed, like Go and C++.
- `rustc` compiles a single file directly; `cargo` is the full build tool/package manager for real projects.
- `println!` is a macro (note the `!`), not an ordinary function.

## Key Terms

- **`rustc`** — the Rust compiler.
- **`cargo`** — Rust's official build tool and package manager.
- **Macro (`!`)** — a Rust construct that expands into code at compile time; `println!` is the most common example.

## Interview Questions

1. **What's the difference between `rustc` and `cargo`?**
   `rustc` is the Rust compiler itself — it can compile a single `.rs` file directly, as used throughout most of this course. `cargo` is Rust's official build tool and package manager, handling multi-file project builds, dependency resolution/downloading, running tests, and more — virtually all real Rust projects use `cargo` rather than invoking `rustc` directly.

2. **Why does `println!` have a `!` after it?**
   Because it's a macro, not an ordinary function — Rust's macro system lets `println!` perform compile-time-checked format-string parsing (catching a mismatched `{}` placeholder count at compile time, something a plain function couldn't do) and expand into the appropriate formatting/output code before the program is compiled.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
