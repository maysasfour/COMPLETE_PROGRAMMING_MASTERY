# Exercise 01 — FizzBuzz with an Exhaustive Match

[Back to lesson](../README.md)

## Task

Write a function `fn fizzbuzz(n: u32) -> String` returning `"FizzBuzz"` for multiples of 15, `"Fizz"` for multiples of 3, `"Buzz"` for multiples of 5, and the number itself (via `n.to_string()`) otherwise, using a `match` on `(n % 3, n % 5)` as a tuple pattern. Print results for 1 through 15 using a `for` loop over an inclusive range.

## Constraints

- Must use a `match` on the tuple `(n % 3, n % 5)`, matching `(0, 0)`, `(0, _)`, `(_, 0)`, and a catch-all.
- Use `1..=15` (inclusive range) in the `for` loop.

## Starter Code

```rust
fn fizzbuzz(n: u32) -> String {
    match (n % 3, n % 5) {
        // your patterns here
    }
}

fn main() {
    for i in 1..=15 {
        println!("{}", fizzbuzz(i));
    }
}
```

## Expected Output

```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/main.rs](../Solutions/main.rs).
