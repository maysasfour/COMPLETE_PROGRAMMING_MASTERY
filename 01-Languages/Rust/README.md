# Rust

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Rust Is

Rust is a statically-typed, compiled systems language whose defining feature is **memory safety without a garbage collector**, enforced entirely at compile time through its **ownership and borrowing** system. This is a genuinely new mental model compared to every other language in this repository: Python/JavaScript/Java/C#/Go all use a garbage collector, and C++ leaves memory safety to the programmer's discipline (mitigated by RAII/smart pointers, but not compiler-enforced) — Rust's compiler statically proves memory safety (no use-after-free, no data races, no null dereferences) before the program ever runs, rejecting code that can't be proven safe.

## Why / Where It's Used

- **Systems programming with safety guarantees** — an increasingly common C/C++ replacement where memory safety matters (browser engines, OS components; parts of the Linux kernel now accept Rust).
- **Performance-critical services** — Rust compiles to native code with no runtime/GC overhead, competitive with C++ for raw performance.
- **WebAssembly** — Rust is one of the most mature, popular languages for compiling to WASM.
- **CLI tools and infrastructure** — similar to Go's niche, Rust produces fast, dependency-free binaries; tools like `ripgrep` and large parts of the modern JavaScript tooling ecosystem (SWC, some of Node's newer internals) are written in Rust.

## Advantages

- Compile-time-enforced memory safety with zero runtime cost — no GC pauses, no runtime safety checks, since the compiler proves safety statically.
- No data races are possible in safe Rust — the ownership/borrowing system prevents them at compile time, a genuinely unique guarantee among mainstream languages.
- Excellent tooling (`cargo` as a unified build tool/package manager, unlike C++'s fragmented ecosystem).
- `Result`/`Option` plus the `?` operator provide explicit, ergonomic error handling without exceptions.

## Disadvantages

- The steepest learning curve of any language in this repository — the "borrow checker" (the part of the compiler enforcing ownership rules) famously takes real time to become fluent with, and fighting it is a rite of passage for new Rust developers.
- Compile times can be slow for large projects, a real trade-off for the extensive compile-time analysis being performed.
- The type system and generics (traits, lifetimes) are more conceptually demanding upfront than most other languages here, though the payoff is stronger compile-time guarantees.

## How to Install

```bash
# Download from https://rustup.rs/ (rustup is the standard installer/toolchain manager)
rustc --version
cargo --version
```

This course was written and verified against **Rust 1.97 (stable)**, but everything in it works on any reasonably recent stable Rust release unless a lesson says otherwise.

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `main.rs`. From the repository root:

```bash
cd 01-Languages/Rust/03-Variables-and-Data-Types
rustc main.rs -o main && ./main
```

For lessons needing external crates (16-Database-Access, 17-API-Integration if using a networking crate, 18-Testing's more advanced features), see those lessons' specific `cargo`-based instructions.

## Common Beginner Mistakes

- **Fighting the borrow checker by fighting the model, not learning it** — most "the borrow checker won't let me do X" frustrations stem from a genuine data-race/use-after-free risk the code would otherwise have; the fix is almost always restructuring ownership, not finding a workaround (Lesson 03).
- **Overusing `.clone()`** to silence borrow-checker errors — often the beginner's first instinct, and sometimes genuinely fine, but frequently a sign the code's ownership structure could be designed more idiomatically instead.
- **Assuming Rust has exceptions** — it doesn't; `Result<T, E>`/`Option<T>` plus the `?` operator are the idiomatic mechanism (Lesson 09), a more explicit and pervasive version of the `(value, error)` pattern from the Go course.
- **Confusing `String` and `&str`** — `String` is an owned, growable string; `&str` is a borrowed string slice/view. Function parameters conventionally take `&str` for flexibility (Lesson 08).

## Best Practices

- Prefer borrowing (`&T`/`&mut T`) over cloning wherever the borrow checker allows it — reach for `.clone()` deliberately, not as a first reflex.
- Use `Result<T, E>` for recoverable errors and the `?` operator to propagate them concisely; reserve `panic!`/`.unwrap()` for genuinely unrecoverable situations or well-understood invariants.
- Prefer `&str` parameters over `&String` for maximum flexibility (any `String` can be borrowed as a `&str`, but not vice versa).
- Run `cargo clippy` (Rust's official linter) — it catches many idiom violations and subtle bugs beyond what the compiler itself flags.

## Interview Questions

1. **How does Rust guarantee memory safety without a garbage collector?**
   Through its ownership and borrowing system, checked entirely at compile time: every value has exactly one owner responsible for freeing it when it goes out of scope (like C++'s RAII, but compiler-enforced rather than convention-based), and the "borrow checker" ensures references (borrows) never outlive the data they point to, and that mutable and immutable borrows of the same data can never coexist. This eliminates use-after-free, double-free, and data races as categories of bug entirely in "safe" Rust, with zero runtime overhead — all the checking happens before the program runs.

2. **What's the difference between `String` and `&str` in Rust?**
   `String` is an owned, heap-allocated, growable string — you have full ownership and can mutate/extend it. `&str` ("string slice") is a borrowed, immutable view into string data (owned by something else — a `String`, a string literal, etc.), not itself an owner. Function parameters conventionally take `&str` since any `String` can be borrowed as a `&str` (via automatic deref coercion), making `&str` parameters strictly more flexible for callers.

3. **How does Rust handle errors without exceptions?**
   Through `Result<T, E>` (a value that's either `Ok(T)` for success or `Err(E)` for failure) for recoverable errors, and `Option<T>` (`Some(T)` or `None`) for values that might be absent — both checked exhaustively via pattern matching or handled concisely with the `?` operator, which propagates an `Err`/`None` upward automatically. `panic!` exists for genuinely unrecoverable situations (similar to Go's `panic`), but idiomatic Rust reserves it for programming errors, not routine/expected failure modes.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Installing Rust/Cargo, `rustc`, single-file compilation |
| 02 | [Syntax](02-Syntax/README.md) | `fn main()`, expressions-as-statements, comments |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Ownership, borrowing, `mut`, immutability by default |
| 04 | [Operators](04-Operators/README.md) | Arithmetic/comparison, no null (`Option<T>` instead), no implicit conversions |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/match as expressions, loops, pattern matching depth |
| 06 | [Functions](06-Functions/README.md) | Ownership-aware parameters, expression-based returns |
| 07 | [Collections](07-Collections/README.md) | `Vec`, `HashMap`, iterators |
| 08 | [Strings](08-Strings/README.md) | `String` vs. `&str`, UTF-8, ownership implications |
| 09 | [Error Handling](09-Error-Handling/README.md) | `Result`/`Option`, the `?` operator, `panic!` |
| 10 | [File Handling](10-File-Handling/README.md) | `std::fs`, `serde` for JSON (not built-in) |
| 11 | [OOP](11-OOP/README.md) | Structs, `impl`, traits (no classes/inheritance) |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Closures, iterator adapters (`map`/`filter`/`fold`) |
| 13 | [Generics](13-Generics/README.md) | Generic functions/structs, trait bounds, monomorphization |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | Threads with compile-time-enforced safety, `async`/`await` |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | `mod`, crates, `Cargo.toml` |
| 16 | [Database Access](16-Database-Access/README.md) | SQLite via `rusqlite`, parameterized queries |
| 17 | [API Integration](17-API-Integration/README.md) | HTTP via a crate (`ureq`), since none is built in |
| 18 | [Testing](18-Testing/README.md) | Built-in `#[test]`, `cargo test` |
| 19 | [Best Practices](19-Best-Practices/README.md) | Synthesis checklist across lessons 01–18 |
| 20 | [Exercises](20-Exercises/README.md) | 7 standalone problems: lifetimes, custom errors + `?`, trait defaults, generics/monomorphization, `Fn`/`FnMut`/`FnOnce` |
| 21 | [Solutions](21-Solutions/README.md) | Verified, compiled solutions to all 7 exercises |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker — `rusqlite` (bundled SQLite), `lib`+`bin` crate split, `cargo test` (11 unit + 3 integration) |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order — Rust's ownership model (Lesson 03) is foundational to nearly everything after it, more so than any single early lesson in any other language course in this repository. Lessons 05, 06, and 07 have `Exercises/`/`Solutions/` pairs. After 19, [20-Exercises](20-Exercises/README.md) → [21-Solutions](21-Solutions/README.md) → [22-Mini-Projects](22-Mini-Projects/README.md) close out the course with cross-cutting practice problems and a complete SQLite-backed CLI application.

**Previous language:** [Go](../Go/README.md) | **Next:** [PHP](../PHP/README.md)
