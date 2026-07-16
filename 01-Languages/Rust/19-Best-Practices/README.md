# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Recognize and fix three genuine Rust anti-patterns: needless `.clone()` to dodge the borrow checker, `.unwrap()` on fallible operations instead of propagating errors, and repeated `+` string concatenation in a loop.
- Use the `HashMap` `entry()` API idiomatically instead of a `contains_key`-then-`insert` pair.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept

This lesson is a synthesis, not a new topic: it takes three mistakes that are common when learning Rust — mistakes that *compile and run* but are non-idiomatic or wasteful — and rewrites each one, verifying that the "bad" and "good" versions produce **identical output**, so the fix is understood as a quality/performance improvement, not a behavior change.

## Anti-Pattern 1: Needless `.clone()` Instead of Borrowing

```rust
fn total_len_bad(words: Vec<String>) -> usize {
    let mut total = 0;
    for w in words.clone() { total += w.len(); } // clones the WHOLE Vec<String> just to iterate
    total
}

fn total_len_good(words: &[String]) -> usize {
    words.iter().map(|w| w.len()).sum() // borrows; no clone, no ownership taken at all
}
```

New Rust programmers often reach for `.clone()` the moment the borrow checker complains, rather than reconsidering whether the function needs ownership at all. Taking `&[String]` (a borrowed slice) instead of `Vec<String>` (owned) sidesteps the problem entirely — no clone, no ownership transfer, and the caller keeps using `words` afterward.

## Anti-Pattern 2: `.unwrap()` Instead of Propagating the Error

```rust
fn parse_and_double_bad(input: &str) -> i32 {
    let n: i32 = input.parse().unwrap(); // panics the whole program on bad input
    n * 2
}

fn parse_and_double_good(input: &str) -> Result<i32, std::num::ParseIntError> {
    let n: i32 = input.parse()?; // propagates a proper error to the caller instead
    Ok(n * 2)
}
```

`.unwrap()` is convenient for throwaway scripts and tests (Lesson 18 used it deliberately in test bodies), but in library or application code it turns any bad input into an unrecoverable panic. Returning `Result<T, E>` and using `?` (Lesson 09) lets the caller decide how to handle the failure — log it, retry, show a message — instead of crashing.

## Anti-Pattern 3: Repeated String Concatenation in a Loop

```rust
fn build_report_bad(items: &[(&str, i32)]) -> String {
    let mut report = String::new();
    for (name, count) in items {
        report = report + name + ": " + &count.to_string() + "\n"; // reallocates every iteration
    }
    report
}

fn build_report_good(items: &[(&str, i32)]) -> String {
    let mut report = String::with_capacity(items.len() * 16); // one allocation up front
    for (name, count) in items {
        report.push_str(name);
        report.push_str(": ");
        report.push_str(&count.to_string());
        report.push('\n');
    }
    report
}
```

Each `+` on a `String` allocates a new buffer for the concatenated result — inside a loop, this means one reallocation per iteration. `String::with_capacity` combined with `push_str` reserves space once and appends in place, producing the exact same output with far fewer allocations for large inputs.

## Bonus: `HashMap` `entry()` API

```rust
let mut counts: HashMap<&str, i32> = HashMap::new();
for (name, _) in &items {
    *counts.entry(name).or_insert(0) += 1; // one lookup, not a contains_key + insert pair
}
```

`entry()` looks up the key once and gives back a handle that can be inserted-if-absent and mutated in a single expression, avoiding the double lookup of checking `contains_key` and then separately calling `insert`/indexing.

## Detailed Example

See [main.rs](main.rs) — all three anti-pattern/fix pairs plus the `HashMap::entry` bonus, with an `assert_eq!` confirming the "bad" and "good" string-building functions produce byte-identical output.

## Run It

```bash
cd 01-Languages/Rust/19-Best-Practices
rustc main.rs -o main
./main
```

## Expected Output

Running the compiled binary prints matching results for the bad/good pairs (`14` both ways for anti-pattern 1's total length), confirms `parse_and_double_good("not a number")` returns a handled `Err` instead of panicking (unlike the `.unwrap()`-based version), prints byte-identical "bad report"/"good report" text (verified via a passing `assert_eq!`), and prints a `HashMap` built via the `entry()` API.

## Common Mistakes

- Reaching for `.clone()` as a first response to any borrow-checker error, rather than checking whether the function actually needs ownership.
- Using `.unwrap()` in code paths that handle real (not test-only) input, hiding exactly which operation might fail in production.
- Building strings with `+` inside a loop instead of `push_str`/`write!`, especially for large numbers of iterations.

## Best Practices

- Take `&T`/`&[T]` parameters by default; only take owned `T`/`Vec<T>` when the function genuinely needs to store or consume the value.
- Reserve `.unwrap()`/`.expect()` for cases where failure is truly a programmer error (an invariant that must hold), and use `?`/proper `match` handling for anything involving external input.
- Use `String::with_capacity` + `push_str` (or the `write!` macro) instead of repeated `+` concatenation in loops.
- Prefer `HashMap::entry()` over a manual `contains_key` + `insert`/index pair.

## Real-World Usage

These three patterns are exactly the kind of feedback a Rust code review commonly gives: "did this need to be cloned?", "should this really panic on bad input?", and "this string-building loop will get slow with large inputs" are genuine, recurring review comments in production Rust codebases.

## Summary

- Borrow (`&T`) instead of cloning by default; only take ownership when a function truly needs it.
- Propagate errors with `Result`/`?` in real code paths; reserve `.unwrap()` for genuine invariants or test code.
- Preallocate and append (`String::with_capacity` + `push_str`) instead of repeated `+` concatenation in loops.
- Use `HashMap::entry()` to avoid double lookups.

## Key Terms

- **Anti-pattern** — a common but non-idiomatic or inefficient way of writing code that still compiles and runs correctly.
- **`entry()` API** — a `HashMap` method returning a handle for insert-or-update-in-place operations with a single lookup.

## Interview Questions

1. **Why is reaching for `.clone()` to fix a borrow-checker error often a code smell in Rust?**
   Because it frequently signals that the function's parameter type is wrong for its actual needs — taking an owned `Vec<String>` when a borrowed `&[String]` would do, for instance. The clone compiles and "fixes" the immediate error, but produces an unnecessary full copy at runtime and often means the original value's ownership was taken unnecessarily. The idiomatic fix is usually to change the parameter type to borrow instead of cloning to satisfy the type as given.

2. **When is `.unwrap()` appropriate in Rust, and when is it not?**
   `.unwrap()` is reasonable when failure represents a genuine programmer error or a truly-impossible-to-fail invariant (e.g., a regex literal known at compile time to be valid, or in test code as seen in Lesson 18, where a panic is the desired failure signal). It's inappropriate for anything involving real, external input — file I/O, network responses, user-provided strings — where failure is a normal, expected outcome that the caller should be able to handle via `Result`/`?` rather than crashing the whole program.

## Recommended Next Lesson

This completes the core Rust course (Lessons 01–19). Return to the [Rust course overview](../README.md) or continue to the next language in the course order.
