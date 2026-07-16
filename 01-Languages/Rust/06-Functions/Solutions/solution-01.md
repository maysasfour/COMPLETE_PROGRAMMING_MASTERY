# Solution 01 — A `capitalize_first` Function Using Mutable Borrowing

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `capitalize_first` takes `&mut String`, so it can reassign `*s` (dereferencing the mutable reference and assigning a new value into the caller's actual `String`) — this is genuinely in-place mutation, not returning a new value the caller has to reassign themselves.
- `first.len_utf8()` (rather than just `1`) correctly handles the byte-length of the first character, connecting back to the Go course's byte-vs-character distinction — Rust strings are UTF-8 too, and slicing by a hardcoded `1` would panic (or corrupt data) for a multi-byte first character.
- `shout` takes `&str` (an immutable borrow, accepting both `String`s and literals) and returns a brand-new `String` via `.to_uppercase()` — `original` is never touched, confirmed by printing both afterward.

## Verification

Ran with `rustc main.rs -o main.exe && ./main.exe`; actual output:

```
Ada
hello / HELLO
```

Matches the exercise's expected output exactly — `capitalize_first` genuinely mutated `name` in place, and `shout` left `original` completely untouched while returning a new uppercased string.
