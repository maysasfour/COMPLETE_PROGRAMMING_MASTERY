# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write unit tests with the built-in `#[test]` attribute and run them with `cargo test` — no external test framework needed at all, unlike Java (JUnit) or C++ (Catch2/GoogleTest).
- Understand `#[cfg(test)]`, which compiles a test module only during `cargo test`, never `cargo build`/`cargo run`.
- Distinguish inline unit tests (`src/lib.rs`, access to private items) from integration tests (`tests/`, public-API-only, each file its own crate).
- Use `#[should_panic]` to assert a panic happens, and a `Result`-returning test to propagate failure via `?`.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

Rust ships testing support directly in the toolchain: `#[test]` marks a function as a test case, and `cargo test` compiles and runs all of them — genuinely comparable to Go's built-in `testing` package (Lesson 18 of that course), and a step beyond Java/C++/JavaScript, which all require pulling in an external framework (JUnit, Catch2/GoogleTest, Jest/Mocha) for the same job.

## `#[test]` and `#[cfg(test)]`

```rust
pub fn add(a: i32, b: i32) -> i32 { a + b }

#[cfg(test)] // compiled only when running `cargo test`
mod tests {
    use super::*; // brings the outer module's items (including private ones) into scope

    #[test]
    fn add_positive_numbers() {
        assert_eq!(add(2, 3), 5);
    }
}
```

`assert_eq!`, `assert!`, and `assert_ne!` are the core assertion macros; a failing assertion panics, and `cargo test` reports the panic as a test failure with the exact values that didn't match.

## Table-Driven Tests

```rust
#[test]
fn divide_table_driven() {
    let cases: [(f64, f64, f64); 3] = [(10.0, 2.0, 5.0), (9.0, 3.0, 3.0), (-6.0, 2.0, -3.0)];
    for (a, b, expected) in cases {
        assert_eq!(divide(a, b).unwrap(), expected, "divide({}, {}) failed", a, b);
    }
}
```

Rust has no built-in "table test" construct (unlike Go's idiomatic `[]struct{...}` + `t.Run` subtests) — the same effect is achieved with a plain array of tuples and a `for` loop, with `assert_eq!`'s optional format-string argument supplying a useful failure message per case.

## `#[should_panic]` and `Result`-Returning Tests

```rust
#[test]
#[should_panic(expected = "index out of bounds")]
fn indexing_past_the_end_panics() {
    let v = vec![1, 2, 3];
    let _ = v[10]; // panics -- this test PASSES because the panic was expected
}

#[test]
fn divide_using_question_mark() -> Result<(), String> {
    let result = divide(10.0, 5.0)?; // `?` propagates an Err as a test failure directly
    assert_eq!(result, 2.0);
    Ok(())
}
```

A test returning `Result<(), E>` fails if it returns `Err`, letting `?` work naturally inside test bodies instead of `.unwrap()`-ing and panicking on every fallible call.

## Unit Tests vs. Integration Tests

```rust
// tests/integration_test.rs -- its own separate crate, linked against the PUBLIC API only
use testingdemo::{add, divide, is_palindrome};

#[test]
fn integration_add_and_divide() {
    let sum = add(4, 6);
    assert_eq!(divide(sum as f64, 2.0).unwrap(), 5.0);
}
```

Any file directly under a `tests/` directory is compiled as an independent crate that can only see this crate's `pub` items — genuinely enforcing a black-box perspective, unlike the inline `#[cfg(test)] mod tests` in `src/lib.rs`, which sees private items too via `use super::*`.

## Detailed Example

See [Cargo.toml](Cargo.toml), [src/lib.rs](src/lib.rs) (8 inline unit tests covering `add`, `divide`, `is_palindrome`, and a `Fraction::simplify` method, including a table-driven case, a `#[should_panic]` case, and a `Result`-returning case), and [tests/integration_test.rs](tests/integration_test.rs) (2 black-box integration tests).

## Run It

```bash
cd 01-Languages/Rust/18-Testing
cargo test
```

## Expected Output

Running `cargo test` compiles and runs all 8 inline unit tests (from `src/lib.rs`) followed by all 2 integration tests (from `tests/integration_test.rs`) as separate test binaries, plus a "Doc-tests" pass (0 tests here, since no doc comments contain runnable `assert!` examples in this lesson) — verified: `test result: ok. 8 passed; 0 failed` for unit tests and `test result: ok. 2 passed; 0 failed` for integration tests.

## Common Mistakes

- Forgetting `#[cfg(test)]` on the test module — without it, the test module (and its `#[test]` functions) would still compile into `cargo build`/`cargo run` binaries unnecessarily.
- Assuming `tests/*.rs` files can access private items the way `src/lib.rs`'s inline `mod tests` can — they can't; only `pub` items are visible, since each file under `tests/` is its own separate crate.
- Writing an assertion with no custom message on a table-driven test — when one case out of many fails, a generic `assertion failed` message doesn't say *which* case, unlike `assert_eq!(result, expected, "divide({}, {}) failed", a, b)`.

## Best Practices

- Use inline `#[cfg(test)] mod tests` for tests that need access to private implementation details; use `tests/` for black-box tests that should only ever exercise the public API.
- Prefer a `Result`-returning test with `?` over chains of `.unwrap()` when a test naturally involves several fallible steps.
- Always include a descriptive message argument in `assert_eq!`/`assert!` for any test that loops over multiple cases.

## Real-World Usage

`cargo test` is the standard for every Rust project (crates.io libraries, CLI tools, servers alike); CI pipelines run it directly with no separate test-runner installation step, and `tests/` integration suites are the idiomatic way to test a crate's public API the way an external consumer actually would.

## Summary

- `#[test]` + `cargo test` are built into the Rust toolchain — no external test framework dependency, matching Go and contrasting with Java/C++/JavaScript.
- `#[cfg(test)]` excludes test code from non-test builds entirely.
- Inline `mod tests` (private-item access) and `tests/` directory files (public-API-only, separate crates) serve genuinely different testing purposes.
- `#[should_panic]` and `Result`-returning tests cover two additional testing styles beyond plain `assert!`/`assert_eq!`.

## Key Terms

- **`#[test]`** — marks a function as a test case, run by `cargo test`.
- **`#[cfg(test)]`** — conditionally compiles code only during test builds.
- **Integration test** — a file under `tests/`, compiled as its own crate with access to only the public API.

## Interview Questions

1. **What is the difference between a unit test in `src/lib.rs` and an integration test in `tests/`?**
   A unit test lives inline (typically in a `#[cfg(test)] mod tests` block) and, via `use super::*`, can access private items in the same module — appropriate for testing internal implementation details. An integration test is any file directly under the `tests/` directory; each such file is compiled as its own separate crate and can only use the crate's `pub` items, exactly as an external consumer of the library would, making it a genuine black-box test.

2. **Why does `#[cfg(test)]` matter, and what would happen without it?**
   `#[cfg(test)]` tells the compiler to include the annotated module only when compiling for `cargo test`. Without it, test code (and any test-only dependencies it uses) would also be compiled into regular `cargo build`/`cargo run` binaries, unnecessarily bloating production builds with code that only exists to verify correctness during development.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
