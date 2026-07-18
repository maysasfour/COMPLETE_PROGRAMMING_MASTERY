# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Understand and verify live that `String` is **literally** the type `[Char]` — a plain list of characters, not a distinct primitive type.
- See why that makes `String` slow for real-world text processing, and what `Text`/`ByteString` offer instead.
- Use core `String` functions, all of which are really just list functions (Lesson 07) in disguise.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept: `String` Is `[Char]` — Verified Live

This is not an analogy — it is the literal, checkable type definition. In `base`, `type String = [Char]`. Every list function from Lesson 07 (`length`, `++`, `map`, `filter`, list comprehensions, even `take`/`drop` on an "infinite string") already works on `String` with zero special-casing, because a `String` *is* a `[Char]`, not merely "like" one.

```haskell
greeting :: String
greeting = "Hello"

-- These are IDENTICAL, not just similar -- "Hello" IS ['H','e','l','l','o']:
greetingAsList :: [Char]
greetingAsList = ['H', 'e', 'l', 'l', 'o']

sameValue :: Bool
sameValue = greeting == greetingAsList   -- True -- literally the same value
```

Verified directly in `ghci`:

```
ghci> :type "Hello"
"Hello" :: String
ghci> :info String
type String = [Char]
```

Because `String` is `[Char]`, ordinary list operations apply directly:

```haskell
shout :: String -> String
shout = map toUpper                          -- map, from Lesson 07/12, works unchanged

countLetter :: Char -> String -> Int
countLetter c = length . filter (== c)       -- filter + length, same as any [a]

reversedGreeting :: String
reversedGreeting = reverse greeting          -- reverse, a plain list function
```

## The Cost: Why `String` Is Slow

Since `String` is a singly-linked list of `Char` (Lesson 07's cost profile applies directly), it inherits every one of a list's weaknesses for text specifically: each `Char` is (in the naive case) a separately heap-allocated cons cell, `length` is O(n), and concatenating many strings with `++` is the same O(n²)-if-abused trap as list append. For a short greeting this is irrelevant; for parsing a large file or building a large string incrementally, it's a real performance problem.

## The Practical Alternative: `Text` and `ByteString`

Real Haskell programs doing non-trivial text work use `Data.Text` (from the `text` package, Unicode-aware, packed/efficient) instead of `String`, and `Data.ByteString` (raw bytes, for binary data or when you specifically need byte-level control) instead of `[Word8]`. Both are **not** built on linked lists — they use packed, array-like internal representations, closer to how Rust's `String`/Go's `string` are actually stored.

```haskell
-- String (linked list of Char) -- fine for short, simple cases:
greetingStr :: String
greetingStr = "Hello, World!"

-- Text (packed, efficient) -- what real production code uses for text:
-- import qualified Data.Text as T
-- greetingText :: T.Text
-- greetingText = T.pack "Hello, World!"
```

`Data.Text`/`Data.ByteString` ship in packages (`text`, `bytestring`) rather than being syntactically built into the language the way `String` literals are — see this lesson's honesty note below on which of these were actually verified in this environment.

## Detailed Example

See [Strings.hs](Strings.hs).

## Verified Output

```bash
$ runghc Strings.hs
greeting == greetingAsList: True
shout "hello" = HELLO
countLetter 'l' "hello world" = 3
reversedGreeting = olleH
length "hello" = 5
"hello" ++ " " ++ "world" = hello world
words "the quick brown fox" = ["the","quick","brown","fox"]
unwords ["the","quick","brown","fox"] = the quick brown fox
```

```
$ ghci Strings.hs
ghci> :type "Hello"
"Hello" :: String
ghci> :info String
type String :: *
type String = [Char]
  	-- Defined in `GHC.Base'
```

## Honesty Note: `Text`/`ByteString` in This Environment

The `text` and `bytestring` packages are what real Haskell code uses instead of `String` for anything beyond trivial cases. `bytestring` ships bundled with GHC itself (part of the "boot" package set) and was confirmed available with no `cabal` install needed. `text` is **not** bundled with this GHC's boot packages and would need a `cabal install`/dependency resolution — see [16-Database-Access](../16-Database-Access/README.md)'s honesty note for the full, live-verified account of how slow/blocked Cabal package builds were in this specific environment. This lesson's own code sticks to `String` plus the bundled `bytestring`, and describes `Data.Text`'s API from documented knowledge rather than claiming a live-verified import that wasn't actually run.

## Common Mistakes

- **Assuming `String` is a fast, primitive type like Java's/Python's/Rust's string types** — it's a linked list, with all of Lesson 07's list cost trade-offs; don't reach for it in a hot loop processing large text.
- **String-concatenating in a loop/recursion with `++`** — same O(n²) trap as list append (Lesson 07); prefer `concat`/`unwords` on a full list of pieces, built once, rather than repeated incremental `++`.
- **Forgetting `Char` literals use single quotes and `String` literals use double quotes** — `'a'` is a `Char`, `"a"` is a `String` (a one-element `[Char]`); these are different types and not interchangeable without conversion (`[c]` wraps a `Char` into a one-element `String`).

## Best Practices

- Use `String` for short, simple, non-performance-critical text (error messages, small CLI output) — it's genuinely fine there, and every list function already works on it for free.
- Reach for `Data.Text` for anything involving real text processing at scale (parsing files, building large output, Unicode-sensitive work) in production code.
- Build a string from many pieces via `concat`/`unwords`/`Data.Text.Builder`-style tools rather than incremental `++`, for the same reason repeated list `++` is discouraged in Lesson 07.

## Real-World Usage

`String`'s simplicity (free list functions, no package dependency, no import needed) makes it the default for quick scripts and simple CLI tools; nearly every serious production Haskell codebase switches to `Data.Text` the moment text volume or performance matters, exactly the tension this lesson documents rather than glosses over.

## Summary

- `String` is not a distinct type — `type String = [Char]` is a literal type alias, verified directly with `:info String` in `ghci`.
- Because of this, every list function/operation from Lesson 07 works on `String` unchanged, but also inherits every one of a linked list's performance costs.
- `Data.Text`/`Data.ByteString` are the practical, packed alternatives real production code reaches for; this lesson documents which was actually usable in this specific environment rather than assuming.

## Key Terms

- **`String`** — a type alias for `[Char]`, literally a linked list of characters, not a distinct primitive type.
- **`Data.Text`** — a packed, efficient Unicode text type from the `text` package, the practical alternative to `String` for real text processing.
- **`Data.ByteString`** — a packed representation of raw bytes, bundled with GHC's boot packages, used for binary data or byte-level work.

## Interview Questions

1. **What is `String` actually defined as in Haskell, and what does that imply?**
   `type String = [Char]` — a literal type alias, not a distinct type. This means every list operation (`length`, `++`, `map`, `filter`, list comprehensions) works on `String` for free, but it also means `String` inherits a linked list's cost profile: O(n) length/random-access, and O(n²) risk from repeated `++` concatenation — a real performance liability for anything beyond small, simple text.

2. **Why would production Haskell code use `Data.Text` instead of `String`?**
   `Data.Text` uses a packed, array-like internal representation (not a linked list of individually-allocated `Char` cons cells), making it dramatically more efficient for real text processing — comparable to how Rust's `String` or Go's `string` are stored, rather than a Lisp-style linked list. `String` remains fine for short, simple, non-performance-critical text, but `Text` (from the `text` package) is the practical choice once volume or performance genuinely matters.

## Recommended Next Lesson

[09 — Error Handling](../09-Error-Handling/README.md)
