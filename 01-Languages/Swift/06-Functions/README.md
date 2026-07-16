# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Use Swift's genuinely distinctive **argument labels**: a parameter's external name (used at the call site) can differ from its internal name (used inside the function body) — not present in any other language covered in this repository.
- Use default values, variadic parameters, and `inout` parameters (with the required `&` sigil at the call site).
- Use closures, trailing closure syntax, and the `$0`/`$1` shorthand argument names.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Swift's most distinctive function feature — not shared by any other language covered in this repository — is the separation between a parameter's **argument label** (the name used at the call site) and its **parameter name** (the name used inside the function body). This makes call sites read like natural language (`greet(person: "Ada")`) while keeping the function body's internal variable names independent and concise.

## Argument Labels vs. Parameter Names

```swift
func greet(person name: String, greeting: String = "Hello") -> String {
    // "person" is the external label; "name" is the internal parameter name
    return "\(greeting), \(name)!"
}
greet(person: "Ada") // call site uses "person:" -- the LABEL, not "name:"
```

When only one name is written (as with `greeting` above), it serves as both the label and the internal name. Writing `_` before a parameter (as in the next example) omits the label entirely, making the call site read without a label for that argument.

```swift
func multiply(_ a: Int, by b: Int) -> Int { return a * b }
multiply(3, by: 4) // no label for `a` (because of `_`); "by:" labels `b`
```

## Variadic and `inout` Parameters

```swift
func sum(_ numbers: Int...) -> Int { return numbers.reduce(0, +) }
sum(1, 2, 3, 4) // 10

func increment(_ n: inout Int) { n += 1 }
var counter = 5
increment(&counter) // the & sigil is REQUIRED at the call site -- makes mutation visible there too
```

Swift's `inout` parameter (with its mandatory `&` at the call site) is conceptually similar to PHP's `&$param` (covered in this repository's PHP course), but Swift's explicit `&` requirement at every call site makes the potential mutation visible to the reader right where it happens, not just at the function's declaration.

## Closures, Trailing Closure Syntax, and `$0`

```swift
let multiplier: (Int) -> Int = { x in x * 3 } // full closure syntax

func applyTwice(_ x: Int, _ f: (Int) -> Int) -> Int { return f(f(x)) }
applyTwice(2) { $0 * 2 } // trailing closure syntax + $0 (implicit first-parameter shorthand)

[1, 2, 3].map { $0 * 2 } // $0 is Swift's equivalent of Kotlin's `it`
```

## Detailed Example

See [Example.swift](Example.swift) — argument labels, label omission with `_`, variadic and `inout` parameters, and closures with trailing syntax and `$0`.

## Practice

- [Exercises/Exercise.swift](Exercises/Exercise.swift) — implement a labeled variadic `average(of:)` function and an `isPrime` helper used with `filter`.
- [Solutions/Solution.swift](Solutions/Solution.swift) — a worked solution (documented expected output included, not verified by execution).

## Run It

```bash
swiftc Example.swift -o example && ./example
swiftc Solutions/Solution.swift -o solution && ./solution
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

`Example.swift` should print two greetings, `12` (the labeled multiply), `10` (variadic sum), `counter after increment: 6`, `15` and `8` (the two closure demonstrations), and `[2, 4, 6]`. `Solutions/Solution.swift` should print the correct list of primes up to 30 and `average: 2.5`.

## Common Mistakes

- Forgetting a function parameter's external label is required at the call site by default — `greet("Ada")` would be a compile error for the `greet(person:greeting:)` signature above, since `person:` must be written unless the parameter is declared with a leading `_`.
- Forgetting the `&` sigil when passing a variable to an `inout` parameter — omitting it is a compile error, a deliberate design choice making every potential mutation visible at the call site.
- Assuming `$0`/`$1` are available in every closure — they're only implicitly available in closures with no explicitly named parameters; a closure declared with named parameters (`{ x in x * 3 }`) uses those names instead.

## Best Practices

- Design argument labels to make call sites read naturally, following Swift API design guidelines (e.g., `greet(person:)` rather than `greet(name:)` if "person" reads more naturally at the call site while "name" is clearer inside the function).
- Use `_` to omit a label only when the parameter's meaning is already obvious from the function name itself (e.g., the first parameter of `multiply(_:by:)`).
- Use trailing closure syntax and `$0`/`$1` for short, simple closures; switch to named parameters for closures with non-trivial logic, for readability.

## Real-World Usage

Swift's argument-label design is central to Apple's own API design guidelines and is considered one of Swift's most distinctive ergonomic features — real Swift/Cocoa APIs (like `UIView.animate(withDuration:animations:)`) are specifically designed so call sites read like natural English sentences, a deliberate design goal unique to Swift among the languages covered in this repository.

## Summary

- Swift separates a parameter's external argument label (call site) from its internal parameter name (function body) — a genuinely distinctive feature among this repository's languages.
- `_` omits an argument label; `inout` parameters require an explicit `&` at the call site, making mutation visible where it happens.
- Trailing closure syntax and `$0`/`$1` shorthand parameters make short closures concise, similar in spirit to Kotlin's trailing lambdas and `it`.

## Key Terms

- **Argument label** — the external name used at a function's call site, which can differ from the parameter's internal name.
- **`inout` parameter** — a parameter that can mutate the caller's variable, requiring an explicit `&` at the call site.

## Interview Questions

1. **What's the difference between a Swift parameter's "argument label" and its "parameter name," and why does this feature exist?**
   The argument label is the name used at the function's call site (e.g., `person` in `greet(person: "Ada")`), while the parameter name is the identifier used to refer to that value inside the function's body (e.g., `name` in the function's implementation) — these can be the same, different, or the label can be omitted entirely with `_`. This feature exists specifically so that call sites can read naturally, almost like an English sentence (`greet(person: "Ada")` reads better than `greet(name: "Ada")` might in some contexts), while the function's internal implementation can use whatever variable name is clearest for its own logic — a deliberate Swift API design goal not shared by any other language covered in this repository.

2. **Why does Swift require an explicit `&` sigil when passing a variable to an `inout` parameter, when the function signature already declares the parameter as `inout`?**
   Requiring `&` at every call site makes the possibility of mutation visible exactly where it happens, not just in the function's declaration (which the caller might not have read recently, or at all, if calling a library function). This is a deliberate readability/safety design choice: a reader scanning a call site immediately sees `&counter` and knows `counter` might be modified by this call, without needing to check the called function's signature to discover that. This mirrors, in spirit, PHP's `&$param` reference-parameter syntax (covered in this repository's PHP course), though Swift's requirement applies at the call site rather than only the declaration.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
