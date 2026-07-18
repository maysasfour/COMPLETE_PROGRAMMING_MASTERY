# 13 — Type System and Generics

[Back to course overview](../README.md) | [Previous: Higher-Order Functions](../12-Higher-Order-Functions/README.md)

## Learning Objectives

- Understand parametric polymorphism — Haskell's actual "generics" — and see that it's present **from day one**, not a later addition.
- Write generic functions and generic data types.
- Use typeclass constraints (`(Eq a) => ...`) to write functions generic over "any type with this capability," rather than "any type at all."

## Prerequisites

[12-Higher-Order-Functions](../12-Higher-Order-Functions/README.md)

## Concept: Generics From Day One

Several language courses in this repository (Go, Dart, Kotlin) had to explicitly note that generics were **added later** in that language's history, sometimes controversially. Haskell has no such story: parametric polymorphism — a function or data type defined generically over a type variable, with no runtime type information needed — has been part of the language since Haskell's very first standard. Every generic function you've already used in this course (`length :: [a] -> Int`, `map :: (a -> b) -> [a] -> [b]`, `Maybe a`/`Either a b` from Lesson 09) was already fully generic, with no special "generics" feature to opt into.

```haskell
-- `a` is a type variable -- this function works for ANY type `a` at all,
-- with NO runtime type check or reflection needed (unlike Java pre-generics
-- casting through Object, or Python's duck typing):
identity :: a -> a
identity x = x

firstOf :: (a, b) -> a
firstOf (x, _) = x

-- Generic data types -- a Stack that holds ANY type `a`:
newtype Stack a = Stack [a]

push :: a -> Stack a -> Stack a
push x (Stack xs) = Stack (x : xs)

pop :: Stack a -> Maybe (a, Stack a)
pop (Stack [])       = Nothing
pop (Stack (x : xs)) = Just (x, Stack xs)
```

## Typeclass Constraints: "Any Type With This Capability"

A plain type variable `a` (with no constraint) means "works for literally *any* type, so the function can't do anything type-specific with it at all" — `identity`, for instance, can't compare, print, or add its argument, precisely because it has no information at all about what `a` supports. A **constraint** narrows this to "any type that has a given type class instance":

```haskell
-- `(Eq a) =>` restricts `a` to types with an Eq instance -- now `==` is usable:
allEqual :: Eq a => [a] -> Bool
allEqual []       = True
allEqual (x : xs) = all (== x) xs

-- `(Ord a) =>` -- needs comparison, not just equality:
myMaximum :: Ord a => [a] -> a
myMaximum [x]      = x
myMaximum (x : xs) = max x (myMaximum xs)

-- Multiple constraints:
describeIfBigger :: (Ord a, Show a) => a -> a -> String
describeIfBigger x y
  | x > y     = show x ++ " is bigger than " ++ show y
  | otherwise = show y ++ " is bigger than or equal to " ++ show x
```

This is directly parallel to Rust's trait-bound generics (`fn largest<T: PartialOrd>(...)`, verified in the Rust course) — a constraint restricts which types are acceptable to exactly those with the needed capability, checked entirely at compile time, with zero runtime type inspection in either language.

## Detailed Example

See [Generics.hs](Generics.hs).

## Verified Output

```bash
$ runghc Generics.hs
identity 42 = 42
identity "hello" = hello
firstOf (1,"two") = 1
Stack after two pushes, popped once: Just (2,Stack [1])
allEqual [1,1,1] = True
allEqual [1,2,1] = False
myMaximum [3,7,2,9,4] = 9
describeIfBigger 5 3 = 5 is bigger than 3
```

## Common Mistakes

- **Assuming an unconstrained type variable can be compared/printed/added** — `identity :: a -> a` genuinely cannot do anything type-specific with its argument; trying to write `x == x` inside a function typed `a -> a` (no `Eq a =>` constraint) is a real compile error, since the compiler has no guarantee `a` supports `==` at all.
- **Over-constraining a function "just in case"** — adding `(Eq a, Ord a, Show a) =>` to a function that only ever compares with `==` unnecessarily narrows what types can call it; constrain to exactly what the function body actually uses.
- **Confusing Haskell's parametric polymorphism with Java's pre-generics `Object`-based "generics"** — Haskell's type variables carry no runtime type-erasure baggage or unchecked casts; the compiler fully verifies every use at compile time, with monomorphization (specialization per concrete type, much like Rust, contrasted with Java's full type erasure in the Rust course) typically happening for compiled code.

## Best Practices

- Constrain type variables to exactly the type classes a function's body actually needs — this both documents intent and maximizes how many types can call the function.
- Prefer parametric, constrained generic functions over writing near-duplicate versions for each concrete type — `myMaximum :: Ord a => [a] -> a` works for `Int`, `Double`, `String`, or any custom `Ord` type, with one definition.
- Reach for a generic data type (like `Stack a`) whenever a container's element type genuinely doesn't matter to the container's own logic — the push/pop logic above never inspects `a` itself, only moves it around.

## Real-World Usage

Nearly every function and data type in Haskell's standard library is generic in this sense — `Maybe a`, `[a]`, `map`, `foldr`, `Either a b` — because parametric polymorphism costs nothing (no runtime type checks, no boxing overhead beyond what the concrete type already needs) and was designed into the language from its first version, unlike several other languages in this repository that bolted generics on after establishing large non-generic codebases and ecosystems.

## Summary

- Parametric polymorphism (generic type variables like `a`) has been part of Haskell since its first standard — not a later addition, unlike Go/Dart/Kotlin's own generics histories.
- An unconstrained type variable (`a`) means "works for any type, and can do nothing type-specific with it"; a typeclass constraint (`Eq a =>`, `Ord a =>`) narrows this to "any type with that specific capability," directly parallel to Rust's trait-bound generics.
- Generic data types (`Stack a`) let a container's structure be defined once, independent of what element type it holds.

## Key Terms

- **Parametric polymorphism** — a function/type defined generically over a type variable, usable for any type substituted in, with no runtime type inspection needed.
- **Type variable** — a placeholder (conventionally `a`, `b`, ...) standing for "some type, to be determined at each call site," in a type signature.
- **Typeclass constraint** — `(ClassName a) =>` in a type signature, restricting a type variable to only types with that class's instance.

## Interview Questions

1. **What does it mean that Haskell has had generics "from day one," and why does that matter compared to Go's or Kotlin's history?**
   Parametric polymorphism (generic type variables in function/type signatures, like `[a]` or `Maybe a`) has been part of Haskell since its very first language standard — every list/`Maybe`/`Either` function has always been generic, with no separate "generics" feature ever bolted on. This matters because it means the entire standard library and ecosystem were designed around genericity from the start, unlike languages (Go pre-1.18, for instance) where a large non-generic ecosystem existed first and generics arrived later as an addition, sometimes requiring workarounds in code written before it existed.

2. **What's the difference between an unconstrained type variable (`a`) and a constrained one (`Eq a => a`)?**
   An unconstrained `a` means the function works for literally any type, but as a direct consequence can do *nothing* type-specific with values of that type — no comparison, no printing, no arithmetic — since the compiler has no guarantee any of those operations are supported. A constraint like `Eq a =>` restricts the function to only types that have an `Eq` instance, in exchange for being allowed to use `==`/`/=` inside the function body. This is directly analogous to Rust's trait-bound generics (`T: PartialOrd`), both checked entirely at compile time.

## Recommended Next Lesson

[14 — Laziness and Concurrency](../14-Laziness-and-Concurrency/README.md)
