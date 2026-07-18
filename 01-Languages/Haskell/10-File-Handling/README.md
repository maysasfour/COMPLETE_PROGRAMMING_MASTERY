# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read and write files with `readFile`/`writeFile`/`appendFile`.
- Understand `IO` as an ordinary type — an `IO String` is a *description* of an action that, when performed, produces a `String`, not the string itself.
- Understand Haskell's famous purity boundary: why a function's type signature honestly discloses whether it can perform I/O, unlike every other language in this repository.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept: `IO` Makes Impurity Visible in the Type

Every other language course in this repository lets *any* function silently read a file, hit the network, or print to the console — nothing in a Python `def`, a Java method signature, or a C# method signature tells you, just from its type, whether calling it might do I/O. Haskell is different: a value of type `IO String` isn't a `String` — it's a description of an action that, when actually performed (by the runtime, ultimately from `main`), will produce a `String`. **You cannot get a plain `String` out of an `IO String` except by performing it inside another `IO` action** (via `<-` in a `do` block). This is enforced by the type checker, not a convention.

```haskell
readGreeting :: IO String        -- NOT a String -- a DESCRIPTION of an action producing one
readGreeting = readFile "greeting.txt"

-- This will NOT type-check -- you cannot silently "unwrap" an IO String into a String:
-- shout :: String -> String
-- loud = shout readGreeting        -- ERROR: couldn't match `IO String` with `String`

-- The only way to get the String out is inside another IO action:
main :: IO ()
main = do
    greeting <- readGreeting        -- `<-` performs the IO action, binds the resulting String
    putStrLn (map toUpper greeting) -- NOW it's a plain String, usable by ordinary functions
```

Contrast this with, say, Python: `open("file.txt").read()` can be called from literally anywhere, with nothing in a function's signature warning a caller that it touches the filesystem. In Haskell, if a function's type doesn't mention `IO`, it is **guaranteed, by the compiler, to do no I/O and have no side effects at all** — a genuinely strong, checked guarantee no other language in this repository provides at the type level.

## `readFile`/`writeFile`/`appendFile`

```haskell
writeFile "notes.txt" "first line\n"          -- creates/overwrites the file
appendFile "notes.txt" "second line\n"        -- appends without overwriting
contents <- readFile "notes.txt"              -- IO String -- lazy read, see caveat below
putStrLn contents
```

## A Real Caveat: Lazy I/O

`readFile`'s `IO String` result is, true to Lesson 07/14's laziness, read **lazily** — the file may not be fully read until its contents are actually forced (e.g., by `putStrLn` or `length`). This has a genuine, well-known practical consequence: if you `readFile` a path and then immediately try to `writeFile` to the *same* path before the lazy read has been fully forced, you can hit a file-locking error, because the read handle may still be open when the write attempts to happen. [FileHandling.hs](FileHandling.hs) verifies safe usage (write, then a separate read, contents fully consumed via `putStrLn` before the file handle would matter for a subsequent write) rather than the unsafe same-path immediate-overwrite pattern.

## Detailed Example

See [FileHandling.hs](FileHandling.hs).

## Verified Output

```bash
$ runghc FileHandling.hs
Wrote notes.txt
Contents after write:
first line
Contents after append:
first line
second line
Uppercased:
FIRST LINE
SECOND LINE
```

The raw file content was independently confirmed with `cat notes.txt`, matching what's shown above exactly (`first line` / `second line`, no corruption from the read-then-append sequence).

## Common Mistakes

- **Assuming a function returning `IO String` gives you a `String` directly** — it doesn't; only `<-` inside another `IO` action (ultimately connected to `main`) performs it and extracts the value. This is a genuine, common first confusion coming from any language where I/O is implicit.
- **`readFile`ing and immediately `writeFile`ing the same path**, expecting the write to see fully "old" content or not conflict — due to lazy I/O, this can throw a real file-in-use error; force full consumption of the read (or use `Data.Text.IO`'s strict variants, or `!` a fully-evaluated binding) before overwriting the same path.
- **Forgetting file operations can fail** (missing file, permissions) and not handling the resulting exception — `readFile` on a nonexistent path throws an `IOException`; wrap it with `Control.Exception.try`/`catch` (previewed in Lesson 09) rather than letting the whole program crash uncontrolled, if graceful handling matters.

## Best Practices

- Keep the `IO`-touching parts of a program as small and close to `main` as possible; do as much real logic as you can in plain, non-`IO` functions (Lesson 03's pure bindings) that `IO` code merely calls with already-read values — this is often summarized as "functional core, imperative shell."
- Prefer `Data.Text.IO`'s `readFile`/`writeFile` (from the `text` package) over `Prelude`'s `String`-based ones for real text-processing work, for the same reasons Lesson 08 prefers `Text` over `String` generally.
- Handle file-operation exceptions explicitly (`try`/`catch`) whenever a missing file or permissions issue is a genuinely expected possibility, rather than letting an uncaught `IOException` crash the whole program.

## Real-World Usage

The `IO` type's visibility is precisely why Haskell code is unusually easy to reason about and test: a function with no `IO` in its type is *guaranteed* to be a pure, deterministic computation with no hidden side effects — testable by simply calling it with inputs and checking outputs (Lesson 18), no mocking a filesystem or database required, unlike testing code in a language where any function might secretly do I/O.

## Summary

- `readFile`/`writeFile`/`appendFile` do ordinary file I/O, but their type (`IO String`, `IO ()`) marks them as impure, checked by the compiler.
- An `IO a` value is a *description* of an action producing an `a`, not the `a` itself — only `<-` inside another `IO` action performs it.
- A function whose type contains no `IO` is guaranteed pure by the type system — a strong guarantee no other language in this repository provides at the type-checked level.
- Lazy I/O is a real, practical caveat: reading and immediately overwriting the same file path can conflict since the read may not be fully forced yet.

## Key Terms

- **`IO a`** — a type representing a description of an action that, when performed, produces a value of type `a`; not the value itself.
- **Purity boundary** — the compiler-enforced separation between pure functions (no `IO` in their type, guaranteed no side effects) and `IO` actions (may perform side effects, always visibly marked).
- **Lazy I/O** — `readFile`'s result is read on demand as its content is forced, not eagerly up front, with real practical caveats around same-file read/write ordering.

## Interview Questions

1. **Why is `IO String` not the same thing as a `String` in Haskell, and why does that matter?**
   `IO String` is a value describing an action that, when performed, will produce a `String` — it is not itself a `String` and cannot be used wherever a plain `String` is expected. Getting the actual `String` out requires performing the action, which can only happen inside another `IO` action (via `<-`), ultimately connected to `main`. This matters because it makes impurity visible and compiler-checked: a function whose type has no `IO` in it is *guaranteed* to have no side effects, a strong guarantee most other languages don't offer at the type level.

2. **What's a real, practical caveat of Haskell's lazy file I/O?**
   `readFile`'s `IO String` result is read lazily — the file's contents may not be fully read until something actually forces them (printing, computing `length`, etc.). A common resulting mistake is reading a file and then immediately trying to overwrite the *same* path before the lazy read has been fully consumed, which can produce a real file-in-use/locking error, since the read handle may still logically be open. Fully forcing the read's result (or reading it strictly) before overwriting the same path avoids this.

## Recommended Next Lesson

[11 — Type Classes](../11-Type-Classes/README.md)
