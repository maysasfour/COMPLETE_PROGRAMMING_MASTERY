# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Use `if`/`else`, and `switch` (no fall-through by default — the opposite of C/Java/JavaScript, matching Go's design choice covered earlier in this repository).
- Use `switch`'s pattern matching: ranges, tuples, and `where` clauses.
- Use explicit `fallthrough` when fall-through behavior is genuinely wanted.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Swift's `switch` does **not** fall through by default — matching Go's design choice (covered earlier in this repository) and the opposite of C/Java/JavaScript's fall-through-unless-`break` convention. Swift's `switch` is also considerably more powerful than a C-style switch: it supports matching against ranges, tuples, and arbitrary boolean conditions via `where` clauses, not just simple value equality.

## `switch`: No Fall-Through by Default

```swift
switch day {
case 1, 2, 3, 4, 5: // comma-separated values sharing one case, no fall-through needed
    print("Weekday")
case 6, 7:
    print("Weekend")
default: // required unless the compiler can prove exhaustiveness (e.g., over an enum)
    print("Invalid day")
}
```

## Pattern Matching: Ranges, `where` Clauses, and Tuples

```swift
switch temp {
case ..<32:
    print("freezing")
case 32...60:
    print("cold")
case 61...80 where temp % 2 == 0: // `where` adds an extra boolean condition to a case
    print("mild and even")
case 61...80:
    print("mild")
default:
    print("hot")
}

switch point { // point is a tuple (Int, Int)
case (0, 0):
    print("origin")
case (_, 0):
    print("on the x-axis") // _ matches any value in that position
default:
    print("elsewhere")
}
```

## Explicit `fallthrough`

```swift
switch 1 {
case 1:
    print("one")
    fallthrough // explicitly opts INTO fall-through -- the opposite of C's default behavior
case 2:
    print("also prints because of fallthrough")
default:
    break
}
```

Since Swift's `switch` doesn't fall through by default, `fallthrough` exists as an explicit keyword for the rare cases where that behavior is genuinely wanted — inverting C's model (fall-through by default, `break` to opt out) into fall-through-as-deliberate-opt-in.

## Detailed Example

See [Example.swift](Example.swift) — `if`/`else`, both `switch` fall-through demonstrations, range/tuple/`where`-clause pattern matching, and loops.

## Practice

- [Exercises/Exercise.swift](Exercises/Exercise.swift) — implement FizzBuzz using `switch` with `where` clauses.
- [Solutions/Solution.swift](Solutions/Solution.swift) — a worked solution (documented expected output included, not verified by execution).

## Run It

```bash
swiftc Example.swift -o example && ./example
swiftc Solutions/Solution.swift -o solution && ./solution
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

`Example.swift` should print `grade: B`, `Weekday`, `mild` (75 is odd, so the `where temp % 2 == 0` case doesn't match), `on the x-axis` (for point `(2, 0)`), `one` followed by `also prints because of fallthrough` (the explicit fallthrough demonstration), and the loop output. `Solutions/Solution.swift` should print the standard FizzBuzz sequence for 1–15.

## Common Mistakes

- Writing `break` inside a `switch` case out of C/Java habit — it's unnecessary in Swift, since cases never fall through by default.
- Forgetting `default` is required in a `switch` over a type the compiler can't prove is exhaustively covered (e.g., an `Int`, as opposed to an `enum`, covered in Lesson 11) — omitting it is a compile error.
- Assuming `case (_, 0)` only matches when the first tuple element is literally the wildcard character — `_` means "match any value in this position," not a literal value.

## Best Practices

- Take advantage of `switch`'s range/tuple/`where`-clause pattern matching instead of chains of `if`/`else if` where the logic naturally fits a value-matching shape.
- Use comma-separated case values (`case 1, 2, 3:`) to share one case body across several values instead of relying on fall-through.
- Reserve explicit `fallthrough` for genuinely intentional shared-logic cases — it's rare in idiomatic Swift precisely because `switch`'s other features (multi-value cases, ranges) usually express the same intent more clearly.

## Real-World Usage

Swift's `switch` pattern matching (particularly over enums with associated values, covered in Lesson 11) is one of the language's most heavily used idioms in real Swift/iOS code — modeling UI state, API responses, and parsing logic with exhaustive `switch` over an `enum` is standard practice, leaning on the compiler's exhaustiveness checking for correctness.

## Summary

- Swift's `switch` does not fall through by default — matching Go, the opposite of C/Java/JavaScript.
- `switch` supports range, tuple, and `where`-clause pattern matching, well beyond simple value equality.
- Explicit `fallthrough` exists for the rare cases needing C-style fall-through behavior.

## Key Terms

- **`where` clause** — an extra boolean condition attached to a `switch` case, narrowing when that case matches.
- **`fallthrough`** — explicitly continues execution into the next `switch` case, since Swift doesn't do this by default.

## Interview Questions

1. **Does Swift's `switch` fall through by default, and how does this compare to other languages covered in this repository?**
   No — Swift's `switch` does not fall through by default, matching Go's design choice (covered earlier in this repository) and the opposite of C, Java, and JavaScript's switch statements, which fall through unless each case ends with `break`. Swift instead provides an explicit `fallthrough` keyword for the rare cases where that behavior is genuinely desired, inverting the default: fall-through becomes a deliberate opt-in rather than something that must be actively prevented with `break` in every case.

2. **What does a `where` clause add to a Swift `switch` case, and why is this more powerful than a typical C-style switch?**
   A `where` clause attaches an arbitrary additional boolean condition to a `switch` case, so the case only matches if both the primary pattern *and* the `where` condition are true — for example, `case 61...80 where temp % 2 == 0` matches only even temperatures within that range. This goes well beyond a C-style switch's simple value-equality matching, letting a single `switch` statement express range checks, tuple destructuring, and conditional refinements together in one exhaustive, pattern-matching construct, rather than needing a combination of `switch` plus nested `if` statements to express the same logic.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
