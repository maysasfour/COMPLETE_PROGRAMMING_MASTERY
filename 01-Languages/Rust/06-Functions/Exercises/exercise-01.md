# Exercise 01 — A `capitalize_first` Function Using Mutable Borrowing

[Back to lesson](../README.md)

## Task

Write `fn capitalize_first(s: &mut String)` that capitalizes the first character of `s` in place (mutating the caller's `String` directly, returning nothing). Then write `fn shout(s: &str) -> String` that returns a new, all-uppercase `String` **without** taking ownership of `s` (so the caller's original string is still usable afterward).

## Constraints

- `capitalize_first` must take `&mut String` and mutate in place — no return value.
- `shout` must take `&str` (not `String`) and return a brand-new owned `String`, leaving the caller's original untouched.

## Starter Code

```rust
fn capitalize_first(s: &mut String) {
    // your logic here
}

fn shout(s: &str) -> String {
    // your logic here
}

fn main() {
    let mut name = String::from("ada");
    capitalize_first(&mut name);
    println!("{}", name);

    let original = String::from("hello");
    let shouted = shout(&original);
    println!("{} / {}", original, shouted);
}
```

## Expected Output

```
Ada
hello / HELLO
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/main.rs](../Solutions/main.rs).
