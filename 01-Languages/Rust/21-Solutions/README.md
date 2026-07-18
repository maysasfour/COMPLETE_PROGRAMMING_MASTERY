# 21 — Solutions

[Back to course overview](../README.md) | [Exercises](../20-Exercises/README.md)

Runnable solutions for every problem in [20-Exercises](../20-Exercises/README.md). Each `solution-0N.rs` matches Exercise N and is a single-file program — compile it with `rustc solution-0N.rs -o solution-0N` and run the resulting binary directly, no `Cargo.toml` needed, matching the single-file-lesson pattern used throughout Lessons 01–15/19. All seven have been actually compiled and executed against real Rust 1.97.1 stable (`rustc --version` &rarr; `rustc 1.97.1 (8bab26f4f 2026-07-14)`) — the "Verified output" blocks below are pasted straight from the terminal, not predicted. Both files that initially produced compiler warnings (`solution-02.rs`'s "fields never read" and `solution-07.rs`'s panic-message formatting lint) were fixed and recompiled clean — see "Bugs and Gotchas Found" at the bottom.

## Solution 01 — Lifetimes and Borrowing

```
Longest word: extraordinarily (len 15)
Original text still usable: the quick brown fox jumps over extraordinarily
Total chars across 3 words: 14
Words vec still owned by caller: ["hello", "world", "rust"]
```

`longest_word`'s explicit lifetime `'a` on both the input and the return type tells the compiler "the returned slice borrows from `text` and cannot outlive it" — a compile-time-checked promise with zero runtime tracking, unlike a garbage-collected language where an equivalent "view" object needs the GC to keep the original alive. `total_chars` borrowing `&[String]` rather than taking `Vec<String>` by value is why `words` is still fully owned and printable in `main` after the call — nothing was moved.

## Solution 02 — Custom Error Enum and the `?` Operator

```
Parsed OK: name=worker-1, retries=3, timeout_ms=5000
Expected error (missing field): missing required field: retries
Expected error (invalid number): field 'retries' is not a valid number: invalid digit found in string
```

`get_field` centralizes the "look up a key, or fail with `MissingField`" logic so `parse_config` can use `?` three times instead of writing the same `match` per field. The `InvalidNumber` variant's `.parse().map_err(...)` pattern (rather than a bare `?` relying on a `From<ParseIntError>` impl) is deliberate — it keeps the *field name* attached to the error message, information a generic `From`-based conversion would lose. `std::error::Error::source()` correctly returns `Some(&source)` only for `InvalidNumber`, wiring this custom error into the standard error-chain convention.

## Solution 03 — Traits With Default Methods

```
Ada: base=90000.00, multiplier=1.00, total_pay=90000.00
Grace: base=110000.00, multiplier=1.20, total_pay=132000.00
```

`total_pay()` is never redefined for `Manager` — only `bonus_multiplier()` is overridden (`1.0` &rarr; `1.2`) — yet `Manager`'s `total_pay()` correctly reflects the override, because the *default* `total_pay()` implementation calls `self.bonus_multiplier()` dynamically through the trait, not a hardcoded `1.0`. This is the concrete payoff of default methods: override exactly the piece that differs, and every default method built on top of it stays correct automatically.

## Solution 04 — Generics and Monomorphization

```
max(ints)   = Some(9)
max(floats) = Some(9.25)
max(chars)  = Some('z')
max(empty)  = None
Pair<i32>::larger()  = 42
Pair<f64>::larger()  = 3.14
```

Calling `find_max` with `&[i32]`, `&[f64]`, and `&[char]` causes rustc to generate three separate, fully concrete compiled functions (`find_max::<i32>`, `find_max::<f64>`, `find_max::<char>`) at compile time — this is monomorphization. There is no single shared, type-erased function surviving into the binary the way Java's generics work (one erased method, runtime casts inserted by the compiler at each use), and no vtable-indirection layer either; each monomorphized copy is ordinary, directly-callable, fully-optimized machine code specific to its one concrete type. The tradeoff, as Lesson 13 covers, is binary size and compile time scaling with the number of distinct types instantiated, in exchange for zero runtime dispatch overhead.

## Solution 05 — Closures: `Fn`, `FnMut`, and `FnOnce`

```
apply(square, 6) = 36
run_n_times(increment, 5) = [1, 2, 3, 4, 5]
consume(build_greeting) = Hello, Rust!
```

`increment` genuinely mutates `count` across five separate calls (`[1, 2, 3, 4, 5]`, not five `1`s) because `run_n_times` takes it as `FnMut` and calls it repeatedly through a `&mut` reference to the same closure state — this is the concrete difference from `Fn`, which only ever gets a shared reference and could never compile against a body that mutates a capture. `build_greeting` is a `move` closure: `greeting` (an owned `String`) is moved *into* the closure at construction, and the closure body itself consumes it (`greeting + ", Rust!"` moves the left-hand `String`) — so the closure can only ever be called once, which is exactly what the `FnOnce` bound in `consume`'s signature requires and permits.

## Solution 06 — Generic, Trait-Bounded Inventory

```
Total value of 5 items: 700.00
Items over $50.00:
  Monitor ($220.00)
  Webcam ($60.00)
  Standing Desk ($350.00)
Items with 'Desk' in the name:
  Standing Desk ($350.00)
```

`total_value<T: Priced>` and `filter_items<T: Priced + Clone>` are both written against the `Priced` trait bound, not the concrete `Item` type — a second, unrelated struct implementing `Priced` could reuse both functions unchanged. `filter_items`'s `predicate: impl Fn(&T) -> bool` parameter is what lets the exact same generic function answer two structurally different questions ("price over $50", "name contains a substring") purely by passing a different closure at the call site — the generic function's logic (iterate, test, clone matches) never changes.

## Solution 07 — Capstone: Bank Account With `Result`, a Custom Error, and Closures

```
Transactions succeeded. Balance: 120.00
  deposit +100.00 -> balance 100.00
  deposit +50.00 -> balance 150.00
  withdraw -30.00 -> balance 120.00
Expected failure partway through: insufficient funds: requested 1000.00, available 40.00
acct2 after partial failure: balance=40.00, history.len()=1 (proves the trailing deposit never ran)
acct: 2 deposit(s), 1 withdrawal(s)
```

`run_transactions`'s `?` inside the loop stops iteration the instant `withdraw(1000.0)` returns `Err(InsufficientFunds { .. })` — the third operation (`deposit 999.0`) genuinely never executes, confirmed directly by `acct2.history.len()` staying at `1` (only the successful `deposit 40.0` logged) and `acct2.balance` staying at `40.00`, not partially reflecting the failed withdrawal or the never-attempted deposit. `total_by`'s two calls (`starts_with("deposit")` vs. `starts_with("withdraw")`) prove the same closure-accepting method answers two different questions with zero changes to `total_by` itself — the same pattern as Solution 06's `filter_items`, applied to counting instead of filtering.

## Bugs and Gotchas Found While Verifying

- **`solution-02.rs` initially triggered a `dead_code` warning** ("fields `name`, `retries`, and `timeout_ms` are never read") on the `Config` struct, even though the success case printed it via `{cfg:?}` (derived `Debug`). Rust's dead-code analysis deliberately does **not** count a derived `Debug` impl's use of a field as a "real" read — only direct field access does. Fixed by printing `cfg.name`, `cfg.retries`, `cfg.timeout_ms` explicitly in the success branch instead of relying solely on `{cfg:?}`, which both silenced the warning and produced a more informative success message.
- **`solution-07.rs` initially triggered two lints** on `panic!("unknown transaction kind in test data: {other}")` — Rust 2021's `non_fmt_panics` check flags a single-string-literal `panic!` argument containing what *looks* like a `format!`-style `{other}` placeholder, since bare `panic!("literal")` does not interpolate at all (only `format!`/`println!`-family macros do). Fixed by passing `other` as a real formatting argument: `panic!("unknown transaction kind in test data: {}", other)`.
- Both fixes were applied and the files recompiled with zero warnings before being marked verified — the exercise/solution pair for 02 and 07 in this README reflects the corrected code, not the original draft.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
