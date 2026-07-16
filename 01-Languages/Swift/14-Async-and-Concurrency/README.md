# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Understand Swift's `async`/`await` is built directly into the language (since Swift 5.5) — a genuine, positive contrast with Kotlin (needs the separate `kotlinx.coroutines` library) and Rust (needs the separate `tokio` crate), both covered earlier in this repository.
- Use `async let` for structured concurrency, directly comparable to Kotlin's `async`/`await` pattern.
- Use `actor` — Swift's compiler-enforced, data-race-free concurrency primitive, a stronger guarantee than Rust's `Arc<Mutex<T>>` or Kotlin's manual `Mutex` discipline.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

Unlike Kotlin (`kotlinx.coroutines` is a separate library providing the actual dispatcher/scheduler) and Rust (`async`/`await` syntax exists in the language, but a runtime crate like `tokio` is needed to actually execute anything), Swift's concurrency model — `async`/`await`, structured concurrency, and `actor` — is fully built into the language and its standard library since Swift 5.5, with no external dependency required at all.

## `async` Functions and `await`

```swift
func fetchValue(id: Int, delayMs: UInt64) async -> Int {
    try? await Task.sleep(nanoseconds: delayMs * 1_000_000) // suspends without blocking a thread
    return id * 10
}

let a = await fetchValue(id: 1, delayMs: 200)
let b = await fetchValue(id: 2, delayMs: 200)
// sequential -- b doesn't start until a's await completes
```

## Structured Concurrency: `async let`

```swift
async let deferredA = fetchValue(id: 1, delayMs: 200) // starts immediately
async let deferredB = fetchValue(id: 2, delayMs: 200) // runs alongside deferredA
let (a, b) = await (deferredA, deferredB) // suspends until BOTH finish
```

`async let` is directly comparable to Kotlin's `async { }`/`.await()` pattern (covered in this repository's Kotlin course) — both `deferredA` and `deferredB` begin executing immediately and concurrently, with the `await` only needed when their results are actually required, producing roughly half the total time of the sequential version for two equally-delayed operations.

## `actor`: Compiler-Enforced, Data-Race-Free Mutable State

```swift
actor BankAccount {
    private var balance: Double = 0
    func deposit(_ amount: Double) { balance += amount } // safe -- only one task executes at a time
    func getBalance() -> Double { return balance }
}

let account = BankAccount()
await account.deposit(100) // `await` required for EVERY external access to actor state
```

An `actor` is similar to a `class` (Lesson 11) in that it's a reference type, but the Swift compiler enforces that its mutable state can **only** be accessed from outside the actor via `await` — calls are automatically serialized, one at a time, eliminating data races on the actor's own state entirely, checked at compile time. This is a genuinely stronger, more automatic guarantee than Rust's `Arc<Mutex<T>>` (covered earlier in this repository, which still requires the programmer to remember to lock the mutex correctly every time) or Kotlin's manual `Mutex`-based discipline — with `actor`, the compiler itself refuses to compile code that accesses actor state without the required `await`, making a whole class of concurrency bugs a compile-time error rather than a runtime race condition.

## Detailed Example

See [Example.swift](Example.swift) — sequential vs. concurrent `async`/`await` calls with timing comparison via `async let`, and an `actor`-based bank account demonstrating serialized, safe concurrent access.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print `a=10, b=20` for both the sequential and concurrent runs, with the sequential run's measured time roughly double the concurrent run's time (analogous to the real, measured Kotlin coroutine timing in this repository's Kotlin course), and `actor balance after two deposits: 150.0`.

## Common Mistakes

- Forgetting `await` is required for every access to an actor's state from outside the actor — this is a compile error, not something the programmer can accidentally skip and introduce a race condition at runtime, a genuine strength over Rust's `Mutex` (where forgetting to lock at all is possible, if a raw pointer/unsafe path is used) or Kotlin's manual synchronization.
- Using `await fetchValue(); await fetchValue();` sequentially when concurrency was intended — `async let` (or Kotlin's separately-issued `async { }` calls) must be used to actually start operations concurrently; plain sequential `await` calls always run one after another.
- Assuming `actor` and `class` are interchangeable — `actor` adds mandatory, compiler-enforced serialization for its own state; `class` provides no such protection at all, matching Kotlin/Java's classes.

## Best Practices

- Use `async let` (or `TaskGroup` for a dynamic number of concurrent operations) whenever multiple independent asynchronous operations can run concurrently.
- Use `actor` for any reference type holding mutable state that might be accessed from multiple concurrent tasks — it's Swift's idiomatic, compiler-enforced alternative to manual locking.
- Prefer Swift's native `async`/`await` over older callback-based or Combine-based asynchronous patterns in new Swift code, since it's now the modern, language-native standard.

## Real-World Usage

Swift's `async`/`await` and `actor` model, being native to the language with no external dependency, is now the standard approach for asynchronous and concurrent code in modern Swift/iOS development, replacing older patterns like completion-handler callbacks and GCD (Grand Central Dispatch) queues for most new code — Apple's own frameworks (URLSession, covered in Lesson 17) provide native `async`/`await` APIs directly.

## Summary

- Swift's `async`/`await` is built into the language and standard library since Swift 5.5 — no external library needed, a genuine, positive contrast with Kotlin's `kotlinx.coroutines` and Rust's `tokio`, both covered earlier in this repository.
- `async let` provides structured concurrency, directly comparable to Kotlin's `async`/`.await()` pattern.
- `actor` provides compiler-enforced, data-race-free mutable state — a stronger guarantee than Rust's `Arc<Mutex<T>>` or Kotlin's manual `Mutex` discipline, since the compiler itself refuses to compile unprotected access.

## Key Terms

- **`actor`** — a Swift reference type whose mutable state can only be accessed via `await` from outside, with the compiler enforcing serialized, data-race-free access.
- **`async let`** — declares a concurrently-starting asynchronous operation, awaited later when its result is needed.

## Interview Questions

1. **Why is Swift's concurrency model considered a genuine advantage compared to Kotlin's or Rust's, both covered earlier in this repository?**
   Kotlin's coroutines require a separate library (`kotlinx.coroutines`) providing the actual dispatcher/scheduler — the `suspend` keyword is a language feature, but nothing runs without that library. Rust's `async`/`await` syntax is built into the language, but similarly needs an external runtime crate (like `tokio`) to actually execute anything. Swift's `async`/`await`, structured concurrency (`async let`, `TaskGroup`), and `actor` model are all built directly into the language and its standard library since Swift 5.5 — no external dependency is needed at all for any of it, a genuinely more batteries-included concurrency story than either of the other two languages.

2. **How does an `actor` provide a stronger concurrency safety guarantee than Rust's `Arc<Mutex<T>>`?**
   Rust's `Arc<Mutex<T>>` (covered earlier in this repository) requires the programmer to remember to call `.lock()` correctly every time the shared data is accessed — the type system encourages this but doesn't strictly forbid all forms of incorrect access (particularly if `unsafe` code is involved). Swift's `actor`, by contrast, makes the compiler itself enforce that any access to the actor's state from outside the actor must go through `await`, which automatically serializes access — there is no way to write code that accesses actor state unprotected and have it compile at all, making the safety guarantee a hard, structural compile-time property rather than a discipline the programmer must maintain correctly on their own.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
