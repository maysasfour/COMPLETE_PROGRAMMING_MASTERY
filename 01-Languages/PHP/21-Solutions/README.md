# 21 — Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

Worked solutions to all seven problems in [20-Exercises](../20-Exercises/README.md). Every file below was actually run with the real PHP 8.4.23 CLI (`php solution-0N.php`) and its output pasted verbatim — nothing here is hand-typed "expected" output. Attempt each exercise yourself first.

## Solution 01 — Match-Based Grade Calculator

[solution-01.php](solution-01.php)

```
$ php solution-01.php
100 -> A
90 -> A
89 -> B
60 -> D
59 -> F
0 -> F
Caught expected ValueError: score must be between 0 and 100, got 105
```

## Solution 02 — Traits and a Real Conflict Resolution

[solution-02.php](solution-02.php)

```
$ php solution-02.php
Volunteer last audited: 2026-07-18T00:00:00
Hi, I'm a Volunteer.
Hi, I'm a Robot.
```

`insteadof` picked `Auditable::describe` as `Volunteer`'s real `describe()`; `Greetable::describe` is still reachable, but only via its `as greetOnly` alias. `Robot` never touched `Auditable` at all, and its `describe()` is `Greetable`'s original, unaliased implementation.

## Solution 03 — Backed Enum Implementing an Interface

[solution-03.php](solution-03.php)

```
$ php solution-03.php
from(2) label: Medium
NULL
from(99) threw as expected: 99 is not a valid backing value for enum Priority
Low => Low (backing value 1)
Medium => Medium (backing value 2)
High => High (backing value 3)
[{"value":1,"label":"Low"},{"value":3,"label":"High"}]
```

`tryFrom(99)` returned `null` (visible as `NULL` from `var_dump`) instead of throwing, while `from(99)` on the identical bad input threw `ValueError` — confirming the two methods really do differ in failure behavior, not just in name. The final `json_encode()` line confirms `jsonSerialize()` was actually invoked (`{"value":1,"label":"Low"}`, not a bare `1`).

## Solution 04 — Closures: `use (&$var)` vs. `use ($var)`

[solution-04.php](solution-04.php)

```
$ php solution-04.php
increment: 1, 2, 3
after reset: 1
snapshotA: 10, snapshotB: 20
array_walk total: 108
```

**A real bug was hit and fixed while writing this solution**: `makeSnapshot()` was first declared `: array` (copy-pasted from `makeCounter()`'s signature) but returns a single `Closure`, not a two-element array. Running it produced a genuine `TypeError: makeSnapshot(): Return value must be of type array, Closure returned`. Fixed by changing the return type to `: Closure` — left in as a reminder that PHP's return-type declarations are checked at runtime (unlike a compiled language catching this before the program ever runs), and that copy-pasting a function signature is a real, easy way to introduce this kind of mismatch.

## Solution 05 — The Split `Error` / `Exception` / `Throwable` Hierarchy

[solution-05.php](solution-05.php)

```
$ php solution-05.php
Attempt 0 caught a Exception: ValidationException -- Sam is 15, which is under 18
Attempt 1 caught a Error: ArgumentCountError -- Too few arguments to function requireTwoArgs(), 1 passed in C:\Users\HP\Complete-Programming-Mastery\01-Languages\PHP\21-Solutions\solution-05.php on line 36 and exactly 2 expected
```

Both throwables were caught by the exact same `catch (Throwable $t)` clause, but `instanceof Error` correctly distinguished PHP's own built-in `ArgumentCountError` (a genuine programming mistake — wrong argument count) from the hand-written `ValidationException` (an expected, recoverable business-rule failure) — proving the split hierarchy live, not just describing it.

## Solution 06 — Named Arguments

[solution-06.php](solution-06.php)

```
$ php solution-06.php
Mays, you're invited to Launch Party at 19:30. You may bring a guest. Note: Bring your badge.
Ada, you're invited to Conference Dinner at 18:00. Note: Vegetarian option available.
Grace, you're invited to Team Offsite at 18:00. You may bring a guest.
Caught expected ArgumentCountError: buildInvitation(): Argument #1 ($name) not passed
```

The second call reaches `$note` while skipping both `$time` and `$plusOne` entirely — genuinely impossible to express with positional arguments alone. The final call proves named arguments don't waive required parameters: omitting `$name` still throws the same `ArgumentCountError` a positional-only call would.

## Solution 07 — Capstone: Library Checkout State Machine

[solution-07.php](solution-07.php)

```
$ php solution-07.php
Book #1 starts as available.
Checked out 'Refactoring' to Priya (id #1), due 2026-08-01.
Status after checkout: checked_out
Returned 'Refactoring'. Status is now available.
Checked out 'Refactoring' to Priya (id #1), due 2026-08-01.
Caught expected InvalidTransitionException: Cannot check out 'Refactoring' -- current status is checked_out
```

`Book` and `Member` each get their own independent `id` sequence from the same `HasId` trait (both print `#1` because each class's `private static int $nextId` is per-class, not shared globally — a `static` property inside a trait is copied into each *using* class separately). The final, deliberate double-checkout is rejected by the `match`-based guard inside `checkout()` and surfaces as a catchable `InvalidTransitionException`, exactly as the exercise asks.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
