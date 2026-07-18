# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Understand that in Haskell, **operators are just functions** with special infix syntax — nothing more.
- Call any infix operator as a regular prefix function with parentheses, and turn any two-argument function into an infix operator with backticks.
- Use `$` (function application, low precedence) and `.` (function composition) fluently — Haskell's two most distinctive "operators."

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Every other language in this repository treats operators (`+`, `==`, `&&`) as syntax the compiler/interpreter special-cases. Haskell doesn't: `+` is an ordinary function of type `Num a => a -> a -> a`, defined like any other function, just given permission to be *written* infix (between its arguments) instead of prefix (before them). This is verified directly below — `(+) 2 3` and `2 + 3` are exactly the same call.

This uniformity is why Haskell lets you define your own infix operators (`Data.Function`'s `&`, `Control.Applicative`'s `<*>`, and countless library-defined ones) with the same machinery ordinary functions use — there's no special "operator overloading" mechanism separate from ordinary function definition and type classes (Lesson 11).

## Operators Are Just Functions — Verified Live

```haskell
-- These two lines call the EXACT SAME function:
result1 = 2 + 3        -- infix syntax
result2 = (+) 2 3      -- prefix syntax -- parenthesizing an operator uses it as an ordinary function

-- Conversely, any ordinary two-argument function can be used infix with backticks:
addBackticks = 2 `plus` 3
  where plus a b = a + b
```

## Standard Operators

```haskell
-- Arithmetic
2 + 3       -- 5
2 - 3       -- -1
2 * 3       -- 6
7 `div` 2   -- 3   -- integer division is the NAMED function `div`, not `/`
7 `mod` 2   -- 1
7 / 2       -- 3.5 -- `/` is FRACTIONAL division, requires a Fractional type (not Int)

-- Comparison
2 == 3      -- False
2 /= 3      -- True   -- NOT `!=` -- Haskell uses `/=` for "not equal"
2 < 3       -- True

-- Boolean
True && False   -- False
True || False   -- True
not True        -- False
```

## `$` — Function Application (Lowest Precedence)

```haskell
-- Without $, parentheses are required to delay evaluation of the argument expression:
result1 = print (length (filter even [1..10]))

-- $ has the LOWEST possible precedence and is right-associative, so everything
-- to its right is evaluated first, then passed to what's on its left --
-- it's a parenthesis-eliminator, nothing more:
result2 = print $ length $ filter even [1..10]
```

`f $ x` is defined simply as `f x` — `$` does no actual work beyond its precedence/associativity, but that's exactly what makes it useful: it lets you drop a matching pair of parentheses whenever you'd otherwise write `f (g (h x))`.

## `.` — Function Composition

```haskell
-- (.) :: (b -> c) -> (a -> b) -> a -> c
-- (f . g) x  ==  f (g x)   -- composition, right-to-left, exactly like mathematical f∘g

isEvenLength :: [a] -> Bool
isEvenLength = even . length     -- point-free: no argument named at all (Lesson 06)

-- Equivalent, spelled out with an explicit argument:
isEvenLength' :: [a] -> Bool
isEvenLength' xs = even (length xs)
```

## Detailed Example

See [Operators.hs](Operators.hs).

## Verified Output

```bash
$ runghc Operators.hs
result1 == result2: True
7 `div` 2 = 3
7 `mod` 2 = 1
7 / 2 = 3.5
2 /= 3: True
5
$ eliminates parens, same result: True
isEvenLength [1,2,3,4]: True
isEvenLength [1,2,3]: False
```

## Common Mistakes

- **Writing `!=` instead of `/=`** — a genuine, common first mistake coming from nearly every other language in this repository; Haskell's "not equal" is `/=`.
- **Using `/` for integer division** — `/` requires a `Fractional` type and is a compile error on `Int`; use `div`/`mod` (or `quot`/`rem` for a variant that rounds toward zero rather than negative infinity on negative operands) for integers.
- **Overusing `$` where plain juxtaposition already works** — `$` is only needed to avoid a *matching pair* of parentheses around an argument expression; `f $ x` alone (no nested call on the right) gains nothing over plain `f x`.
- **Reading `.` composition left-to-right by habit** — `f . g` applies `g` first, then `f`, matching mathematical composition notation, the opposite of how many imperative "pipeline" operators (like the shell's `|` or the Elixir `|>` used elsewhere) read.

## Best Practices

- Reach for `$` specifically to eliminate a trailing matching parenthesis pair, especially at the end of a chain of function calls — `print $ sum $ map (*2) xs` reads cleanly left-to-right despite `$`'s right-to-left evaluation.
- Use `.` to build small, reusable pipelines from existing functions (Lesson 12 goes much deeper on this) rather than nesting explicit parenthesized calls.
- Reserve backtick-infix syntax (`` a `div` b ``) for functions whose *name* reads naturally as an infix word (`div`, `mod`, `elem`) — don't backtick everything just because you can.

## Real-World Usage

`$` and `.` appear in almost every non-trivial line of real Haskell code — `$` to avoid parenthesis pileup at the end of expressions, `.` to build point-free pipelines (Lesson 06). Recognizing both fluently is a prerequisite for reading almost any real Haskell source.

## Summary

- Operators are ordinary functions with infix syntax privileges — `(+) 2 3` and `2 + 3` are identical; any function can be used infix with backticks.
- `/=` is "not equal" (not `!=`); `div`/`mod` are integer division/remainder (not `/`, which requires `Fractional`).
- `$` is function application at the lowest possible precedence — a parenthesis-eliminator with no other behavior.
- `.` is function composition, right-to-left, `(f . g) x == f (g x)`.

## Key Terms

- **Infix function** — any function called with syntax `a `name` b`or a symbolic operator between its two arguments, rather than prefix (`f a b`).
- **`$`** — the function-application operator; lowest precedence, right-associative, eliminates a matching parenthesis pair.
- **`.`** — function composition; `(f . g) x == f (g x)`.

## Interview Questions

1. **In what sense are Haskell's operators "just functions"?**
   An operator like `+` is defined exactly like any other function (`(+) :: Num a => a -> a -> a`), just with infix call syntax by default. Wrapping it in parentheses, `(+)`, uses it as an ordinary prefix function — `(+) 2 3` and `2 + 3` call the identical function. Conversely, any ordinary two-argument function can be called infix by surrounding its name with backticks. There's no separate "operator" mechanism in the language beyond this naming/syntax convention.

2. **What does `$` actually do, and why is it useful?**
   `f $ x` is defined as exactly `f x` — `$` performs no computation of its own. What makes it useful is its precedence (the lowest of any operator) and right-associativity: everything to its right is treated as one argument, evaluated first, letting you write `f $ g $ h x` instead of `f (g (h x))`, eliminating a matching pair of parentheses per `$` used.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
