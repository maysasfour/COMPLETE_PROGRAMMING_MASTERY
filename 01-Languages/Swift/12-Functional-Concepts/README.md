# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Understand Swift closures capture variables by reference and **can** mutate them — like Kotlin (covered in this repository's Kotlin course), unlike Java's effectively-final capture restriction.
- Use function composition and pass named functions directly as values.
- Understand capture lists (`[weak self]`) as a preview of Lesson 13's ARC/retain-cycle discussion.

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Like Kotlin (covered immediately before this course), Swift closures capture variables from their enclosing scope by reference, and — genuinely unlike Java's lambdas, which require captured local variables to be "effectively final" — Swift closures can freely mutate a captured `var`. This lesson also introduces **capture lists** (`[weak self]`), a Swift-specific mechanism needed because of Swift's ARC (Automatic Reference Counting) memory model, covered in depth in Lesson 13.

## Closures Capture by Reference, Can Mutate

```swift
func makeCounter() -> () -> Int {
    var count = 0 // captured by reference
    return {
        count += 1 // genuinely mutates the captured variable
        return count
    }
}
let counter = makeCounter()
counter() // 1
counter() // 2
counter() // 3 -- state persists across calls
```

This is directly comparable to the mutable-closure-capture demonstration in this repository's Kotlin course (Lesson 12 there) — both languages allow a closure to hold live, mutable access to a captured local variable, unlike Java's stricter effectively-final rule.

## Function Composition and Passing Named Functions

```swift
func compose(_ f: @escaping (Int) -> Int, _ g: @escaping (Int) -> Int) -> (Int) -> Int {
    return { x in f(g(x)) }
}
let addThenSquare = compose(square, addOne)

func isEven(_ n: Int) -> Bool { return n % 2 == 0 }
nums.filter(isEven) // passing a named function directly, like Kotlin's ::isEven function reference
```

`@escaping` marks a closure parameter that might outlive the function call itself (e.g., stored in a property, or called asynchronously later) — required whenever a closure parameter is not simply called and discarded within the function's own execution.

## Capture Lists: `[weak self]` (a Preview of ARC, Lesson 13)

```swift
class Logger {
    var prefix: String
    init(prefix: String) { self.prefix = prefix }

    func makeLogFunction() -> () -> Void {
        return { [weak self] in // capture list: weakly captures self
            guard let self = self else { return } // self may have been deallocated
            print("\(self.prefix): logging")
        }
    }
}
```

Under Swift's ARC memory model (covered fully in Lesson 13), a closure that captures `self` *strongly* — the default, if no capture list is specified — while also being stored *on* `self` (or somewhere `self` transitively holds onto) creates a **retain cycle**: `self` and the closure keep each other alive forever, since ARC's reference counting never sees either one's count drop to zero. `[weak self]` in the capture list breaks this cycle by capturing `self` weakly (not incrementing its retain count), requiring an explicit `guard let self = self` unwrap inside the closure since a weak reference is always `Optional`.

## Detailed Example

See [Example.swift](Example.swift) — mutable closure capture with independent closure instances, function composition, a `[weak self]` capture-list demonstration, and passing a named function directly to `filter`.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print `1`, `2`, `3` (the mutating counter closure), `1` (a second, independent closure's fresh state), `25` (the composed function), `APP: logging` (the `[weak self]` closure demonstration), and `[2, 4, 6]` (the named-function-based filter).

## Common Mistakes

- Capturing `self` strongly (the default) in a closure stored long-term on `self` itself (or on something `self` owns) — this creates a retain cycle under ARC, a genuine memory leak that Kotlin/Java's garbage collectors would never produce this way (since a GC can detect and collect cyclic garbage; ARC, covered in Lesson 13, cannot).
- Forgetting `@escaping` on a closure parameter that's stored or called after the function returns — Swift requires this annotation explicitly, since it changes how the closure's lifetime (and any captured references) must be managed.
- Assuming `[weak self]` makes `self` non-optional inside the closure — it doesn't; a weak reference is always `Optional`, requiring an explicit `guard let self = self` (or `self?.`) to safely use it.

## Best Practices

- Use `[weak self]` in any closure stored as a property or otherwise held onto beyond the immediate call, when that closure captures `self` and `self` also (directly or indirectly) holds onto the closure — this is one of the most commonly cited Swift/iOS memory-management patterns.
- Prefer passing named functions directly (as with `isEven` above) over wrapping them in a redundant closure, mirroring the same idiom recommended for Kotlin's `::functionName` in this repository's Kotlin course.
- Mark closure parameters `@escaping` only when genuinely necessary — it changes the calling contract and how ARC manages the closure's captured references.

## Real-World Usage

`[weak self]` capture lists are one of the most frequently discussed topics in real Swift/iOS development specifically because retain cycles (memory leaks from strong reference cycles under ARC) are a genuine, common bug class in production apps — understanding when and why to use `[weak self]` is considered essential Swift/iOS interview and code-review knowledge.

## Summary

- Swift closures capture by reference and can mutate captured variables, matching Kotlin's behavior and contrasting with Java's effectively-final restriction.
- `@escaping` marks a closure parameter whose lifetime might outlive the function call.
- Capture lists (`[weak self]`) prevent retain cycles under ARC — a genuinely Swift-specific concern with no equivalent in garbage-collected languages, previewing Lesson 13's full ARC discussion.

## Key Terms

- **Capture list (`[weak self]`)** — syntax specifying how a closure captures a reference (weakly, rather than the default strong capture), used to avoid retain cycles.
- **Retain cycle** — a memory leak under ARC where two objects (often `self` and a closure it owns) hold strong references to each other, preventing either from ever being deallocated.

## Interview Questions

1. **Why might a closure stored as a property on `self` cause a memory leak in Swift, and how does `[weak self]` fix it?**
   Swift uses Automatic Reference Counting (ARC, covered fully in Lesson 13) to manage memory: an object is deallocated once nothing holds a strong reference to it. If a closure captures `self` strongly (the default) and that closure is itself stored on a property of `self` (directly, or indirectly through another object `self` owns), then `self` keeps the closure alive (as its property), and the closure keeps `self` alive (via its strong capture) — a retain cycle where neither object's reference count ever reaches zero, so neither is ever deallocated, leaking memory for the lifetime of the app. `[weak self]` in the closure's capture list captures `self` *weakly* instead — this reference doesn't count toward `self`'s retain count, breaking the cycle, at the cost of needing to safely unwrap the now-`Optional` `self` inside the closure (typically via `guard let self = self else { return }`).

2. **How does Swift's closure variable capture compare to Java's, given both languages support closures/lambdas?**
   Swift closures capture variables by reference and can freely mutate a captured `var` across multiple invocations — demonstrated in this lesson with a counter closure that genuinely incremented shared state across three separate calls. Java's lambdas, by contrast, can only capture local variables that are "effectively final" (assigned exactly once) — attempting to mutate a captured local variable inside a Java lambda is a compile error. This matches the exact same distinction covered in this repository's Kotlin course (Lesson 12 there), where Kotlin closures behave the same way Swift's do here — both languages allow genuinely stateful closures, while Java requires workarounds (like a wrapping mutable object) to achieve the same effect.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
