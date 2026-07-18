# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else`, `for`, `while`, `do-while` (all identical to C++).
- Understand `switch` fall-through as a real, live behavior — not just a rule to memorize — and how `break` controls it.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

C's control flow constructs are exactly what C++ inherited: `if`/`else`, `switch`, `for`, `while`, `do-while`. The one behavior worth a dedicated, reproduced demonstration is `switch` fall-through: without an explicit `break`, execution continues into the *next* `case` label regardless of whether its condition matches — this is not a bug, it's the specified behavior, and it is a genuine, frequently-cited source of real production bugs in both C and C++ (Java/C# require an explicit `fallthrough`-equivalent or disallow it by default in some contexts; C has always defaulted to fall-through).

## Syntax

```c
switch (day) {
    case 1:
        printf("Monday\n");
        /* no break -- falls through into case 2 */
    case 2:
        printf("Tuesday\n");
        break;                 /* stops here */
    default:
        printf("unknown\n");
}
```

## Detailed Example

See [example.c](example.c) — runs the **same** `switch` structure twice: once without `break` (fall-through genuinely observed), once with `break` (the usually-intended behavior), so the difference is directly visible in real output rather than just described.

## Expected Output

```
1 is odd
2 is even
3 is odd

-- switch WITHOUT break (fall-through) --
day 1: Monday-ish
day 1: also prints Tuesday-ish
day 1: also prints Wednesday-ish
day 2: also prints Tuesday-ish
day 2: also prints Wednesday-ish
day 3: also prints Wednesday-ish

-- switch WITH break (no fall-through) --
day 1: Monday
day 2: Tuesday
day 3: Wednesday

-- while --
3...
2...
1...

-- do-while (body runs at least once even though x == 0 fails immediately after) --
x = 0
```

Genuinely compiled and run with `cl /std:c17 /W4 example.c` — zero warnings. Notably, MSVC's `/W4` did **not** flag the missing `break`/fall-through at all (some compilers offer `-Wimplicit-fallthrough` under `-Wextra`; MSVC's closest equivalent is `/w14061`/analyzing tools, not enabled by `/W4` alone) — a real, confirmed gap worth knowing if you're relying on warnings to catch this class of bug.

## Common Mistakes

- Forgetting `break` in a `switch` when fall-through isn't intended — the single most commonly cited `switch`-related bug in both C and C++, confirmed above to compile with zero warnings under MSVC's `/W4`.
- Relying on compiler warnings to catch missing `break`s — as shown above, `/W4` alone does not catch this on MSVC; a linter/static analyzer or `-Wimplicit-fallthrough` (gcc/clang) is needed for that.
- Forgetting `do-while`'s body always runs at least once, even if the condition is false from the start — useful for "run once, then repeat while true" logic, easy to reach for `while` instead by habit and get one fewer iteration than intended.

## Best Practices

- Add a `// fallthrough` comment on any case that deliberately omits `break`, so it reads as intentional to the next person (or future you) rather than looking like a bug.
- Prefer `enum`-typed switch subjects (Lesson 11) over raw `int` where possible — some compilers can then warn if a `switch` doesn't handle every enum value.
- Enable the highest practical warning level for your compiler (`/W4` for MSVC, `-Wall -Wextra` for gcc/clang) as a baseline, but don't assume it catches everything — as demonstrated, fall-through specifically slips through MSVC's `/W4`.

## Real-World Usage

State machines (parsers, protocol handlers) are the most common legitimate use of intentional `switch` fall-through — grouping several states that should share the same subsequent logic without duplicating it.

## Exercises

See [Exercises/](Exercises/README.md) for a hands-on problem using this lesson's material; solutions are in [Solutions/](Solutions/README.md).

## Summary

- `if`/`for`/`while`/`do-while` are identical to C++.
- `switch` falls through by default without an explicit `break` — genuinely reproduced above, both broken and fixed — and MSVC's `/W4` does not warn about it.
- `do-while` always executes its body at least once, unlike `while`.

## Key Terms

- **Fall-through** — a `switch` case without `break` continues executing the next case's statements regardless of its own condition.

## Interview Questions

1. **What happens if you omit `break` in a C `switch` case, and is this considered a bug by the compiler?**
   Execution "falls through" into the next case label's statements unconditionally, regardless of whether that case's value matches — this is specified, standard behavior, not a bug the compiler will necessarily flag. Confirmed live in this lesson: MSVC's `/W4` compiled the fall-through example with zero warnings, so relying on default warning levels to catch a missing `break` is not safe on every compiler.

2. **Does `do-while`'s body always execute, even if the condition is false at the start?**
   Yes — `do-while` checks its condition *after* the first iteration, so the body always runs at least once, unlike `while`/`for` which check their condition *before* the first iteration and may never execute the body at all.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
