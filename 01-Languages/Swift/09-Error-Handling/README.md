# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Use the `Error` protocol, `throws`/`try`, and `do`/`catch`.
- Understand Swift's three distinct "try" flavors: `try` (propagates, needs `do`/`catch`), `try?` (converts to an `Optional`, `nil` on failure), and `try!` (force-try, crashes on failure — like force-unwrap).

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Swift's error handling is a genuinely distinct design from exception-based languages (Kotlin, Java, C#, Python, all covered in this repository): a function that can fail is marked `throws` in its signature (visible at the call site, unlike Java's optional checked-exception declarations), and any error thrown must conform to the `Error` protocol — commonly an `enum` with cases representing distinct failure modes, often carrying associated data. This is conceptually similar to Rust's `Result<T, E>` (covered earlier in this repository) in that failure is visible in the function's signature, but Swift expresses it through `throws`/`try` propagation syntax rather than an explicit `Result`-wrapped return type.

## `Error` Protocol and `throws`/`try`/`do`-`catch`

```swift
enum ValidationError: Error {
    case tooShort(minLength: Int)
    case empty
}

func validate(_ input: String) throws -> String {
    if input.isEmpty { throw ValidationError.empty }
    if input.count < 3 { throw ValidationError.tooShort(minLength: 3) }
    return input
}

do {
    let result = try validate("ok")
    print(result)
} catch ValidationError.empty {
    print("input was empty")
} catch ValidationError.tooShort(let minLength) {
    print("too short, needs at least \(minLength)")
} catch {
    print("unexpected error: \(error)") // a catch-all, must be exhaustive
}
```

Calling a `throws` function requires the `try` keyword at the call site (visible, unlike Java's checked exceptions, which don't require any call-site marker beyond the surrounding `try`/`catch` or `throws` declaration) — this makes it immediately obvious, just from reading a line of code, that it might fail.

## Three `try` Flavors

```swift
try validate(input)    // propagates the error -- must be inside a `do` block or a `throws` function
try? validate(input)   // converts to an Optional -- nil if it threw, the value otherwise
try! validate(input)    // force-try -- CRASHES with a fatal error if it actually throws
```

`try?` is directly comparable to converting a Kotlin/Java exception into a nullable result manually; `try!` is directly comparable to Swift's own force-unwrap (`!`, covered in Lesson 03) applied to error handling — both `try!` and `!` share the same "crash hard if wrong" philosophy, reserved for genuinely provable "this cannot fail here" situations.

## Detailed Example

See [Example.swift](Example.swift) — a custom `Error` enum with associated data, `do`/`catch` with multiple specific catch clauses, and all three `try` flavors demonstrated.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print `validated: ok`, `validated: hello world`, `try? result: validation failed, nil returned` (since `"hi"` is too short), `try! result: this will not throw`, and `too short, needs 5 characters`.

## Common Mistakes

- Forgetting `try` at a throwing function's call site — this is a compile error, not a silently-ignored possibility, unlike Java's unchecked exceptions (which require no call-site marker at all).
- Using `try!` without being certain the call cannot fail at that point — like Swift's force-unwrap (`!`), a wrong assumption crashes the entire program with an unrecoverable fatal error.
- Writing catch clauses in the wrong order, or omitting the final catch-all `catch { }` — Swift requires a `do` block's catch clauses to be exhaustive (either via specific-error catches covering every case, or a final unconditional `catch`).

## Best Practices

- Use `enum`-based custom `Error` types with associated data (as shown in this lesson) to represent distinct, specific failure modes rather than a single generic error type.
- Prefer `try?` over `try!` whenever a `nil`/default-value fallback is acceptable on failure; reserve `try!` for genuinely provable non-failure cases.
- Design `throws` function signatures so the possibility of failure is visible directly at both the declaration and every call site — this is one of Swift's explicit design goals for error handling.

## Real-World Usage

Swift's `throws`/`try`/`do`-`catch` model, with call-site-visible `try` markers, is standard throughout the Cocoa/iOS SDK and real Swift applications — Apple's own API design guidelines specifically favor this over silent failure or sentinel return values, and `try?`/`try!` are both common, deliberate idioms depending on how confidently a failure case can be ruled out.

## Summary

- `throws` in a function signature marks it as potentially failing; the `Error` protocol (commonly an `enum` with associated data) represents the failure itself.
- `try` (propagates, needs handling), `try?` (converts to `Optional`), and `try!` (force-try, crashes on failure) are Swift's three distinct ways to call a throwing function.
- Swift's error model is conceptually similar to Rust's `Result<T, E>` (visible failure in the signature) but expressed through `throws`/`try` propagation syntax instead of an explicit wrapped return type.

## Key Terms

- **`Error` protocol** — the protocol any custom error type must conform to be `throw`-able.
- **`try?`** — converts a throwing call's result into an `Optional`, `nil` on failure.

## Interview Questions

1. **How does Swift's error handling model compare to Rust's `Result<T, E>`, both covered in this repository?**
   Both make the possibility of failure visible in a function's signature rather than allowing silent, undeclared failure — Rust does this by wrapping the return type in `Result<T, E>` explicitly, requiring the caller to pattern-match or use `?` to propagate. Swift instead marks the function `throws` (with its actual return type unwrapped, e.g., `func validate(_:) throws -> String`), and requires the `try` keyword at every call site to make the possibility of failure visible there too. Functionally, both achieve the same goal — failure can't be silently ignored — but Swift's approach reads more like traditional exception handling syntactically (`do`/`catch`, `throw`), while Rust's is more explicitly a data type the caller must handle directly.

2. **What's the difference between `try?` and `try!`, and when is each appropriate?**
   `try?` converts a throwing call's outcome into an `Optional` — `nil` if an error was thrown, or the successful value otherwise — allowing graceful handling (e.g., via `??` for a default, or `if let` for conditional handling) without a full `do`/`catch` block. `try!` is a "force-try," analogous to force-unwrap (`!`): it asserts the call will definitely not throw, and crashes the entire program with a fatal, unrecoverable error if that assumption turns out to be wrong. `try?` is appropriate whenever a `nil`/fallback result is an acceptable outcome for failure; `try!` should be reserved for cases with a genuine, provable guarantee that the call cannot fail at that specific point in the code.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
