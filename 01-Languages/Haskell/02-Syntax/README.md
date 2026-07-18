# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Read Haskell's significant-whitespace ("layout") rule and why no semicolons are needed.
- Distinguish `where` clauses (attached to a definition, evaluated once, scoped to it) from `let` expressions (usable anywhere an expression is).
- Recognize `--` line comments and `{- -}` block comments.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

Haskell uses **the layout rule**: indentation itself determines grouping, the same way Python's colon-and-indent blocks replace C-style `{ }`/`;`. There is no `main() { ... }` block delimiter and no statement-terminating semicolon anywhere in ordinary Haskell code — a new line at the *same* indentation as the first token of a block starts a new item in that block; a line indented *further* continues the previous item.

This matters more in Haskell than in Python, because Haskell has no loops or explicit statement sequencing to fall back on (see [05-Control-Flow](../05-Control-Flow/README.md)) — layout is doing real structural work for `where`/`let`/`do`/`case` blocks, not just cosmetic grouping of otherwise-independent statements.

## No Semicolons Needed

```haskell
-- Semicolons DO exist as an explicit alternative, but nobody writes them this way:
main = do { putStrLn "a"; putStrLn "b" }

-- Idiomatic layout-based form -- indentation alone separates the two actions:
main = do
    putStrLn "a"
    putStrLn "b"
```

## `where` vs. `let`

Both introduce local bindings, but they differ in scope and where they're legal to write:

```haskell
-- `where` attaches to a function definition (or a guard set, see Lesson 05)
-- and is scoped to that ENTIRE definition, including all of its guards.
circleArea :: Double -> Double
circleArea r = pi * rSquared
  where
    rSquared = r * r   -- visible throughout circleArea's definition

-- `let` is an EXPRESSION -- usable anywhere a value is expected, including
-- nested inside another expression, and scoped only to what follows it.
circleAreaLet :: Double -> Double
circleAreaLet r =
    let rSquared = r * r
    in pi * rSquared
```

A practical rule of thumb used throughout this course: reach for `where` when the helper binding belongs to the *whole* function (especially if multiple guards need it), and `let ... in ...` when the binding is local to one specific sub-expression.

## Comments

```haskell
-- This is a line comment, like Python's #

{- This is a block comment,
   which can span multiple lines,
   like Python's triple-quoted strings used as comments. -}

{- Block comments {- can even nest -} in Haskell, unlike C's /* */. -}
```

## Detailed Example

See [Syntax.hs](Syntax.hs).

## Verified Output

```bash
$ runghc Syntax.hs
a
b
Area (where): 78.53981633974483
Area (let):   78.53981633974483
```

## Common Mistakes

- **Misaligning a `do`/`where`/`let` block by even one column** — this is a genuine, common compile error (`parse error (possibly incorrect indentation or mismatched brackets)`), not a style nitpick; the layout rule is load-bearing, not cosmetic.
- **Using `let ... in` inside a `do` block the same way as a bare `let`** — inside `do`, a bare `let x = ...` (no `in`) introduces a binding for the rest of that `do` block; adding `in` there is either unnecessary or a sign of confusing the two forms.
- **Assuming `where` bindings are re-evaluated per guard** — a `where` clause's bindings are shared, lazily-evaluated-once across the whole definition (including every guard), not recomputed per branch.

## Best Practices

- Pick one consistent indentation width (2 or 4 spaces; this course uses 4) and never mix tabs with spaces — GHC's layout algorithm treats a tab as a jump to the next multiple-of-8 column, a classic source of "my editor shows this aligned but GHC disagrees" bugs.
- Prefer `where` for bindings shared across multiple guards on the same function; prefer `let` for a one-off local binding inside a single expression or `do` step.
- Use block comments (`{- -}`) for temporarily disabling a chunk of code during development, and line comments (`--`) for everything else — this mirrors nearly every other language in this repository.

## Real-World Usage

Every real Haskell codebase relies on layout for `do`/`where`/`let`/`case` blocks — there is no alternative brace-based style in common use, unlike languages (Python, Scala) where brace-free layout is one option among several. Getting comfortable reading/writing correctly-indented Haskell is a prerequisite for reading any real Haskell source at all.

## Summary

- Indentation (the "layout rule") replaces semicolons/braces for grouping — no statement terminators exist in idiomatic code.
- `where` attaches to and is scoped across an entire function definition (including all its guards); `let ... in ...` is a plain expression, usable anywhere, scoped only to what follows.
- `--` for line comments, `{- -}` for (nestable) block comments.

## Key Terms

- **Layout rule** — Haskell's indentation-sensitive parsing, replacing explicit `{ ; }` block/statement delimiters.
- **`where` clause** — local bindings scoped to an entire function definition (all guards included).
- **`let` expression** — local bindings usable as an expression anywhere, scoped only to what follows.

## Interview Questions

1. **How does Haskell know where one statement ends and the next begins, with no semicolons?**
   Through the layout rule: tokens aligned at the same column as the first token of a block are treated as separate items in that block; anything indented further continues the previous item. GHC can also insert explicit `{ ; }` if you write them yourself, but idiomatic code relies entirely on layout.

2. **When would you choose `where` over `let`, or vice versa?**
   `where` when a helper value needs to be visible across an entire function's definition, especially shared across multiple guard branches (Lesson 05) — it's defined once, attached to the function, not to any one branch. `let ... in ...` when the binding is local to a single expression and doesn't need that wider scope, since `let` is an ordinary expression usable anywhere a value is expected, including deeply nested inside another expression.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
