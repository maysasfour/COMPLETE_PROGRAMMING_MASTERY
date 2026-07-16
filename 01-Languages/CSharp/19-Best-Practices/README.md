# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Apply a consistent, defensible C# style across types, equality, nullability, and async code.
- Recognize and avoid the specific footguns covered throughout lessons 01–18, collected here as one reference.

## Prerequisites

All of lessons 01–18 — this lesson is a synthesis, not new material.

## Types and Equality

- Use `record` for immutable, data-carrying types needing value equality; use `class` for types with identity or mutable behavior (Lesson 11).
- Always pair `virtual` (base) with `override` (derived) explicitly for intended polymorphism.
- Prefer `interface`s for pluggable contracts; `abstract class` when subclasses should share real concrete behavior too.

## Nullability

- Enable nullable reference types on every project and treat warnings as real bugs to fix, not noise (Lesson 03).
- Prefer a genuine null-check (`if (x is not null)`) over the null-forgiving operator (`x!`) — `!` silences the compiler with **zero runtime protection**, exactly like TypeScript's `!` — a wrong assumption still crashes with `NullReferenceException` at runtime, just later and with a less informative stack trace pointing at the actual dereference instead of the false assumption.

## Async

- Always `await`; never `.Result`/`.Wait()` on a `Task` (Lesson 14).
- Use `Task.WhenAll` for independent operations that can run concurrently instead of serializing them with sequential `await`.

## The Recurring Theme: Don't Trust External Data

Lessons 10, 16, and 17 each validated data from a different external source — JSON files, database rows, network responses:

```csharp
Config? ParseConfig(string json) {
    try {
        return JsonSerializer.Deserialize<Config>(json);
    } catch (JsonException) {
        return null; // structurally invalid JSON is handled, not a crash
    }
}
```

`JsonSerializer.Deserialize<T>()` does provide genuine structural validation (throwing `JsonException` on a shape mismatch) — a real advantage over JavaScript's `JSON.parse` (always `any`, zero validation) and even hand-validated TypeScript (a manual type guard is required to get the same guarantee). But it still only validates *shape*, not business rules (a `FontSize` of `-999` deserializes successfully) — the same "the type system alone isn't enough" principle from the TypeScript course applies, just starting from a stronger baseline.

## Detailed Example

See [example.cs](example.cs) — a direct "before" (reference-equality mistake, an unchecked `!` crashing, no validation) versus "after" (record value equality, a real null-check, validated JSON parsing) contrast, both run so the difference is demonstrated, not just described.

## Expected Output

Running the example prints the "before" version showing two structurally-identical `class` instances comparing unequal (reference equality) and a `!`-forced null dereference actually crashing at runtime, then the "after" version showing a `record`'s correct value equality, a real null-check avoiding the crash, and a validated JSON parse correctly rejecting malformed input without throwing all the way up to the caller.

## Common Mistakes

All of Lessons 01–18's "Common Mistakes" sections apply collectively: reference-vs-value-equality confusion, `!`/unchecked null assertions, forgetting `virtual`/`override` pairing, `.Result`/`.Wait()` deadlock risk, sequential `await` for independent work, and trusting external data (files/DB/network) without validating its actual shape.

## Best Practices (Meta)

- Enable nullable reference types and `strict`-equivalent compiler warnings project-wide; treat them as bugs, not suggestions.
- Write xUnit tests (Lesson 18) for behavior that matters, especially edge cases — the compiler cannot catch a wrong formula, only a test can.
- Validate every external data source at its boundary, even though C#'s `JsonSerializer` already provides more structural safety than JavaScript's raw `JSON.parse`.

## Real-World Usage

Every production C#/.NET codebase in [04-Backend-Development](../../../04-Backend-Development/) (ASP.NET Core) assumes exactly this baseline discipline; code review at most .NET shops will flag `!` on genuinely uncertain values, reference-type equality mistakes, and `.Result`/`.Wait()` usage as immediate concerns.

## Summary

- This lesson has no new syntax — it's a checklist synthesizing lessons 01–18's individual practices into one reference.
- The recurring theme: prefer explicit, checked constructs (`record` value equality, real null-checks, `await`, validated deserialization) over their unchecked/implicit counterparts (`class` reference equality treated as value equality, `!`, `.Result`, trusting an unvalidated annotation).
- `System.Text.Json`'s structural validation is a genuine advantage over `JSON.parse`, but still doesn't replace business-rule validation.

## Key Terms

- **Null-forgiving operator (`!`)** — silences a nullable-reference compiler warning with zero runtime protection; a wrong assumption still crashes.

## Interview Questions

1. **Why is comparing two `class` instances with `==` often a bug, while the same comparison on `record`s usually isn't?**
   `class` uses reference equality by default — two instances with identical field values are still considered unequal unless the class explicitly overrides `Equals`/`==`. `record` types automatically generate value-based equality, so two records with identical property values compare equal by default — matching what most developers intuitively expect for plain data-carrying types.

2. **Does the null-forgiving operator (`!`) prevent a `NullReferenceException`?**
   No — it only silences the compiler's nullable-reference-type warning at that specific line; it performs no runtime check or conversion at all. If the value is actually `null` when dereferenced, the program still throws `NullReferenceException` exactly as it would without the `!`, just without having been warned about the risk beforehand.

## Recommended Next Lesson

This completes the core C# course (lessons 01–19), matching the depth of Python, JavaScript, and TypeScript. Lessons 20–22 (Exercises, Solutions, Mini-Projects as standalone folders) are not yet built — see [BUILD_STATUS.md](../../../BUILD_STATUS.md). From here, continue to [Java](../../Java/README.md) (per this repository's specified language order) or [04-Backend-Development](../../../04-Backend-Development/) (ASP.NET Core).
