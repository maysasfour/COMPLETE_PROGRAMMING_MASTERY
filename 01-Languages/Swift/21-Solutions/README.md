# 21 — Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

> ## Genuinely Compiled and Run
>
> Unlike lessons 01–19 of this course (disclosed as unverified — see the [course README](../README.md)), every solution file in this folder **was actually compiled and run** against a real Swift 6.1.2 toolchain (`x86_64-unknown-windows-msvc`) discovered in this environment. Output shown below is captured from real execution, not predicted. See "How This Was Verified" at the end of this file for the exact toolchain setup that made this possible.

Seven worked solutions, one per exercise in [20-Exercises](../20-Exercises/README.md). Each solution below shows the real, captured output from actually running `solution-0N.swift` (`swiftc solution-0N.swift -o solution-0N.exe`, then running the `.exe`).

## Solution 01 — Safe Contact Lookup

See [solution-01.swift](solution-01.swift). The key insight: `contacts[name]` on a `[String: String?]` returns `String??` — the outer optional from Dictionary subscripting itself (present/absent key), the inner optional from the dictionary's own declared value type (`String?`, present/absent email). Two `guard let`s peel one layer each, in order.

**Real captured output:**

```
Alice: alice@example.com
Bob has no email on file
Dave is not a contact
```

## Solution 02 — Struct vs. Class Aliasing

See [solution-02.swift](solution-02.swift).

**Real captured output:**

```
--- struct value semantics ---
original: (1, 1)
second:   (99, 1)

--- class reference semantics ---
classOriginal: (99, 1)
classSecond:   (99, 1)

--- movedRight leaves its by-value argument untouched ---
arg (unchanged):    (5, 5)
result (arg.x + 1): (6, 5)
```

`original` stays `(1, 1)` after `second.x` is mutated — proof of struct value semantics (a copy, not a shared reference). `classOriginal` and `classSecond` both show `(99, 1)` after mutating through `classSecond` — proof of class reference semantics: both `let` bindings refer to the *same* underlying object, so mutating a stored property through either one is visible through both. This is exactly the kind of aliasing bug Swift's `struct`-by-default idiom (Lesson 11) is designed to avoid when reference semantics aren't actually wanted.

## Solution 03 — Protocol Extensions and Retroactive Conformance

See [solution-03.swift](solution-03.swift).

**Real captured output:**

```
--- Int (retroactive conformance) ---
10.summed(with: [20, 30, 40]) = 100

--- Double (retroactive conformance) ---
1.5.summed(with: [2.5, 3.0]) = 7.0

--- Money (custom type, no Money-specific summed) ---
Money.zero.summed(with: moneyValues) = $17.75
```

Neither `Int`, `Double`, nor `Money` implements `summed(with:)` itself — all three get it entirely for free from the `Summable` protocol extension's default implementation, which only needs `+` and `.zero` (both protocol requirements) to work generically over `Self`.

## Solution 04 — Enum with Associated Values: NetworkResult

See [solution-04.swift](solution-04.swift).

**Real captured output:**

```
Success: ["a", "b"]
Failure 404: Not Found
Loading...
```

**Exhaustiveness proof (real, reproduced compiler error):** adding a fourth case (`case cancelled`) to `NetworkResult` and recompiling `describe`'s unmodified `switch` against it produced this real error, captured verbatim:

```
error: switch must be exhaustive
    switch result {
    ^
note: add missing case: '.cancelled'
```

No code path in `describe` executes at all until the missing case is handled — a genuine compile-time failure, not a runtime surprise, confirming the exhaustiveness guarantee described in the exercise.

## Solution 05 — Generic Stack&lt;Element&gt; with a Protocol Constraint

See [solution-05.swift](solution-05.swift).

**Real captured output:**

```
--- Stack<Int> (Int: Equatable) ---
pop() -> 3 (expected 3, LIFO order)
contains(2) -> true
final count -> 2
```

**Compile-time constraint proof (real, reproduced compiler error):** calling `.contains(...)` on a `Stack<NotEquatable>` (a scratch type deliberately not conforming to `Equatable`) produced this real error, captured verbatim:

```
error: referencing instance method 'contains' on 'Stack' requires that
'NotEquatable' conform to 'Equatable'
```

This confirms the constrained extension (`extension Stack where Element: Equatable`) is enforced statically — `Stack<NotEquatable>` simply never gains a `.contains(_:)` method to call, rather than crashing or misbehaving at runtime.

## Solution 06 — Concurrent "Fetches" with async/await and an actor

See [solution-06.swift](solution-06.swift).

**Real captured output:**

```
Results total: 100
Elapsed: 0.4203444 seconds
Final counter after one more increment: 5
```

`100` = `(1 + 2 + 3 + 4) * 10`, confirming all four simulated fetches completed and their results were correctly summed. The elapsed time (~0.42s) tracks the **slowest** individual delay (400ms) rather than the sum of all four delays (1000ms) — real, measured proof that `withTaskGroup` runs its child tasks concurrently, not sequentially. The final counter value of `5` (four concurrent increments from the task group, plus one explicit extra call afterward) confirms `actor RequestCounter` safely serialized every concurrent mutation with no manual locking — if two increments had ever raced without the actor's protection, this number could have come out wrong (a lost update), the same class of bug a plain `class`-with-`var count` would risk under real concurrent access.

**A genuine bug hit and fixed while writing this solution:** the first draft used a `@main struct Solution06 { static func main() async { ... } }` wrapper (a pattern Lesson 14 and other language courses' `async` entry points use). Compiling it against the real toolchain produced:

```
error: 'main' attribute cannot be used in a module that contains top-level code
```

The fix: Swift has allowed top-level `await` directly in a single-file, non-`main.swift`-named script since Swift 5.5 — the file itself is already an implicit async entry point, so the `@main` wrapper was simply unnecessary and actively rejected once real top-level code existed alongside it. The final file has no `@main`/`struct` wrapper at all, just plain top-level statements using `await` directly.

## Solution 07 — Codable JSON Roundtrip with Validation

See [solution-07.swift](solution-07.swift).

**Real captured output:**

```
--- Validation ---
OK: Clean Code
OK: The Pragmatic Programmer
REJECTED: Impossible Ratings has an out-of-range rating (7.5); not encoded.
OK: Refactoring

--- Encode valid books to JSON ---
[
  {
    "rating" : 4.5,
    "title" : "Clean Code",
    "author" : "Robert C. Martin",
    "year" : 2008
  },
  {
    "rating" : 4.8,
    "title" : "The Pragmatic Programmer",
    "author" : "Hunt & Thomas",
    "year" : 1999
  },
  {
    "rating" : 4.6,
    "title" : "Refactoring",
    "author" : "Martin Fowler",
    "year" : 1999
  }
]

--- Decode back and confirm roundtrip equality ---
roundtripped == validBooks: true
```

The book with an out-of-range rating (`7.5`, outside `0.0...5.0`) is caught and printed by the `do`/`catch` block *before* the encoding step runs — `validBooks` (and therefore the JSON produced from it) only ever contains the three valid books, confirmed by the final `roundtripped == validBooks` equality check (relying on `Book: Equatable`) returning `true` after a real encode-then-decode roundtrip.

## How This Was Verified

A real Swift 6.1.2 toolchain (`x86_64-unknown-windows-msvc`) turned out to be genuinely installed in this environment at `C:\Users\HP\AppData\Local\Programs\Swift\Toolchains\6.1.2+Asserts\usr\bin\swiftc.exe`, discovered by a previous session that had assumed no toolchain existed when lessons 01–19 were written. Running `swiftc` directly failed outright with C-header-not-found errors (`errno.h` and related Windows SDK/UCRT headers unreachable), because Swift's Windows toolchain shells out to `clang-cl`/`link.exe` for the native build step, and neither could find the Windows SDK on `PATH`/`INCLUDE`/`LIB` without Visual Studio's own environment-setup script having run first.

The fix: locate `vcvarsall.bat` (found at `C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat` in this environment — the same Visual Studio install this repository's C++ course's lessons already relied on) and run `vcvarsall.bat x64` **before** invoking `swiftc`, in the same shell/session, so the Windows SDK include/lib paths and `cl.exe`/`link.exe` are all on `PATH` when `swiftc` shells out to them. Concretely, every compile in this folder ran a small `.bat` file of the form:

```bat
@echo off
call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
swiftc solution-01.swift -o solution-01.exe
solution-01.exe
```

invoked via `cmd.exe /c thatfile.bat`. One additional environment quirk was found and worked around, not papered over: invoking `vcvarsall.bat` and `swiftc` as a single inline `cmd.exe /c "... && ..."` string (rather than from a real `.bat` file) intermittently failed to execute the intended commands at all in this environment's shell-tool integration — writing the sequence to an actual `.bat` file and invoking that file directly was what reliably worked, and is the pattern used for every compile in this folder and in [22-Mini-Projects](../22-Mini-Projects/README.md).

## Suggested Next Lesson

[22 — Mini-Projects](../22-Mini-Projects/README.md)
