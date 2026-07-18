# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Understand Haskell has no exceptions in the conventional try/catch sense for ordinary, everyday error handling.
- Use `Maybe a` for "a value that might be absent" and `Either e a` for "a value or an explanation of why not," directly comparable to Rust's `Option<T>`/`Result<T, E>`.
- Recognize partial functions (`head`, `fromJust`) as a real anti-pattern, and prefer total functions or explicit `Maybe`/`Either` handling instead.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Haskell **does** have an exception mechanism (`throw`/`catch`, in `Control.Exception`, used for genuinely exceptional situations like a missing file or a network failure — see [10-File-Handling](../10-File-Handling/README.md)), but idiomatic, everyday error handling for "this operation might not succeed" uses ordinary values instead: `Maybe a` and `Either e a`. This is directly comparable to the Rust course's `Option<T>`/`Result<T, E>` — in fact `Maybe`/`Either` are Rust's actual ancestors: Rust's `Option`/`Result` were explicitly modeled on Haskell's.

```haskell
data Maybe a = Nothing | Just a      -- (this is how it's actually defined in base)
data Either a b = Left a | Right b   -- conventionally: Left = error/failure, Right = success ("right" = correct)
```

## `Maybe` — A Value That Might Be Absent

```haskell
safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide a b = Just (a `div` b)

-- Pattern matching, exactly like Rust's `match` on `Option`:
describe :: Maybe Int -> String
describe Nothing  = "no result"
describe (Just x) = "result: " ++ show x

-- Or the combinator style, avoiding explicit pattern matching:
doubled :: Maybe Int -> Maybe Int
doubled = fmap (* 2)          -- fmap over Maybe: transforms the Just, leaves Nothing alone

withDefault :: Maybe Int -> Int
withDefault = maybe 0 id      -- `maybe defaultVal f m` -- like Rust's `.unwrap_or(default)`
```

## `Either` — A Value or an Explanation of Why Not

```haskell
data ValidationError = TooYoung | TooOld deriving Show

validateAge :: Int -> Either ValidationError Int
validateAge age
  | age < 0   = Left TooYoung
  | age > 150 = Left TooOld
  | otherwise = Right age

-- Either's Functor/fmap only transforms the RIGHT (success) case, exactly
-- mirroring how Rust's `Result::map` leaves `Err` untouched:
ageDoubled :: Either ValidationError Int -> Either ValidationError Int
ageDoubled = fmap (* 2)
```

This is directly parallel to Rust's `Result<T, E>`: `Left`/`Err` for failure, `Right`/`Ok` for success — with the mnemonic that "right" also means "correct."

## `error`/Partial Functions: An Anti-Pattern

```haskell
-- `head` is PARTIAL -- it's undefined (crashes) for an empty list:
-- head ([] :: [Int])   -- *** Exception: Prelude.head: empty list

-- The safe, TOTAL alternative -- handles every possible input, including []:
safeHead :: [a] -> Maybe a
safeHead []      = Nothing
safeHead (x : _) = Just x
```

`head`, `tail`, `fromJust`, `(!!)` with an out-of-range index, and `error "message"` itself are all **partial functions** — functions that don't handle every value of their input type and crash at runtime on the cases they don't handle. Lesson 07 already hit GHC's own `-Wx-partial` warning on `tail` live; Lesson 19 returns to this as the course's central anti-pattern/fix pair.

## Detailed Example

See [ErrorHandling.hs](ErrorHandling.hs).

## Verified Output

```bash
$ runghc ErrorHandling.hs
safeDivide 10 2 = Just 5
safeDivide 10 0 = Nothing
describe (safeDivide 10 2) = result: 5
describe (safeDivide 10 0) = no result
doubled (Just 5) = Just 10
withDefault Nothing = 0
validateAge (-1) = Left TooYoung
validateAge 200 = Left TooOld
validateAge 30 = Right 30
safeHead [1,2,3] = Just 1
safeHead ([] :: [Int]) = Nothing
head [] would crash: True
```

## Common Mistakes

- **Reaching for `fromJust`/`head`/`(!!)` reflexively instead of pattern matching or `maybe`/`either`** — these crash on exactly the inputs (`Nothing`, `[]`, an out-of-range index) that `Maybe`/`Either` exist to force you to handle explicitly; using them defeats the whole point of a type system that can represent absence/failure as an ordinary value.
- **Confusing `Left`/`Right`'s convention** — by convention (not compiler-enforced), `Left` is failure and `Right` is success; code that inverts this convention without a very good reason will confuse anyone reading it who expects the standard mnemonic ("right" = "correct").
- **Forgetting `fmap`/`Functor` on `Maybe`/`Either` only touches the "success" side** — `fmap f (Left e)` is still `Left e` unchanged; `f` is never even called, exactly mirroring Rust's `Result::map` leaving `Err` untouched.

## Best Practices

- Prefer total functions (handle every input, including edge cases) over partial ones; when a case genuinely can't produce a value, say so explicitly with `Maybe`/`Either` rather than crashing.
- Use `Maybe` when there's no useful information about *why* something is absent; use `Either e a` (with a meaningful `e`) when the caller needs to know why an operation failed, not just that it did.
- Chain `Maybe`/`Either` computations with `do`-notation or `>>=` (both are `Monad` instances, briefly previewed here, covered more deeply in real-world Haskell resources beyond this course's scope) rather than nested pattern matching, once a chain gets more than one or two steps deep.

## Real-World Usage

`Maybe`/`Either` (and their combinators — `fmap`, `maybe`, `either`, `>>=`) are the backbone of real Haskell error handling — parsers, validators, and any "this operation might not succeed" function return one of these rather than throwing, making every possible failure visible directly in the function's type signature, checked by the compiler at every call site.

## Summary

- Haskell has no everyday try/catch exceptions — `Maybe a` (`Nothing`/`Just a`) represents optional absence, `Either e a` (`Left e`/`Right a`) represents failure-with-reason vs. success, directly paralleling Rust's `Option<T>`/`Result<T, E>` (which were explicitly modeled on these).
- `fmap` over `Maybe`/`Either` only transforms the success case (`Just`/`Right`), leaving failure (`Nothing`/`Left`) untouched.
- Partial functions (`head`, `fromJust`, unchecked `(!!)`) crash on inputs they don't handle — a genuine anti-pattern this course returns to directly in Lesson 19.

## Key Terms

- **`Maybe a`** — `Nothing` or `Just a`; represents a value that might be absent, with no explanation of why.
- **`Either e a`** — `Left e` or `Right a`; represents failure-with-a-reason (`Left`) or success (`Right`), by convention.
- **Partial function** — a function undefined (crashes) for some inputs of its argument type, like `head` on `[]`.
- **Total function** — a function defined for every possible input of its argument type, crashing on none of them.

## Interview Questions

1. **How does Haskell's `Maybe`/`Either` compare to Rust's `Option`/`Result`?**
   They're essentially the same idea under different names, and not by coincidence — Rust's `Option<T>`/`Result<T, E>` were explicitly modeled on Haskell's `Maybe a`/`Either e a`. `Nothing`/`Some`↔`Just`, `None`↔`Nothing`, `Ok`↔`Right`, `Err`↔`Left`. Both force the caller to explicitly handle the failure/absence case (via pattern matching, or combinators like `maybe`/`fmap`/Rust's `.map()`/`.unwrap_or()`) rather than allowing an unchecked, possibly-uncaught exception to propagate silently.

2. **What's a "partial function," and why is `head` considered an anti-pattern?**
   A partial function is one that isn't defined for every value of its input type — it crashes (or is otherwise undefined) for some inputs. `head :: [a] -> a` is partial because it crashes on `[]`, an entirely valid `[a]` value it simply doesn't handle. The fix is a total function like `safeHead :: [a] -> Maybe a`, which makes the "list might be empty" case an explicit, compiler-checked part of the return type instead of a runtime crash waiting to happen.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
