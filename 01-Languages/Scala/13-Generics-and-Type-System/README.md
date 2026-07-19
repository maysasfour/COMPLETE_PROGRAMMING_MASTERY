# 13 — Generics and the Type System

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Write parametrically polymorphic classes/methods with type parameters (`Box[A]`).
- Understand and use variance annotations: `+T` (covariant) and `-T` (contravariant).
- Use upper (`T <: Animal`) and lower (`B >: T`) type bounds.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

Scala's generics are more expressive than Java's (and much more expressive than Kotlin's, which this repository's Kotlin course covers with a simpler subset): type parameters can be annotated `+T` (covariant) or `-T` (contravariant), and can carry upper/lower bounds, letting the compiler enforce exactly which subtyping relationships between generic types are actually sound.

## Parametric Polymorphism

```scala
class Box[A](val value: A):
  def get: A = value
  def map[B](f: A => B): Box[B] = Box(f(value))
```

`Box[A]` works identically for any type `A` — `Box[Int]`, `Box[String]`, anything — without duplicating code.

## Covariance (`+T`): "Produces `T`, IS-A relationship preserved"

```scala
trait Container[+T]:
  def get: T
```

If `Cat <: Animal`, then `Container[Cat] <: Container[Animal]` — a `Container` of cats can stand in anywhere a `Container` of animals is expected. This is only sound because `+T` positions are **read-only** (`T` only ever appears as a return type, never a parameter type) — the compiler rejects a covariant type parameter used as a method parameter.

## Contravariance (`-T`): "Consumes `T`, IS-A relationship reversed"

```scala
trait Processor[-T]:
  def process(t: T): String
```

If `Cat <: Animal`, then `Processor[Animal] <: Processor[Cat]` — a processor that can handle *any* `Animal` can certainly handle the more specific `Cat`, so it's safe to use anywhere a `Processor[Cat]` is expected.

## Type Bounds

```scala
def describe[T <: Animal](t: T): String = s"describe: ${t.name} is an Animal"       // upper bound
def prepend[T, B >: T](item: B, list: List[T]): List[B] = item :: list              // lower bound
```

`T <: Animal` restricts `T` to Animal or its subtypes. `B >: T` requires `B` to be a supertype of `T` — used here so `prepend` can safely widen an immutable `List[Cat]` to a `List[Animal]` when prepending an unrelated `Animal`.

## Detailed Example

See [GenericsAndTypeSystem.scala](GenericsAndTypeSystem.scala) — a generic `Box[A]`, a covariant `Container[+T]` assigned from a more specific `Holder[Cat]` to a `Container[Animal]`-typed variable, a contravariant `Processor[-T]` assigned the reverse direction, an upper-bounded `describe` method, and a lower-bounded `prepend` that widens a `List[Cat]` to a `List[Animal]` — all verified to actually compile and run.

## Run It

```bash
cd 01-Languages/Scala/13-Generics-and-Type-System
scalac GenericsAndTypeSystem.scala
scala run . --main-class genericsAndTypeSystemDemo
```

## Expected Output

```
--- parametric polymorphism: Box[A] works for any A ---
intBox.get = 42, strBox.get = hello
intBox.map(_ * 2).get = 84

--- covariance (+T): Holder[Cat] IS-A Container[Animal] ---
catHolder.get = Cat(Whiskers)

--- contravariance (-T): Processor[Animal] IS-A Processor[Cat] ---
processing Cat(Tom)

--- upper type bound: T <: Animal ---
describe: Felix is an Animal

--- lower type bound: widening on prepend ---
animals = List(Animal(Generic), Cat(A), Cat(B))
```

## Common Mistakes

- Declaring a type parameter covariant (`+T`) but then using it as a method parameter type — this doesn't compile; the compiler enforces that covariant parameters only appear in "producer" (output) positions.
- Confusing which direction covariance/contravariance flips the subtyping relationship — covariance *preserves* it (`Cat <: Animal` implies `Container[Cat] <: Container[Animal]`), contravariance *reverses* it (`Processor[Animal] <: Processor[Cat]`).
- Adding variance annotations to a *mutable* container (e.g. a generic mutable box with a `set` method) — mutable containers generally must be invariant, since a `set` call would need `T` in a parameter position, which covariance forbids for good reason (it would allow storing the wrong subtype).

## Best Practices

- Make read-only/immutable generic containers covariant (`+T`) so they compose naturally with subtyping — Scala's own `List[+T]` is covariant for exactly this reason.
- Make "consumer" types (things that only take `T` as input, like a comparator or processor) contravariant (`-T`) when it matches the intended usage.
- Use type bounds (`<:`/`>:`) rather than casting when a generic method needs to constrain or safely widen a type parameter.

## Real-World Usage

Scala's standard collections are covariant (`List[+A]`, `Seq[+A]`), which is why a `List[Cat]` can be passed anywhere a `List[Animal]` is expected without an explicit cast — this variance design is precisely why `x :: xs` methods use the lower-bound trick (`def ::[B >: A](x: B): List[B]`) seen in `prepend` above, letting an immutable covariant list still support prepending a supertype element safely.

## Summary

- Generic classes/methods (`Box[A]`) provide parametric polymorphism without code duplication.
- `+T` (covariant) preserves subtyping between the generic and its type parameter; `-T` (contravariant) reverses it — both verified live via assignments that only compile because of the correct variance annotation.
- Upper bounds (`T <: X`) restrict a type parameter to a subtype of `X`; lower bounds (`B >: T`) require a supertype, used for safe widening.

## Key Terms

- **Covariance (`+T`)** — `Container[Sub] <: Container[Super]` when `Sub <: Super`; safe only for read-only (producer) positions.
- **Contravariance (`-T`)** — `Processor[Super] <: Processor[Sub]` when `Sub <: Super`; safe only for consumer (input) positions.
- **Type bound** — a constraint (`<:` upper, `>:` lower) restricting what concrete types a type parameter may be.

## Interview Questions

1. **Why can't a covariant type parameter (`+T`) appear as a method parameter type, and what was demonstrated to show why the restriction matters?** — If `+T` were allowed in an input position, a `Container[Cat]` (upcast to `Container[Animal]`, legal because of covariance) could then have a `Dog` passed into a `set(item: Animal)`-style method, silently corrupting the underlying `Cat`-only container with a `Dog` — a type-safety hole. The compiler rejects this at compile time rather than allowing it. This lesson's `Container[+T]` only exposes `get: T` (a producer position), which is why `Holder[Cat]` could be safely assigned to a `Container[Animal]`-typed variable and still only ever produce `Animal`-typed (actually `Cat`) values.
2. **What's the practical difference in when you'd choose `+T` vs `-T` for a generic type, illustrated by this lesson's two traits?** — Choose `+T` for types that only ever *produce* or return `T` (like `Container[+T]`'s `get`), enabling natural "a Container of cats is-a Container of animals" substitution. Choose `-T` for types that only ever *consume* `T` as input (like `Processor[-T]`'s `process`), enabling the reverse substitution — a `Processor` built to handle any `Animal` can stand in wherever a `Processor[Cat]` is needed, verified live by assigning `new AnimalProcessor` (a `Processor[Animal]`) directly to a `Processor[Cat]`-typed variable.

## Recommended Next Lesson

[14 — Concurrency](../14-Concurrency/README.md)
