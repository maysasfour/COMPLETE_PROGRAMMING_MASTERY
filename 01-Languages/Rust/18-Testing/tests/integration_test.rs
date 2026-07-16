// Any file directly under tests/ is compiled as its OWN separate crate that links against
// this crate's public API only (private items are inaccessible here) -- unlike the inline
// `#[cfg(test)] mod tests` in src/lib.rs, which has access to private items via `use super::*`.
// This is Rust's built-in equivalent of a black-box integration test suite.

use testingdemo::{add, divide, is_palindrome};

#[test]
fn integration_add_and_divide() {
    let sum = add(4, 6);
    let quotient = divide(sum as f64, 2.0).unwrap();
    assert_eq!(quotient, 5.0);
}

#[test]
fn integration_palindrome() {
    assert!(is_palindrome("Was it a car or a cat I saw"));
}
