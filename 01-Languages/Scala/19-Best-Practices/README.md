# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Design immutability-first: prefer `val` over `var`, and immutable data structures/case classes over mutable ones.
- Avoid `null` entirely by using `Option`, verified with a real anti-pattern that crashes and a fix that can't.
- Recognize a genuine anti-pattern/fix pair, not just an abstract rule.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept

Idiomatic Scala treats immutability and the elimination of `null` as defaults, not afterthoughts — most of this course's earlier lessons already modeled this (`case class` in Lesson 11, `Option`/`Either`/`Try` in Lesson 09). This lesson makes the *cost* of ignoring these defaults concrete: a mutable, `null`-permitting class is shown genuinely throwing `NullPointerException`, immediately followed by an immutable, `Option`-based redesign of the exact same functionality that cannot throw it at all.

## Anti-Pattern: Mutable State + `null`

```scala
class UserAccountUnsafe(var name: String, var email: String):
  private var lastLoginNote: String = null   // null as "not set yet" -- a landmine
  def describeLastLogin(): String =
    lastLoginNote.toUpperCase                // CRASHES if never set -- nothing in the type warns you
```

Nothing in `describeLastLogin`'s signature (`String`, not `Option[String]`) tells a caller that `lastLoginNote` might be absent — the crash risk is invisible until it happens at runtime.

## Fix: Immutable `case class` + `Option`

```scala
final case class UserAccountSafe(name: String, email: String, lastLoginNote: Option[String] = None):
  def withLoginNote(note: String): UserAccountSafe = copy(lastLoginNote = Some(note))  // returns a NEW instance
  def describeLastLogin(): String =
    lastLoginNote.map(_.toUpperCase).getOrElse("(no login note recorded)")             // no crash possible
```

`Option[String]` makes "might not be set" part of the type itself, and `.getOrElse` forces a fallback to be provided — the compiler won't let a caller forget to handle absence, and `copy` returning a new instance means the original is never silently mutated out from under another part of the program holding a reference to it.

## Detailed Example

See [BestPractices.scala](BestPractices.scala) — the unsafe class genuinely throwing `NullPointerException` (caught and reported, not left to crash the whole program), the safe redesign handling the identical scenario without any possibility of that crash, and a brief immutable-collections demonstration (`List.appended` returning a new list, leaving the original untouched).

## Run It

```bash
cd 01-Languages/Scala/19-Best-Practices
scalac BestPractices.scala
scala run . --main-class bestPracticesDemo
```

## Expected Output

```
--- anti-pattern: mutable state + null, demonstrated crashing for real ---
CRASHED as predicted: NullPointerException

--- fix: immutable case class + Option, no crash possible ---
(no login note recorded)
LOGGED IN FROM NEW DEVICE
original 'safe' is UNCHANGED (immutability): (no login note recorded)

--- immutability-first: val over var, and immutable collections ---
fixedList  = List(1, 2, 3) (unchanged)
recomputed = List(1, 2, 3, 4)
```

## Common Mistakes

- Using `var` and mutable fields by default "because it's convenient," only reaching for `val`/immutability as an afterthought — this lesson's anti-pattern class is exactly that convenience turning into a real runtime crash.
- Initializing a field to `null` as a placeholder for "not set yet" instead of typing it as `Option[T] = None` — the type system can't help catch the mistake of forgetting to check for `null`, but it actively prevents forgetting to handle `None`.
- Mutating a shared object in place (`var` fields updated via setters) when multiple parts of a program hold a reference to it — this makes bugs from unexpected mutation extremely hard to trace, unlike the `copy`-based approach where mutation is structurally impossible.

## Best Practices

- Default to `val` and immutable data structures; introduce `var`/mutation only with a specific, justified reason (e.g. a tight, provably-local performance-critical loop).
- Never assign `null` to a field or return it from a function — model absence with `Option[T]` instead, exactly as Lesson 09 covers for `Option`/`Either`/`Try`.
- Prefer `case class` with `copy`-based updates over mutable classes with setters for any type representing data.

## Real-World Usage

Production Scala codebases (and the idioms taught by every major Scala style guide, including the Scala community's own) treat "no `null`, prefer immutability" as close to a hard rule — Scala's own standard collections are immutable by default (`List`, `Map`, `Set` all return new collections rather than mutating), and most linters/style checkers flag `null` usage as a code smell precisely because of the crash risk demonstrated live in this lesson.

## Summary

- An anti-pattern (mutable state + `null` as a "not set" sentinel) was shown genuinely throwing `NullPointerException`, not just described abstractly.
- The fix — an immutable `case class` with `Option[String]` instead of `null` — handles the identical scenario with zero crash risk, verified by running the same "never set" scenario through it without error.
- Immutability-first design (`val`, immutable collections, `copy`-based updates) is the idiomatic Scala default, not an optional extra.

## Key Terms

- **Anti-pattern** — a commonly-used but genuinely harmful design choice; this lesson's example is mutable state combined with `null` as a sentinel value.
- **Immutability-first** — designing so that data, once created, cannot be changed; updates produce new values (e.g. via `copy`) instead of mutating in place.
- **`Option[T]`** — makes the possibility of absence part of a value's type, eliminating `null`'s invisible crash risk (recapping Lesson 09).

## Interview Questions

1. **What specifically made the anti-pattern class crash, and how does the fix make that crash structurally impossible rather than just "less likely"?** — `UserAccountUnsafe.lastLoginNote` was initialized to `null` and typed as plain `String`; calling `.toUpperCase` on it before ever calling `setLastLoginNote` threw a real `NullPointerException`, verified live. The fix, `UserAccountSafe`, types the same field as `Option[String]` — there is no `String` value in that position that could be `null`; `.map(_.toUpperCase).getOrElse(...)` is *forced* by the type to supply a fallback for the `None` case, so the equivalent "never set" scenario was run through the fixed version and produced `"(no login note recorded)"` with no exception at all, not merely a lower chance of one.
2. **Why does `withLoginNote` return a new `UserAccountSafe` instead of mutating the existing one, and what did the demo verify about that?** — Because `UserAccountSafe` is an immutable `case class`, `withLoginNote` uses `copy(lastLoginNote = Some(note))` to produce a brand-new instance with only that field changed, leaving the original completely untouched. This was verified directly: after calling `safe.withLoginNote(...)` and printing the *new* instance's login note (`"LOGGED IN FROM NEW DEVICE"`), the original `safe` value was printed again and still showed `"(no login note recorded)"` — proof the original was never mutated, which matters whenever multiple parts of a program hold a reference to the same value and must not have it change unexpectedly underneath them.

## Recommended Next Lesson

[20 — Exercises](../20-Exercises/README.md)
