# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Define structs with data, and attach behavior via `impl` blocks.
- Define and implement traits — Rust's interface mechanism, similar to Go's implicit interfaces but with explicit `impl Trait for Type`.
- Understand Rust has no inheritance at all — composition and traits are the only mechanisms, an even stronger stance than Go's.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md) and [10-File-Handling](../10-File-Handling/README.md)

## Concept

Like Go, Rust has **no classes and no inheritance** — but where Go's interfaces are satisfied *implicitly* (structural, no keyword), Rust **requires an explicit `impl Trait for Type` block**, striking a middle ground: still no inheritance hierarchy, but traits must be explicitly implemented (unlike Go's fully implicit interfaces, more like Java/C#'s explicit `implements`/`:` but without any class/inheritance baggage attached).

## Structs and `impl`

```rust
struct Animal {
    name: String,
}

impl Animal { // an impl block attaches methods to Animal
    fn new(name: &str) -> Self { // "constructor" -- just an associated function, no special syntax
        Animal { name: name.to_string() }
    }

    fn speak(&self) -> String { // &self -- borrows the instance, doesn't take ownership
        format!("{} makes a sound", self.name)
    }
}

let a = Animal::new("Rex");
println!("{}", a.speak());
```

## Traits: Rust's Interface Mechanism (Explicit Implementation)

```rust
trait Speaker {
    fn speak(&self) -> String;
}

impl Speaker for Animal { // EXPLICIT -- unlike Go's implicit interface satisfaction
    fn speak(&self) -> String {
        format!("{} makes a sound", self.name)
    }
}

fn announce(s: &impl Speaker) { // accepts anything implementing Speaker
    println!("{}", s.speak());
}
```

Traits can also provide **default method implementations** (like Java 8+ interface default methods, Lesson 11 of the Java course) — a type implementing the trait can use the default or override it.

```rust
trait Greet {
    fn name(&self) -> String;
    fn greeting(&self) -> String { // default implementation
        format!("Hello, {}!", self.name())
    }
}
```

## No Inheritance: Composition Instead

```rust
struct Dog {
    animal: Animal, // composition -- Dog "has an" Animal, no inheritance relationship at all
    breed: String,
}

impl Dog {
    fn speak(&self) -> String { // Dog defines its own speak(), delegating to the contained Animal
        format!("{} (a {})", self.animal.speak(), self.breed)
    }
}
```

Rust has no struct embedding/promotion the way Go does — composition is fully explicit; accessing `dog.animal.name` requires going through the field, with no automatic promotion of `Animal`'s fields/methods onto `Dog` directly.

## Detailed Example

See [main.rs](main.rs).

## Expected Output

Compiling and running `main.rs` prints a struct's method called directly, the same struct used through a function accepting `impl Speaker` (explicit trait implementation), a trait's default method used without being overridden, and explicit composition (no field/method promotion) contrasted with Go's embedding.

## Common Mistakes

- Expecting Go-style implicit interface satisfaction — Rust requires an explicit `impl Trait for Type` block; simply having the right methods isn't enough.
- Looking for inheritance or struct embedding/field-promotion — neither exists; composition (a struct containing another struct as a named field, accessed explicitly) is the only mechanism.
- Forgetting `&self` (or `&mut self`, or `self` for consuming methods) as the first parameter of a method inside an `impl` block — Rust has no implicit `this`.

## Best Practices

- Use traits for shared behavior contracts, implementing them explicitly for each type that should satisfy them.
- Use trait default methods for genuinely common, overridable behavior, mirroring Java's interface default methods.
- Prefer composition (a struct holding another as a field) over trying to simulate inheritance — idiomatic Rust design leans on this even more heavily than idiomatic Go.

## Real-World Usage

Traits are used pervasively throughout Rust's standard library and ecosystem (`Display`, `Debug`, `Iterator`, `Clone` are all traits) — understanding `impl Trait for Type` is prerequisite to using or writing almost any real Rust code, and trait bounds on generics (Lesson 13) build directly on this foundation.

## Summary

- Rust has no classes/inheritance; structs hold data, `impl` blocks attach methods, and traits define behavior contracts.
- Unlike Go's implicit interface satisfaction, Rust traits require explicit `impl Trait for Type`.
- Traits can provide default method implementations, similar to Java 8+ interface defaults; composition (not embedding/promotion) is the only code-reuse mechanism for structs.

## Key Terms

- **`impl` block** — attaches methods (and associated functions) to a struct/enum.
- **Trait** — Rust's interface mechanism, requiring explicit implementation (`impl Trait for Type`), unlike Go's implicit satisfaction.
- **Default method (trait)** — a trait method with a provided implementation, usable as-is or overridden by implementing types.

## Interview Questions

1. **How does trait implementation in Rust differ from interface satisfaction in Go?**
   Go interfaces are satisfied implicitly/structurally — any type with the right method set automatically satisfies an interface, with no declaration required. Rust traits require an explicit `impl Trait for Type` block — simply having a method with a matching name and signature is not enough; the relationship must be explicitly declared, which is closer to Java/C#'s `implements`/`:` (though without any accompanying class/inheritance system).

2. **Does Rust support inheritance or struct field/method promotion like Go's embedding?**
   No to both — Rust has no inheritance at all, and no automatic field/method promotion from a contained struct the way Go's embedding provides. Composition (a struct holding another struct as an explicitly-named field, accessed via that field name) is the only structural code-reuse mechanism, combined with traits for shared behavior contracts across otherwise-unrelated types.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
