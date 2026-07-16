# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Understand Swift's **Optionals** (`T?`) — its null-safety mechanism, directly comparable to Kotlin's nullable types (`String?`) covered in this repository's Kotlin course, but with distinct syntax.
- Use `if let`, `guard let`, the nil-coalescing operator (`??`), optional chaining (`?.`), and force unwrap (`!`).

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

Like Kotlin (covered immediately before this course), Swift bakes null safety directly into its type system: `String` and `String?` (technically `Optional<String>`) are different types, and the compiler enforces that a plain `String` can never hold the absence-of-value case. This is the same underlying idea as Kotlin's nullable types, but Swift's specific syntax and idioms (`if let`/`guard let` "optional binding," in particular) are distinctly its own.

## `T?` (Optional): Explicit, Compiler-Enforced Absence

```swift
let nonOptional: String = "always has a value"
let optional: String? = nil // the ? makes this type EXPLICITLY optional
// let x: String = nil // COMPILE ERROR: 'nil' cannot be used with non-optional type 'String'
```

## Nil-Coalescing (`??`) — Like Kotlin's Elvis Operator

```swift
print(optional ?? "no value") // ?? supplies a default if optional is nil
```

## Optional Binding: `if let` / `guard let`

```swift
if let unwrapped = maybeName {
    print(unwrapped) // unwrapped is a non-optional String here
} else {
    print("was nil")
}

func greet(_ maybe: String?) -> String {
    guard let value = maybe else {
        return "no name provided" // early exit if nil
    }
    return "Hello, \(value)!" // value is safely unwrapped and usable for the REST of the function
}
```

`if let` unwraps an optional only within its own `if` block's scope. `guard let` is Swift's distinctive early-exit pattern: if the optional is `nil`, the `else` branch **must** exit the current scope (`return`, `throw`, `break`, or a fatal error) — and if it doesn't hit that `else`, the unwrapped value remains in scope and usable for the *rest* of the enclosing function, avoiding the nested-`if` "pyramid of doom" that repeated `if let` checks can produce.

## Optional Chaining (`?.`) — Like Kotlin's `?.`

```swift
struct Address { var city: String? }
struct UserRecord { var address: Address? }
let user = UserRecord(address: nil)
print(user.address?.city ?? "no city on file") // short-circuits to nil if address is nil
```

## Force Unwrap (`!`) — Like Kotlin's `!!`

```swift
let definitelyNotNil: String? = "trust me"
print(definitelyNotNil!.uppercased()) // CRASHES with a fatal error if actually nil
```

Force unwrap asserts a value is definitely non-`nil`, crashing the program immediately (a fatal, unrecoverable runtime error, not a catchable exception) if that assumption is wrong — directly analogous to Kotlin's `!!` (which throws a catchable `NullPointerException` instead), but Swift's version is a harder, non-recoverable crash. Both languages recommend using this escape hatch sparingly, reserved for genuinely provable non-nil invariants.

## Detailed Example

See [Example.swift](Example.swift) — basic types, type inference, `??`, `if let`, `guard let`, optional chaining, and force unwrap.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print the basic type values, confirm `inferred` is statically typed, `optional: no value` (the nil-coalescing default), `if let unwrapped: Grace`, both `greet()` results (`Hello, Linus!` and `no name provided`), `city: no city on file` (optional chaining through a nil), `TRUST ME` (the force-unwrapped, uppercased string), and `safe default: -1`.

## Common Mistakes

- Force-unwrapping (`!`) a value without being certain it can't be `nil` — unlike Kotlin's `!!` (which throws a catchable exception), Swift's `!` crashes the entire program with an unrecoverable fatal error if wrong, making this an even higher-stakes mistake than Kotlin's equivalent.
- Using nested `if let` statements instead of `guard let` for early-exit validation logic — `guard let` keeps the "happy path" unindented and unwraps the value for the rest of the function, while nested `if let`s produce the classic "pyramid of doom."
- Forgetting `guard let`'s `else` branch must exit the current scope — the compiler enforces this; a `guard` whose `else` branch doesn't return/throw/break is a compile error.

## Best Practices

- Prefer `guard let` for early-exit validation at the top of a function; prefer `if let` when the unwrapped value is only needed within a specific conditional branch.
- Use `??` to supply sensible defaults instead of force-unwrapping wherever a reasonable fallback exists.
- Reserve `!` for cases with a genuine, provable invariant that the value cannot be `nil` at that point (mirroring the same guidance given for Kotlin's `!!` in this repository's Kotlin course).

## Real-World Usage

Optionals and `guard let` are considered defining, idiomatic Swift patterns — real Swift/iOS codebases use `guard let` pervasively for input validation and early returns, and force-unwrapping in production code (outside of genuinely provable invariants) is widely flagged in code review as a crash risk, since a wrong assumption crashes the entire app rather than throwing a recoverable exception.

## Summary

- Swift's `T?` (Optional) is directly comparable to Kotlin's nullable types — both bake null safety into the type system, enforced at compile time.
- `??` (nil-coalescing) mirrors Kotlin's `?:` (Elvis); `?.` (optional chaining) mirrors Kotlin's `?.` (safe call); `!` (force unwrap) mirrors Kotlin's `!!`, but crashes harder (a fatal, non-catchable error) rather than throwing a catchable exception.
- `guard let` is Swift's distinctive early-exit unwrapping pattern, with no direct Kotlin equivalent covered in this repository.

## Key Terms

- **Optional (`T?`)** — a type that can hold either a value of type `T` or `nil`, Swift's null-safety mechanism.
- **`guard let`** — an early-exit optional-unwrapping statement; its `else` branch must exit the current scope.

## Interview Questions

1. **How does `guard let` differ from `if let`, and why is it often preferred for input validation?**
   `if let` unwraps an optional only within its own `if` block's scope — the unwrapped value isn't available after the block ends. `guard let` instead requires its `else` branch to exit the current scope entirely (via `return`, `throw`, `break`, or a fatal error) if the optional is `nil`; if execution continues past the `guard`, the unwrapped value remains in scope and usable for the rest of the enclosing function. This makes `guard let` preferable for validating several optional inputs at the top of a function — each failed check exits immediately with a clear early return, keeping the main logic un-nested, rather than producing several levels of nested `if let` blocks (the "pyramid of doom").

2. **How does Swift's force-unwrap (`!`) differ from Kotlin's non-null assertion (`!!`) in terms of failure behavior?**
   Both assert that an optional/nullable value is definitely not `nil`/`null` at that point, and both are used sparingly for genuinely provable invariants. However, Kotlin's `!!` throws a catchable `NullPointerException` if the assumption is wrong, allowing calling code to `catch` and recover. Swift's `!` instead triggers a fatal, unrecoverable runtime error (a hard crash) if the value is actually `nil` — there's no `catch`-based recovery path at all, making an incorrect force-unwrap in Swift an even higher-stakes mistake than an incorrect `!!` in Kotlin.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
