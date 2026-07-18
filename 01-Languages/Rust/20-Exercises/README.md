# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 (control-flow `match`, mutable-borrow string helpers, and iterator-based word frequency, respectively) — solve those first if you haven't, then come back here for problems built specifically around lifetimes, custom error enums with `?`, trait default methods, generics/monomorphization, and `Fn`/`FnMut`/`FnOnce` closures.

Attempt each problem yourself in a scratch `.rs` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`exercise-01` &harr; `solution-01.rs`).

## Exercise 01 — Lifetimes and Borrowing (Beginner)

**Lessons used:** Variables and Data Types (03), Operators (04), Strings (08)

Write `fn longest_word<'a>(text: &'a str) -> &'a str` that returns the longest whitespace-separated word in `text` as a borrowed slice of the *original* string — no `.to_string()`, no `.clone()`, no new allocation of any kind. On a tie, return the first longest word encountered.

Then write `fn total_chars(words: &[String]) -> usize` that borrows a slice of `String`s (not `Vec<String>` by value, and not `&Vec<String>`) and returns the sum of each word's `.chars().count()` (not `.len()` — the two differ for non-ASCII text, per Lesson 08).

- Constraints: `longest_word` must compile with **zero** allocations in its body; `total_chars` must leave the caller's original `Vec<String>` fully usable (owned, unmoved) after the call.
- Prove both properties by printing the original `text`/`words` again *after* calling each function.

## Exercise 02 — Custom Error Enum and the `?` Operator (Beginner/Intermediate)

**Lessons used:** Error Handling (09)

Write a tiny "key=value" config-line parser. Define:

```rust
enum ConfigError {
    MissingField(String),
    InvalidNumber { field: String, source: std::num::ParseIntError },
}
```

Implement `std::fmt::Display` (a human-readable message per variant) and `std::error::Error` for `ConfigError`. Write `fn parse_config(text: &str) -> Result<Config, ConfigError>` where `Config` has `name: String`, `retries: u32`, `timeout_ms: u64`, parsed from lines like `name=worker-1`. Use the `?` operator throughout — no manual `match` on every field's `Result`.

Demonstrate three calls: one with all three fields present and valid (`Ok`), one missing a field (`Err(ConfigError::MissingField(...))`), and one with a non-numeric value for `retries` (`Err(ConfigError::InvalidNumber { .. })`), printing each `Err`'s `Display` message.

## Exercise 03 — Traits With Default Methods (Intermediate)

**Lessons used:** OOP (11)

Define `trait Employee` with two **required** methods (`fn name(&self) -> &str`, `fn base_salary(&self) -> f64`) and two methods with **default implementations**: `fn bonus_multiplier(&self) -> f64 { 1.0 }` and `fn total_pay(&self) -> f64 { self.base_salary() * self.bonus_multiplier() }` (a default method calling both a required method and another default method — prove this compiles and works).

Implement `Employee` for an `Engineer` struct that accepts every default as-is, and for a `Manager` struct that **overrides** `bonus_multiplier` to return `1.2`. Print `total_pay()` for one of each, showing the override changes `total_pay()`'s result even though `total_pay()` itself was never redefined for `Manager`.

## Exercise 04 — Generics and Monomorphization (Intermediate)

**Lessons used:** Generics (13)

Write `fn find_max<T: PartialOrd + Copy>(items: &[T]) -> Option<T>` (returns `None` for an empty slice, otherwise the largest element) and a generic struct `struct Pair<T> { first: T, second: T }` with a method `fn larger(&self) -> T where T: PartialOrd + Copy`.

Call `find_max` with a `&[i32]`, a `&[f64]`, and a `&[char]` — three genuinely different concrete types through the *same* generic function. In your solution's writeup (a comment or the exercise's own notes when you review Solutions), explain why this is *monomorphization* (a separate compiled copy of `find_max` per concrete `T`) rather than the single shared implementation Java's type-erased generics or C++ templates via a vtable would produce.

## Exercise 05 — Closures: `Fn`, `FnMut`, and `FnOnce` (Intermediate/Advanced)

**Lessons used:** Functional Concepts (12)

Write three functions, one per closure trait:

- `fn apply<F: Fn(i32) -> i32>(f: F, x: i32) -> i32` — calls `f` once and returns the result. Pass it a closure that squares its argument.
- `fn run_n_times<F: FnMut() -> i32>(mut f: F, n: usize) -> Vec<i32>` — calls `f` `n` times, collecting each result. Pass it a closure that captures a `mut` counter by reference and increments it on every call (so the returned `Vec` is `[1, 2, 3, ...]`, not `n` copies of the same value).
- `fn consume<F: FnOnce() -> String>(f: F) -> String` — calls `f` exactly once. Pass it a `move` closure that captures and consumes an owned `String` it built locally (e.g., returns it after appending something), and prove the closure genuinely cannot be called a second time (a comment explaining why is enough — you don't need to intentionally trigger the compile error, though trying it once is a good exercise).

## Exercise 06 — Generic, Trait-Bounded Inventory (Advanced)

**Lessons used:** OOP (11), Generics (13), Functional Concepts (12)

Define `trait Priced { fn price(&self) -> f64; }` and a struct `Item { name: String, price: f64 }` implementing it. Write two generic functions:

- `fn total_value<T: Priced>(items: &[T]) -> f64` — sums `.price()` across a slice of any `Priced` type, using iterator adapters (`.iter().map(...).sum()`), not a manual loop.
- `fn filter_items<T: Priced + Clone>(items: &[T], predicate: impl Fn(&T) -> bool) -> Vec<T>` — returns a new, cloned `Vec<T>` of only the items matching a caller-supplied closure predicate.

Build a `Vec<Item>` of at least 5 items with varied prices, compute `total_value`, then call `filter_items` twice with two *different* inline closures (e.g. "price over $50" and "name contains a certain substring") to prove the same generic function works with arbitrary caller logic.

## Exercise 07 — Capstone: Bank Account With `Result`, a Custom Error, and Closures (Advanced)

**Lessons used:** Error Handling (09), Functional Concepts (12), OOP (11)

Build a small `Account` struct (`balance: f64`, `history: Vec<String>`) with:

- `fn deposit(&mut self, amount: f64) -> Result<(), AccountError>` and `fn withdraw(&mut self, amount: f64) -> Result<(), AccountError>`, both rejecting non-positive amounts and `withdraw` additionally rejecting an amount greater than the current balance — a custom `AccountError` enum (`InvalidAmount(f64)`, `InsufficientFunds { requested: f64, available: f64 }`) implementing `Display`/`Error`, exactly like Exercise 02's pattern.
- Every successful operation appends a formatted line to `history` (e.g. `"deposit +50.00 -> balance 150.00"`).
- `fn run_transactions(&mut self, ops: &[(&str, f64)]) -> Result<(), AccountError>` that applies a sequence of `("deposit"/"withdraw", amount)` pairs using `?` to propagate the *first* failure immediately (later operations in the slice must not run once one fails).
- A closure-based reporting function `fn total_by<F: Fn(&str) -> bool>(&self, predicate: F) -> usize` that returns how many `history` entries satisfy a caller-supplied `Fn(&str) -> bool` predicate over each entry's text (e.g. count how many contain `"deposit"`).

Demonstrate: a successful sequence of transactions, a sequence that fails partway through (confirm via `history.len()` and the account's `balance` that later operations genuinely did not run), and two different `total_by` closures counting deposits vs. withdrawals.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
