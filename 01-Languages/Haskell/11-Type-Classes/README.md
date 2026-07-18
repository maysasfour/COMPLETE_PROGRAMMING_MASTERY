# 11 — Type Classes

[Back to course overview](../README.md) | [Previous: File Handling](../10-File-Handling/README.md)

## Learning Objectives

- Understand type classes as Haskell's actual mechanism for shared behavior across types — genuinely different from, though conceptually adjacent to, interfaces/protocols/traits in every other language in this repository.
- Use the standard `Eq`, `Ord`, `Show` type classes, including `deriving`.
- Define a custom type class and write `instance` declarations for it.

## Prerequisites

[10-File-Handling](../10-File-Handling/README.md)

## Concept: Type Classes vs. Interfaces/Traits

Haskell has **no classes/objects and no inheritance** in the OOP sense (Lesson 03/06 already established there's no mutable state to encapsulate in the first place). Its actual mechanism for "many different types share this behavior" is the **type class** — closest in spirit to Rust's `trait` (verified in the Rust course) or Go's/Java's interfaces, but with a genuinely important difference: a type class can be implemented for a type **after the fact**, from entirely separate code, without modifying the original type's definition or needing it to declare upfront which interfaces it implements. This is closer to Rust's trait system (which allows the same "implement for an existing type" pattern) than to Java's interfaces (which a class must declare `implements` at its own definition site).

```haskell
class Speaker a where
    speak :: a -> String

data Dog = Dog { dogName :: String }
data Cat = Cat { catName :: String }

instance Speaker Dog where
    speak d = dogName d ++ " says Woof!"

instance Speaker Cat where
    speak c = catName c ++ " says Meow!"

-- A function can be polymorphic over ANY type that has a Speaker instance:
announce :: Speaker a => a -> String
announce x = "Announcement: " ++ speak x
```

`Speaker Dog`'s instance could be written in a completely different module than `Dog`'s own definition — genuinely retroactive, the same capability the Swift course's protocol extensions and Rust's trait `impl`s both demonstrate, but here it's the *only* mechanism for shared behavior, not one option among several (there's no class hierarchy to reach for instead).

## `Eq`, `Ord`, `Show` — The Standard Type Classes

```haskell
data Priority = Low | Medium | High deriving (Eq, Ord, Show, Enum, Bounded)

-- `deriving` auto-generates a law-abiding instance when the derivation is
-- structural/mechanical -- here, Eq (structural equality), Ord (declaration
-- order = ranking, Low < Medium < High), Show (a sensible default string),
-- Enum (succ/pred/[Low ..]), and Bounded (minBound/maxBound) all apply for free.

comparePriorities :: Bool
comparePriorities = Medium > Low        -- True -- Ord derived from declaration order

allPriorities :: [Priority]
allPriorities = [minBound .. maxBound]  -- [Low,Medium,High] -- Bounded + Enum together
```

## A Custom Type Class with a Default Method

```haskell
class Describable a where
    describe :: a -> String
    describe _ = "No description available"   -- default implementation

    shortName :: a -> String                    -- no default -- every instance MUST provide this

data Book = Book { title :: String }

instance Describable Book where
    shortName b = title b
    -- describe is NOT overridden here -- it uses the default implementation
```

This is directly comparable to a Java `default` interface method, or a Rust trait method with a default body — the same idea, expressed as a type class default.

## Detailed Example

See [TypeClasses.hs](TypeClasses.hs).

## Verified Output

```bash
$ runghc TypeClasses.hs
speak (Dog "Rex") = Rex says Woof!
speak (Cat "Tom") = Tom says Meow!
announce (Dog "Rex") = Announcement: Rex says Woof!
Medium > Low: True
allPriorities = [Low,Medium,High]
show High = High
describe (Book "Learn You a Haskell") = No description available
shortName (Book "Learn You a Haskell") = Learn You a Haskell
```

## Common Mistakes

- **Trying to write an OOP-style class hierarchy to model this** — there's no `class`/`extends`/`implements` keyword doing what those words do in Java/C#/Python; `class` in Haskell declares a **type class** (a set of behaviors), not a data-bearing OOP class, and `instance` is how a type opts into that behavior, not an inheritance relationship.
- **Forgetting `deriving` only works when the derivation is genuinely mechanical** — `deriving Ord` on a type whose "natural" ordering isn't just declaration order (or field-by-field comparison for records) needs a hand-written `instance Ord` instead; blindly deriving can produce a technically-compiling but semantically wrong ordering.
- **Assuming a type class method without a default MUST be implemented by every instance** — it does; omitting a required method (no default) is a compile error, not a runtime surprise, a real advantage over an interface method silently defaulting to some questionable behavior.

## Best Practices

- Reach for `deriving` whenever the standard structural definition (equality, declaration-order ranking, a default string form) is genuinely what you want — writing it by hand is both more work and more error-prone for the mechanical cases.
- Design a type class around the smallest set of *required* methods, providing sensible defaults for everything else that can be derived from them (mirroring `Ord`'s real definition: only `compare` or `<=` is strictly required, with the rest derived from it internally).
- Prefer type classes over an ad-hoc "does this type have a `toString`-shaped function I can call by convention" pattern — a type class turns "shared behavior across types" into something the compiler checks and can polymorphically dispatch on.

## Real-World Usage

Type classes are how Haskell achieves nearly everything OOP-style interfaces, protocols, and traits achieve in other languages in this repository — `Show`/`Read` for serialization-adjacent behavior, `Eq`/`Ord` for comparison, `Functor`/`Applicative`/`Monad` (previewed in Lesson 09, foundational to real Haskell code well beyond this course's scope) for composable computation shapes — all without ever needing a class hierarchy, mutable objects, or inheritance.

## Summary

- Type classes (`class`/`instance`) are Haskell's mechanism for shared behavior across types — conceptually closest to Rust's traits (retroactive `impl` for existing types), not Java's classes/interfaces (which a type must declare at its own definition site).
- `deriving` auto-generates law-abiding `Eq`/`Ord`/`Show`/`Enum`/`Bounded` instances for the common, mechanical cases.
- A type class can declare default method implementations (used unless overridden) alongside required methods (which every instance must supply, checked at compile time).

## Key Terms

- **Type class** — a named set of behaviors (function signatures) that a type can opt into via an `instance` declaration; Haskell's actual analogue to interfaces/traits.
- **Instance** — a specific type's implementation of a type class's required behavior.
- **`deriving`** — automatic generation of a standard, mechanical instance (`Eq`, `Ord`, `Show`, `Enum`, `Bounded`) for a data type.

## Interview Questions

1. **How do Haskell type classes differ from Java-style interfaces?**
   Both let unrelated types share a common set of operations, checked at compile time. But a type class instance can be written entirely separately from the type's own definition — anyone can retroactively give an existing type a new type class instance from a different module, closer to Rust's trait `impl` blocks. A Java class, by contrast, must declare `implements SomeInterface` at its own definition site; you cannot retroactively make an existing, unrelated class implement a new interface without modifying (or subclassing) it.

2. **What does `deriving (Eq, Ord, Show)` actually do, and when should you write an instance by hand instead?**
   It auto-generates a standard, mechanical instance: `Eq` compares structurally (all fields equal), `Ord` ranks by declaration order for sum types (or field-by-field for records), and `Show` produces a default, roughly-constructor-shaped string. It's appropriate whenever that mechanical definition is genuinely the intended behavior. Write `Ord`/`Show` by hand instead when the natural ordering or display format doesn't match that mechanical default — e.g., a `Priority` type where you want display strings different from the constructor names, or an ordering based on a computed property rather than declaration order.

## Recommended Next Lesson

[12 — Higher-Order Functions](../12-Higher-Order-Functions/README.md)
