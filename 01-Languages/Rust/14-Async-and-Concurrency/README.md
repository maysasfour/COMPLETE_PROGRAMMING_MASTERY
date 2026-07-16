# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Use `std::thread::spawn` for OS threads, with ownership rules preventing data races **at compile time**.
- Use `Arc<Mutex<T>>` for safely sharing mutable state across threads.
- Understand `async`/`await` exists in Rust but requires a separate runtime crate (unlike Go's built-in goroutines).

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

This is Rust's other headline feature, alongside ownership itself: the same ownership/borrowing rules from Lesson 03 apply to data shared across threads, and the compiler **refuses to compile** code with a potential data race — not just detects it at runtime (like Go's `-race` flag) or leaves it to programmer discipline (like C++'s `std::mutex`, which is easy to forget). "Fearless concurrency" is Rust's own marketing term for this: if it compiles, it's provably free of data races.

## `std::thread::spawn`

```rust
use std::thread;

let handle = thread::spawn(|| {
    println!("Hello from a thread");
});
handle.join().unwrap(); // wait for the thread to finish
```

## Sharing Data Across Threads: `Arc<Mutex<T>>`

```rust
use std::sync::{Arc, Mutex};
use std::thread;

let counter = Arc::new(Mutex::new(0)); // Arc: thread-safe shared ownership; Mutex: safe mutable access
let mut handles = vec![];

for _ in 0..10 {
    let counter = Arc::clone(&counter); // clones the Arc (cheap, reference-counted), not the inner data
    let handle = thread::spawn(move || {
        let mut num = counter.lock().unwrap(); // .lock() blocks until available, returns a guard
        *num += 1;
    }); // the lock guard is released automatically here (RAII, like C++'s std::lock_guard)
    handles.push(handle);
}

for handle in handles {
    handle.join().unwrap();
}
println!("Result: {}", *counter.lock().unwrap()); // reliably 10 -- compiler-enforced, not just tested
```

`Arc<T>` ("Atomically Reference Counted") is thread-safe shared ownership — like `Rc<T>` but safe to clone across threads. `Mutex<T>` wraps a value, requiring `.lock()` to access it — the returned guard implements Rust's RAII pattern, automatically releasing the lock when it goes out of scope, and critically, **the compiler will not let you access the inner value without going through `.lock()` at all** — unlike C++'s `std::mutex`, which merely *conventionally* protects an associated variable with no enforced connection between them.

## `async`/`await` (Requires an External Runtime)

```rust
// Requires the `tokio` crate (or similar) -- async/await syntax is in the language,
// but Rust's standard library deliberately ships NO async runtime/executor.
async fn fetch_data() -> String {
    // ...
    "data".to_string()
}
```

Unlike Go (goroutines are fully built into the runtime) or JavaScript/C#/Java (a runtime/executor is built in or trivially available), Rust's `async`/`await` **syntax** is part of the language, but there is deliberately **no built-in async runtime/executor** in `std` — you must add a crate like `tokio` or `async-std` to actually run async code. This course's example focuses on threads (fully usable with zero dependencies) rather than `async`/`await`, to stay consistent with this course's dependency-minimal lesson style; a real async Rust project would add `tokio` (Cargo.toml dependency) as a near-universal choice.

## Detailed Example

See [main.rs](main.rs) — includes real elapsed-time measurement, and the `Arc<Mutex<T>>` pattern producing a reliably correct count across 10 concurrent threads.

## Expected Output

Compiling and running `main.rs` prints a basic spawned thread's output, real timing showing concurrent threads completing faster than sequential calls, and an `Arc<Mutex<T>>`-protected counter reliably reaching exactly 10 after 10 concurrent increments.

## Common Mistakes

- Trying to share a plain (non-`Arc`) reference across threads — the compiler will reject it, since a plain reference's lifetime can't be statically proven to outlive all the threads using it; `Arc` (or ensuring threads are joined before the data goes out of scope) is required.
- Forgetting `Mutex::lock()` returns a `Result` (it can fail if the mutex was "poisoned" by a panic in another thread while holding the lock) — `.unwrap()` is common in simple examples but a real project should consider handling poisoning explicitly.
- Assuming `async`/`await` works with zero dependencies, the way Go's goroutines do — Rust's standard library provides the syntax but no runtime to actually execute it.

## Best Practices

- Use `Arc<Mutex<T>>` (or channels, `std::sync::mpsc`, for message-passing instead of shared state) for safely sharing data across threads.
- Always `.join()` spawned threads (or otherwise ensure they complete) before the program/scope that spawned them ends.
- Choose `tokio` (the most widely adopted async runtime) for real async Rust projects, understanding it's a deliberate, separate dependency, not a std feature.

## Real-World Usage

"Fearless concurrency" — compile-time-enforced absence of data races — is one of Rust's most distinctive, most-cited advantages over C++ specifically, since C++'s `std::mutex` provides no compiler-enforced connection to the data it's meant to protect, while Rust's `Mutex<T>` makes accessing the inner value without locking a compile-time impossibility.

## Summary

- `std::thread::spawn` provides genuine OS threads; the ownership/borrowing rules from Lesson 03 apply across threads too, making data races a compile-time error, not just a runtime risk.
- `Arc<Mutex<T>>` is the standard pattern for sharing mutable state safely across threads — `Arc` for shared ownership, `Mutex` for safe, compiler-enforced access.
- `async`/`await` syntax exists in Rust, but the standard library ships no runtime — an external crate (`tokio`) is required to actually run async code.

## Key Terms

- **Fearless concurrency** — Rust's marketing term for compile-time-enforced absence of data races, verified by the same ownership/borrowing rules that apply to all Rust code.
- **`Arc<T>`** — thread-safe, atomically reference-counted shared ownership.
- **`Mutex<T>`** — a mutual-exclusion wrapper where accessing the inner value requires `.lock()`, enforced by the type system, not just convention.

## Interview Questions

1. **What does "fearless concurrency" mean in the context of Rust?**
   It refers to Rust's ability to catch data races at **compile time**, via the same ownership and borrowing rules that apply to all Rust code — not just single-threaded code. If code compiles and shares data across threads, the compiler has proven no data race is possible; this contrasts with Go (which can only detect races at runtime, via `-race`) and C++ (where `std::mutex` protects data only by convention, with no compiler-enforced link between the lock and the data it guards).

2. **What is `Arc<Mutex<T>>`, and why are both parts needed?**
   `Arc<T>` provides thread-safe shared ownership (multiple threads can hold a reference to the same data, with reference counting managing its lifetime) — but `Arc` alone only allows shared *immutable* access. `Mutex<T>` adds safe *mutable* access by requiring `.lock()` before touching the inner value, with the compiler enforcing that no code can bypass the lock. Combined, `Arc<Mutex<T>>` lets multiple threads safely share and mutate the same underlying data, with both the sharing and the mutation-safety compiler-enforced.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
