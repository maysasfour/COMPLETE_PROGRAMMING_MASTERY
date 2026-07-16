# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason. Unlike this repository's other language courses, the anti-pattern/fix contrasts below are described from documented Swift language semantics, not confirmed by actually executing and observing the "bad" version misbehave.

## Learning Objectives

- Recognize and fix three genuine Swift anti-patterns: force-unwrap (`!`) crashing instead of safe optional handling, using `class` where `struct` would prevent an aliasing bug, and a closure creating a retain cycle by capturing `self` strongly.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept

This lesson is a synthesis, following the same before/after pattern as every other language course in this repository — three mistakes that compile and (mostly) run in Swift but undermine the language's own safety features (optionals, Lesson 03; value types, Lesson 07/11; ARC, Lesson 12). **Unlike those other courses, these examples were not actually executed and observed misbehaving in this environment** — the descriptions below follow directly from documented Swift semantics, and should be independently verified against a real Swift toolchain before being treated as confirmed.

## Anti-Pattern 1: Force-Unwrap (`!`) Instead of Safe Handling

```swift
func findUserBad(_ users: [String: Int], _ name: String) -> Int {
    return users[name]! // CRASHES the entire program with a fatal error if name isn't found
}
func findUserGood(_ users: [String: Int], _ name: String) throws -> Int {
    guard let id = users[name] else {
        throw NSError(domain: "UserLookup", code: 1, userInfo: [NSLocalizedDescriptionKey: "no user named '\(name)' found"])
    }
    return id
}
```

Per Swift's documented semantics, calling `findUserBad` with a missing key crashes the entire program with an unrecoverable fatal error (no `catch` can intercept it) — this lesson deliberately does *not* call `findUserBad` with bad input, to avoid actually crashing the demonstration binary. `findUserGood` instead throws a specific, catchable, descriptive error (Lesson 09).

## Anti-Pattern 2: `class` (Reference Type) Instead of `struct` (Value Type)

```swift
class MutablePointClass { var x: Int; var y: Int; /* ... */ }
struct PointStruct { var x: Int; var y: Int }

func moveRight(_ point: MutablePointClass) { point.x += 1 } // mutates the ORIGINAL object
func movedRight(_ point: PointStruct) -> PointStruct {
    var copy = point
    copy.x += 1
    return copy // the CALLER's original is never touched
}
```

Per Lesson 11's documented value-vs-reference semantics: `let aliasedReference = classPoint` creates a second reference to the *same* `MutablePointClass` instance, so calling `moveRight(classPoint)` also changes what `aliasedReference` observes — a genuine, easy-to-introduce aliasing bug. The `struct`-based version cannot have this problem at all, since `PointStruct` is copied, not aliased, on assignment.

## Anti-Pattern 3: A Closure Creating a Retain Cycle

```swift
class NotificationCenterBad {
    var onNotify: (() -> Void)?
    func subscribeBad() {
        onNotify = { print("\(self.name) notified") } // captures self STRONGLY -- retain cycle
    }
}
class NotificationCenterGood {
    var onNotify: (() -> Void)?
    func subscribeGood() {
        onNotify = { [weak self] in // breaks the cycle
            guard let self = self else { return }
            print("\(self.name) notified")
        }
    }
}
```

Per Lesson 12's ARC discussion: `NotificationCenterBad.subscribeBad()` stores a closure on `self.onNotify` that also captures `self` strongly — a retain cycle where neither `self` nor the closure can ever be deallocated. This anti-pattern is genuinely harder to demonstrate via simple console output than the other two (a retain cycle doesn't crash or print anything wrong; it silently leaks memory), which is why real Swift/iOS developers rely on tools like Xcode's Memory Graph Debugger to detect it, rather than observing it through ordinary program output — a real, disclosed limitation of demonstrating this specific anti-pattern in a simple script.

## Detailed Example

See [Example.swift](Example.swift) — all three anti-pattern/fix pairs, with the genuinely crash-inducing call (`findUserBad` with a missing key) deliberately not invoked, to keep the demonstration itself safely runnable.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print a caught, specific error message for the safe user-lookup version; confirmation that `aliasedReference.x` changed alongside `classPoint.x` (the aliasing bug) versus `structPoint.x` remaining unchanged after `movedRight` (the struct fix); and an explanatory note about why the retain-cycle anti-pattern isn't directly observable through console output.

## Common Mistakes

- Force-unwrapping (`!`) any value obtained from external, untrusted, or reasonably-fallible sources (dictionary lookups, parsed input, network responses) — per Swift's documented behavior, a wrong assumption crashes the entire program, with no way to catch or recover.
- Defaulting to `class` for simple data-holding types out of habit from other languages — per Lesson 11's guidance, `struct` should be the default in Swift specifically to avoid aliasing bugs like the one demonstrated here.
- Storing a closure on `self` that also captures `self` strongly, without a `[weak self]` capture list — per ARC's documented reference-counting behavior, this creates a retain cycle that leaks memory for the object's entire remaining app lifetime.

## Best Practices

- Prefer `guard let`/`if let`/`try`-based error handling over force-unwrap (`!`)/force-try (`try!`) for any value that could plausibly be absent or fail.
- Default to `struct`; reach for `class` deliberately only when reference semantics or inheritance are genuinely needed (Lesson 11).
- Use `[weak self]` in any closure stored on `self` (or transitively reachable from `self`) that also captures `self`.

## Real-World Usage

All three of these anti-patterns are widely documented, commonly discussed pitfalls in real Swift/iOS development — force-unwrap crashes are a leading cause of production app crash reports, unintended `class` aliasing is a common source of "why did this other object's data change unexpectedly" bugs, and retain cycles are one of the most frequently cited memory-leak causes in real iOS apps, extensively covered in Apple's own documentation and WWDC sessions.

## Summary

- Force-unwrap (`!`) should be reserved for genuinely provable non-nil/non-throwing cases; `guard let`/`try` communicate and handle failure safely instead.
- `struct` (value type) avoids the aliasing bugs `class` (reference type) can introduce when reference semantics weren't actually intended.
- Closures stored on `self` that also capture `self` need `[weak self]` to avoid retain cycles under ARC.

## Key Terms

- **Aliasing bug** — an unintended, shared mutation through a reference-type object, resolved by using a value type (`struct`) where independent copies are actually intended.
- **Retain cycle** — a memory leak where two objects (often `self` and a closure it owns) hold strong references to each other under ARC, preventing deallocation.

## Interview Questions

1. **Why is force-unwrap (`!`) considered risky, and what would you use instead for a dictionary lookup that might not find a key?**
   Force-unwrap asserts a value is definitely non-`nil`, and per Swift's documented behavior, crashes the entire program with an unrecoverable fatal error if that assumption is wrong — there's no `catch`-based recovery path at all, unlike a thrown error. For a dictionary lookup (`users[name]`, which returns an `Optional` since the key might not exist), the safer alternative is `guard let`/`if let` to handle the `nil` case explicitly, or `?? defaultValue` if a sensible fallback exists, or throwing a specific, catchable error (as `findUserGood` does in this lesson) so calling code can respond to the failure gracefully instead of the entire app crashing.

2. **Why might choosing `class` instead of `struct` for a simple data type introduce a bug that wouldn't exist with `struct`?**
   Per Lesson 11's documented semantics, `class` is a reference type — assigning a `class` instance to another variable creates a second reference to the *same* underlying object, so mutating through either reference affects what both observe. If a type's design didn't actually intend to share mutable state (it was meant to represent an independent value, like a point or a data record), using `class` introduces exactly this kind of accidental aliasing bug: code that assigns or passes the object around, expecting an independent copy, instead ends up with unintended shared mutation. `struct` (a value type) is copied on assignment or parameter passing, eliminating this specific bug class entirely — which is precisely why Swift's own guidance recommends `struct` as the default choice unless reference semantics are genuinely intended.

## Recommended Next Lesson

This completes the core Swift course (Lessons 01–19). Return to the [Swift course overview](../README.md) or continue to the next language in the course order. **Given this entire course was written without a working local Swift toolchain, if you have access to one, please compile and run every lesson's example and treat any discrepancy from documented output as this course's error, not the language's.**
