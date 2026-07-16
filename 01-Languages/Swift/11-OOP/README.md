# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Understand Swift's most fundamental OOP design choice: `struct` (value type) is the idiomatic **default**; `class` (reference type) is used only when reference semantics or inheritance are genuinely needed — unlike Kotlin/Java, where every user-defined type is a reference type (a class).
- Use protocol-oriented programming: protocols combined with extensions providing default implementations, a distinctive Swift alternative to traditional class inheritance.
- Use enums with associated values — richer than a plain C-style enum, directly comparable to Rust's enum (covered earlier in this repository).

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept

Unlike Kotlin and Java (both covered in this repository), where every user-defined type is a class (a reference type), Swift gives developers a genuine, deliberate choice: `struct` (a value type, copied on assignment — exactly like Swift's `Array`/`Dictionary`/`Set`, covered in Lesson 07) or `class` (a reference type, shared on assignment, and the only one supporting inheritance). Swift's official guidance and community convention favor `struct` as the default, reserving `class` for cases genuinely needing reference semantics or a class hierarchy.

## `struct` (Value Type) vs. `class` (Reference Type)

```swift
struct PointStruct { var x: Int; var y: Int }
var s1 = PointStruct(x: 1, y: 2)
var s2 = s1 // COPIES s1
s2.x = 99
// s1.x is still 1 -- s2 is a genuinely independent value

class PointClass {
    var x: Int; var y: Int
    init(x: Int, y: Int) { self.x = x; self.y = y }
}
let c1 = PointClass(x: 1, y: 2)
let c2 = c1 // c2 refers to the SAME instance as c1
c2.x = 99
// BOTH c1.x and c2.x are now 99 -- they're the same object
```

This is exactly the same value-vs-reference distinction demonstrated for collections in Lesson 07, applied here to user-defined types: `struct` inherits `Array`/`Dictionary`/`Set`'s copy-on-assignment behavior, while `class` behaves like every type in Kotlin/Java.

## Protocol-Oriented Programming: Protocols + Extensions

```swift
protocol Speaker {
    func speak() -> String
}
extension Speaker { // extends the PROTOCOL -- provides a DEFAULT implementation
    func announce() -> String { return "Announcement: \(speak())" }
}
struct Dog: Speaker {
    func speak() -> String { return "Woof!" }
    // announce() comes FREE from the protocol extension -- no need to write it
}
```

Extending a protocol itself (rather than a specific conforming type) lets any type conforming to that protocol automatically inherit default method implementations — a distinctive Swift design pattern (dubbed "protocol-oriented programming" in Apple's own framing) that provides code-sharing benefits similar to traditional inheritance, but works across both `struct`s and `class`es (since `struct`s can conform to protocols but cannot inherit from a base class).

## Classes Support Inheritance; Structs Do Not

```swift
class Animal {
    let name: String
    init(name: String) { self.name = name }
    func makeSound() -> String { return "..." }
}
class Cat: Animal {
    override func makeSound() -> String { return "Meow!" } // `override` mandatory, like Kotlin
}
```

## Enums with Associated Values

```swift
enum NetworkResult {
    case success(data: String)
    case failure(code: Int, message: String)
}
switch result {
case .success(let data): return "Success: \(data)"
case .failure(let code, let message): return "Failed [\(code)]: \(message)"
}
```

Swift enums can carry associated data per case, directly comparable to Rust's `enum` (covered earlier in this repository) — a genuinely richer construct than a plain C-style/Java enum of named constants.

## Detailed Example

See [Example.swift](Example.swift) — the value-vs-reference-type contrast for `struct`/`class`, protocol-oriented programming with a default implementation, class inheritance with mandatory `override`, and an enum with associated values used in a `switch`.

## Run It

```bash
swiftc Example.swift -o example
./example
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running the compiled binary should print `s1.x: 1, s2.x: 99` (confirming struct value semantics — `s1` unaffected), `c1.x: 99, c2.x: 99` (confirming class reference semantics — both affected, since they're the same object), `Woof!` and `Announcement: Woof!` (the protocol extension's default method), the polymorphic `Animal`/`Cat` output, and both `NetworkResult` cases handled correctly.

## Common Mistakes

- Defaulting to `class` for every type out of Kotlin/Java habit — Swift's idiomatic convention favors `struct` unless reference semantics or inheritance are genuinely needed, and using `class` unnecessarily forgoes the safety benefits of value semantics (Lesson 07).
- Assuming a `struct` can inherit from another `struct` or a `class` — it can't; only `class` supports inheritance in Swift. `struct`s can, however, conform to any number of protocols.
- Forgetting protocol extension default implementations can be *overridden* by a conforming type simply by providing its own implementation of the same method — the protocol extension's version is used only when the conforming type doesn't supply its own.

## Best Practices

- Default to `struct` for data-modeling types; reach for `class` deliberately when reference semantics (shared, mutable state across multiple owners) or inheritance are genuinely part of the design.
- Use protocol extensions to share default behavior across both `struct`s and `class`es, rather than relying on class inheritance as the only code-reuse mechanism.
- Use enums with associated values to model a fixed set of distinct cases that each carry different data — a common, idiomatic replacement for class hierarchies in many situations (e.g., representing an API result as `success`/`failure` rather than a class hierarchy with a base `Result` class).

## Real-World Usage

Apple's own frameworks (especially SwiftUI) lean heavily on `struct`-based value types and protocol-oriented programming rather than traditional class inheritance — SwiftUI's `View` protocol, for instance, is adopted by `struct`s almost universally, and Apple's official Swift documentation explicitly recommends starting with `struct` and only reaching for `class` when reference semantics are specifically required.

## Summary

- `struct` (value type, copied on assignment) is Swift's idiomatic default; `class` (reference type, shared on assignment, supports inheritance) is used deliberately when needed — a genuine design choice not present in Kotlin/Java, where everything is a reference-type class.
- Protocol extensions provide default method implementations to any conforming type, a distinctive alternative/complement to class inheritance.
- Enums with associated values (directly comparable to Rust's `enum`) model a fixed set of cases each carrying different data.

## Key Terms

- **Value type** — a type (like `struct`) copied on assignment or parameter passing; Swift's idiomatic default for most types.
- **Protocol-oriented programming** — Swift's pattern of using protocols plus extensions (providing default implementations) as a primary code-reuse mechanism, alongside or instead of class inheritance.

## Interview Questions

1. **When should a Swift type be a `struct` versus a `class`, and why does this choice matter more in Swift than in Kotlin or Java?**
   Swift's official guidance favors `struct` by default: value types are copied on assignment (as demonstrated in this lesson and in Lesson 07's collections), meaning passing one around or storing it in multiple places never risks unexpected shared-mutation bugs. `class` should be used deliberately when reference semantics are genuinely needed — shared, mutable state that multiple parts of a program need to observe and modify together — or when class inheritance is specifically required (since only `class` supports it). This choice matters more in Swift than in Kotlin/Java precisely because those languages don't offer this choice at all: every user-defined type there is a reference-type class, so there's no equivalent decision to make.

2. **How does a protocol extension provide "default implementations," and how does this relate to Swift's "protocol-oriented programming" philosophy?**
   Extending a protocol itself (rather than a specific conforming type) lets any type that conforms to the protocol automatically gain the extension's method implementations, without needing to write that code itself — demonstrated in this lesson, where `Dog` gained an `announce()` method for free just by conforming to `Speaker`, whose extension provided a default `announce()` built on top of the required `speak()`. This is central to Apple's "protocol-oriented programming" framing: rather than relying primarily on class inheritance for code reuse (which only works for classes and only supports single inheritance), Swift encourages composing behavior through protocol conformance plus extensions, which works for both `struct`s and `class`es and allows a type to gain behavior from multiple unrelated protocols simultaneously.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
