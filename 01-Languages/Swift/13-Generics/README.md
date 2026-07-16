# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Use generic functions and types with type constraints (`<T: Comparable>`).
- Use protocols with **associated types** — a genuinely powerful Swift generics mechanism, comparable to Rust's traits with associated types (covered earlier in this repository), and more expressive than Java's erasure-based generics.
- Use `mutating` methods on generic structs, and `where` clauses for additional constraints.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

Swift generics are, at a surface level, similar to generics in every other statically-typed language covered in this repository — type parameters, constraints. But Swift's **protocols with associated types** provide a distinctly powerful mechanism: a protocol can declare a placeholder type (`associatedtype Item`) that's filled in differently by each conforming type, without the protocol itself needing to be generic in the traditional `Protocol<T>` sense. This is conceptually very close to Rust's traits with associated types (covered earlier in this repository), and meaningfully more flexible than Java's type-erasure-based generics for certain patterns (like Swift's own `Sequence`/`Collection` protocols, which `Array`, `Dictionary`, and custom types all conform to via associated types).

## Generic Functions with Constraints

```swift
func maxOf<T: Comparable>(_ a: T, _ b: T) -> T {
    return a > b ? a : b
}
maxOf(3, 7)              // works with Int
maxOf("apple", "banana")  // works with String -- both conform to Comparable
```

## Generic Structs and `mutating` Methods

```swift
struct Stack<Element> {
    private var items: [Element] = []
    mutating func push(_ item: Element) { items.append(item) } // `mutating` REQUIRED
    mutating func pop() -> Element? { return items.popLast() }
}
```

Because `struct` is a value type (Lesson 11), any method that mutates the struct's own properties must be explicitly marked `mutating` — a genuine, compiler-enforced requirement with no equivalent in reference-type-only languages like Kotlin/Java, where every method can freely mutate instance state without any special annotation.

## Protocols with Associated Types

```swift
protocol Container {
    associatedtype Item // a placeholder type, filled in by each conforming type
    mutating func add(_ item: Item)
    var count: Int { get }
}

struct IntContainer: Container {
    private var items: [Int] = []
    mutating func add(_ item: Int) { items.append(item) } // Item is INFERRED as Int here
    var count: Int { items.count }
}
```

`Container` isn't written as `Container<Item>` — instead, `associatedtype Item` declares a placeholder that Swift infers automatically from each conforming type's actual implementation (here, `IntContainer`'s `add(_ item: Int)` implicitly makes `Item == Int` for that specific conformance). This lets a single protocol be reused across many different concrete `Item` types without the protocol itself needing generic parameter syntax — genuinely different from how Java interfaces or Kotlin interfaces express the same idea (both would need an explicit generic type parameter, `Container<T>`).

## `where` Clauses

```swift
func allEqual<T: Equatable>(_ items: [T]) -> Bool where T: Equatable {
    guard let first = items.first else { return true }
    return items.allSatisfy { $0 == first }
}
```

## Detailed Example

See [Example.swift](Example.swift) — a generic function with a `Comparable` constraint, a generic `Stack<Element>` struct with `mutating` methods, a `Container` protocol with an associated type, and a `where`-clause-constrained function.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print `7`, `banana` (the generic `maxOf` function), `2` (the generic stack's popped value), `container with 3 items` (the associated-type-based `Container` protocol), and `true`/`false` (the `allEqual` function's two test cases).

## Common Mistakes

- Forgetting `mutating` on a struct method that modifies the struct's own stored properties — this is a compile error, since structs are value types and methods are non-mutating by default (a genuinely different requirement from Kotlin/Java, where every method can freely mutate instance state).
- Trying to write `Container<Int>` instead of relying on associated-type inference — associated types are filled in implicitly by a conforming type's actual method signatures, not specified explicitly the way a traditional generic parameter would be.
- Assuming a protocol with an associated type can be used directly as a standalone type (e.g., `let x: Container = ...`) — this requires either a generic function parameter (as shown with `describe<C: Container>`) or Swift's `some`/`any` keywords (an advanced topic not covered in depth here) to work around the associated-type restriction.

## Best Practices

- Use protocols with associated types for genuinely reusable abstractions where different conforming types will naturally use different concrete item/element types (mirroring how Swift's own `Sequence`/`Collection` protocols work).
- Mark every struct method that mutates its own properties with `mutating`, and treat the compiler's enforcement of this as a helpful reminder of exactly which methods have side effects on the struct's own state.
- Use `where` clauses to express additional constraints beyond a simple `<T: Protocol>` declaration when a generic function's requirements are more specific.

## Real-World Usage

Associated-type-based protocols are foundational to Swift's own standard library design — `Sequence`, `Collection`, `IteratorProtocol`, and many other core protocols all use associated types, and understanding this pattern is essential for working with (or designing) genuinely reusable, protocol-oriented Swift APIs, a design style Apple's own frameworks lean on heavily.

## Summary

- Swift generics support type constraints (`<T: Comparable>`) similar to every other statically-typed language covered in this repository.
- `struct` methods that mutate their own properties must be explicitly marked `mutating`, a genuine, compiler-enforced consequence of `struct` being a value type (Lesson 11).
- Protocols with associated types (`associatedtype Item`) provide a powerful, inference-based generics mechanism, comparable to Rust's traits with associated types, and more flexible in some respects than Java's erasure-based generics.

## Key Terms

- **Associated type** — a placeholder type declared inside a protocol (`associatedtype Item`), filled in implicitly by each conforming type's actual implementation.
- **`mutating` method** — a struct (or enum) method explicitly marked as modifying the instance's own stored properties, required because value types are non-mutating by default.

## Interview Questions

1. **Why must a `Stack<Element>` struct's `push`/`pop` methods be marked `mutating`, when the equivalent methods on a Kotlin/Java class wouldn't need any special annotation?**
   Because `struct` is a value type in Swift (Lesson 11) — by default, its methods cannot modify the struct's own stored properties, since doing so would need to "reassign" the struct's underlying value, which requires the compiler's explicit awareness that the method changes the value. Marking a method `mutating` makes the compiler treat calls to it as effectively producing a new (mutated) value of the struct, and — critically — a `mutating` method can only be called on a struct instance held in a `var`, not a `let` (since a `let` struct instance is genuinely immutable, no exceptions). Kotlin/Java classes are reference types, where instance state can always be mutated through any method by design, so no equivalent annotation or restriction exists there.

2. **How does a protocol with an `associatedtype` differ from a traditional generic type parameter like `Container<T>`?**
   A traditional generic type (`Container<T>`) requires the type parameter to be specified explicitly wherever the type is used (`Container<Int>`, `Container<String>`), and the protocol/class itself is written with that parameter directly in its declaration. A Swift protocol with `associatedtype Item` instead declares a placeholder that each conforming type fills in *implicitly*, inferred from how that type actually implements the protocol's requirements (demonstrated in this lesson: `IntContainer`'s `add(_ item: Int)` method implicitly determines `Item == Int` for that conformance, with no explicit `Container<Int>` syntax needed anywhere). This makes associated-type protocols especially well-suited to abstractions meant to be implemented very differently by many types (exactly how Swift's own `Sequence`/`Collection` protocols work), though it comes with its own restrictions — a protocol with an associated type can't be used as a plain standalone type without `some`/`any`, unlike an instantiated generic type like `Container<Int>`.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
