# 11 — OOP

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Define structs with methods (Go's replacement for classes).
- Use interfaces — satisfied **structurally/implicitly**, with no `implements` keyword.
- Use struct embedding for composition, Go's replacement for inheritance.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md) and [10-File-Handling](../10-File-Handling/README.md)

## Concept

Go has **no classes, no inheritance, and no constructors** as language features — a deliberate, foundational design choice, not a missing feature. Instead: **structs** hold data, **methods** attach behavior to a struct (or any named type), **interfaces** define behavior contracts satisfied **implicitly** (structurally, like TypeScript's structural typing, but for method sets specifically — no `implements` keyword exists), and **struct embedding** provides composition-based code reuse in place of inheritance.

## Structs and Methods

```go
type Animal struct {
	Name string
}

func (a Animal) Speak() string { // method: a function with a "receiver" (a Animal)
	return a.Name + " makes a sound"
}

func NewAnimal(name string) Animal { // idiomatic "constructor" -- just a plain function, no special syntax
	return Animal{Name: name}
}
```

A method's **receiver** (`(a Animal)`) is conceptually similar to `this`/`self` in other languages, but is an explicit, named parameter — there is no implicit `this`. A **value receiver** (`(a Animal)`) gets a copy; a **pointer receiver** (`(a *Animal)`) can modify the original, directly connecting back to Go's overall value-vs-pointer semantics.

## Interfaces: Implicit, Structural Satisfaction

```go
type Speaker interface {
	Speak() string
}

func Announce(s Speaker) {
	fmt.Println(s.Speak())
}

Announce(Animal{Name: "Rex"}) // Animal satisfies Speaker automatically -- no "implements Speaker" anywhere
```

Any type with a `Speak() string` method automatically satisfies `Speaker` — there is no `implements` keyword, no explicit declaration of intent anywhere near the type's definition. This is Go's version of structural typing (similar in spirit to TypeScript's structural interfaces, Lesson 02 of the TypeScript course, but applied specifically to method sets rather than general object shapes).

## Struct Embedding: Composition Over Inheritance

```go
type Dog struct {
	Animal      // embedded -- Dog "has an" Animal, and PROMOTES its fields/methods
	Breed string
}

d := Dog{Animal: Animal{Name: "Rex"}, Breed: "Labrador"}
fmt.Println(d.Speak()) // "Rex makes a sound" -- Animal's method is promoted onto Dog directly
fmt.Println(d.Name)      // "Rex" -- Animal's field is promoted too
```

Embedding is **not** inheritance — `Dog` doesn't "become an" `Animal` polymorphically the way a Java/C# subclass does; it simply gets `Animal`'s fields and methods "promoted" to be directly accessible on `Dog`, a mechanical composition feature rather than a type-hierarchy relationship. `Dog` can override `Speak()` by defining its own, but there's no `virtual`/`override` concept — a new method with the same name on the outer type simply shadows the embedded one.

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints a struct's method called directly, the same struct passed to a function accepting an interface it satisfies implicitly, and struct embedding promoting both a field and a method from `Animal` onto `Dog`.

## Common Mistakes

- Looking for `class`/`extends`/`implements` keywords — none exist; structs+methods, interfaces (implicit), and embedding (composition) are the actual mechanisms.
- Assuming embedding is inheritance — it's promotion of fields/methods for convenience, not a polymorphic "is-a" relationship; there's no dynamic dispatch the way a virtual method call has in Java/C#/C++.
- Using a value receiver when the method needs to mutate the struct — a value receiver operates on a copy; use a pointer receiver (`*T`) to actually modify the original.

## Best Practices

- Prefer small, focused interfaces (Go's standard library favors single-method interfaces like `io.Reader`/`io.Writer`) over large ones.
- Use pointer receivers consistently for a type if any of its methods need to mutate state, for consistency even on methods that don't strictly need to.
- Use embedding for genuine "has-a"/composition relationships, not as a workaround to simulate inheritance.

## Real-World Usage

Go's small-interface philosophy (`io.Reader`, `io.Writer`, `sort.Interface`) is pervasive throughout the standard library and is frequently cited as one of Go's best design decisions — it enables extremely flexible, decoupled code, since any type satisfying a tiny interface (often just one method) can be used anywhere that interface is expected, with zero explicit declaration needed.

## Summary

- Go has no classes/inheritance/constructors as language features — structs+methods, implicit interfaces, and struct embedding are the actual mechanisms.
- Interfaces are satisfied structurally/implicitly — no `implements` keyword; any type with the right method set automatically satisfies an interface.
- Struct embedding promotes an embedded type's fields/methods onto the outer type — composition, not inheritance; there's no polymorphic dispatch.

## Key Terms

- **Receiver** — the explicit, named parameter a method is attached to (`func (a Animal) Speak()`), Go's equivalent of `this`/`self`.
- **Struct embedding** — including one struct/interface as an unnamed field within another, promoting its fields/methods.
- **Implicit interface satisfaction** — a type automatically satisfies an interface simply by having the required methods, with no explicit declaration.

## Interview Questions

1. **How does Go achieve interface satisfaction without an `implements` keyword?**
   Structurally and implicitly — any type that has all the methods an interface requires automatically satisfies that interface, with no explicit declaration anywhere near the type's definition. This is checked at compile time (when the type is actually used somewhere requiring that interface), not tracked as an explicit relationship the way Java's/C#'s `implements`/`:` declarations are.

2. **Is struct embedding the same as inheritance?**
   No — embedding promotes an embedded type's fields and methods to be directly accessible on the outer type (for convenience), but it is not a polymorphic "is-a" relationship. There's no dynamic dispatch: if the outer type defines its own method with the same name, it simply shadows the embedded one at compile time; there's no virtual-method-style resolution based on a value's "actual type" the way Java/C#/C++ inheritance provides.

## Recommended Next Lesson

[12 — Functional Concepts](../12-Functional-Concepts/README.md)
