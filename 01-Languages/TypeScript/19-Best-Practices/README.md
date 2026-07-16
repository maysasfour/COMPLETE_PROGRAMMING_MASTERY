# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Apply a consistent, defensible TypeScript style across typing, narrowing, and boundary validation.
- Recognize and avoid the specific footguns covered throughout lessons 01–18, collected here as one reference.
- Know what `tsc --strict` catches automatically versus what still requires runtime validation or tests.

## Prerequisites

All of lessons 01–18 — this lesson is a synthesis, not new material, mirroring the structure of the JavaScript course's equivalent Lesson 19.

## Typing Discipline

- Enable `"strict": true` (or the equivalent CLI flags used throughout this course) on every project — it's the single highest-leverage setting, encompassing `strictNullChecks` and several other checks (Lesson 03).
- Prefer `unknown` over `any` for genuinely uncertain values; narrow with real type guards, not assertions (Lesson 03/04).
- Model closed sets of values with literal unions and discriminated unions, and add exhaustiveness checks to `switch` statements over them (Lesson 05).
- Prefer structural narrowing (`typeof`, `in`, `instanceof`, custom type guards) over `as`/`!` wherever the information to narrow safely is actually available (Lesson 04).

## The One Recurring Theme: Validate at the Boundary

Lessons 10, 16, and 17 each demonstrated the exact same principle applied to a different data source — JSON files, database rows, and network responses:

```ts
const data: unknown = /* JSON.parse, db row, fetch response -- any external source */;
if (!isExpectedShape(data)) {
  throw new Error("Data did not match the expected shape");
}
// only NOW is `data` genuinely, verifiably typed -- not merely annotated
```

**An annotation on external data is a claim, not a check.** `JSON.parse`, a database driver, and `fetch`'s `.json()` all return values the compiler cannot verify — writing `const x: MyType = externalSource()` compiles cleanly regardless of whether the real data actually matches, and any mismatch surfaces later, at runtime, often far from where the false assumption was made. A real type guard is what actually earns type safety for external data; the type system alone cannot provide it.

## Functions and Generics

- Prefer a genuine generic (`<T>`) over `any` whenever code needs to work across multiple types but should remain fully type-checked (Lesson 13).
- Type higher-order function wrappers generically so they preserve the exact signature of whatever they wrap (Lesson 12).
- Use function overloads only when a precise, input-dependent return type is worth the added signature complexity; otherwise a union parameter with internal narrowing is simpler (Lesson 06).

## What `tsc --strict` Catches vs. What It Doesn't

```json
{ "compilerOptions": { "strict": true } }
```

`--strict` catches type mismatches, unhandled `null`/`undefined`, and (with the patterns from this course) unhandled union cases via exhaustiveness checks. It does **not** catch: a logically wrong formula that's type-correct, a database row/API response that doesn't match its claimed interface (Lessons 10/16/17's whole point), or anything about actual runtime behavior under load. That remains the job of tests (Lesson 18), runtime validation, and code review — exactly the same limits the JavaScript course's Lesson 19 identified for linters, just enforced one layer earlier in TypeScript's case.

## Detailed Example

See [example.ts](example.ts) — a direct "before" (untyped/unvalidated, riddled with the mistakes from earlier lessons) versus "after" (properly typed, `??` instead of `||`, validated external input) contrast, both run so the difference is demonstrated, not just described.

## Expected Output

Running the compiled example prints the "before" version silently corrupting an intentional 0% discount and silently accepting a string where a number was expected (because everything was typed `any`), then the "after" version correctly preserving an intentional 0% discount and rejecting a malformed external input via real validation rather than an unchecked annotation.

## Common Mistakes

All of Lessons 01–18's "Common Mistakes" sections apply collectively — this lesson doesn't introduce new footguns, it collects the recurring ones: reaching for `any` out of convenience, trusting `as`/`!` without real narrowing, treating `readonly` as runtime-enforced, and — the theme most specific to TypeScript — trusting an interface annotation on external data (JSON, database rows, API responses) without a real runtime check.

## Best Practices (Meta)

- Automate what can be automated (`tsc --strict` in CI, ESLint's TypeScript-aware rules, Prettier) so code review focuses on logic and design, not type-annotation nitpicks.
- Write tests (Lesson 18) for behavior that matters, especially edge cases — `tsc` cannot catch a wrong formula, only a test can.
- Validate every external data source at its boundary; treat "I wrote an interface for it" and "I verified it matches that interface" as two entirely separate, both-necessary steps.

## Real-World Usage

Every production TypeScript codebase in [03-Frontend-Development](../../../03-Frontend-Development/) and [04-Backend-Development](../../../04-Backend-Development/) assumes exactly this baseline discipline; interview take-home projects and code review at most companies will flag unvalidated `as`/`!` on external data, and unnecessary `any`, as immediate concerns.

## Summary

- This lesson has no new syntax — it's a checklist synthesizing lessons 01–18's individual practices into one reference.
- The single most TypeScript-specific recurring theme across this course: an interface/type annotation on data from outside the program (files, databases, network) is an unverified claim until a real runtime check (a type guard, a schema library) proves it true.
- `tsc --strict` is powerful but bounded — it cannot replace tests or validation for anything involving real, external, or run-time-only data.

## Key Terms

- **Boundary validation** — verifying external data (files, databases, network responses) actually matches its claimed type at runtime, since the compiler cannot check this on its own.

## Interview Questions

1. **What is the single most important TypeScript-specific lesson from this course's later lessons (10, 16, 17)?**
   That a type annotation on data originating outside the program — a JSON file, a database row, a network response — is a claim the compiler trusts but never verifies. Only a genuine runtime check (a type guard function, or a schema-validation library) actually confirms external data matches its claimed shape; skipping that step reintroduces exactly the kind of runtime type error TypeScript is supposed to prevent, just moved to a data source instead of in-code logic.

2. **Name three TypeScript-specific best practices this course has emphasized and briefly justify each.**
   (1) Enable `"strict": true` — it includes `strictNullChecks` and other checks responsible for catching the majority of real-world TypeScript bugs. (2) Prefer `unknown` with real narrowing over `any` or unchecked `as`/`!` assertions — preserves the safety `any`/assertions discard. (3) Validate external data (files/DB/network) with a real type guard rather than trusting an annotation — the compiler cannot verify data it never sees at compile time.

## Recommended Next Lesson

This completes the core TypeScript course (lessons 01–19), matching the JavaScript course's depth. Lessons 20–22 (Exercises, Solutions, Mini-Projects as standalone folders) are not yet built — see [BUILD_STATUS.md](../../../BUILD_STATUS.md). From here, continue to [03-Frontend-Development](../../../03-Frontend-Development/) (React/Angular/Vue all have first-class TypeScript support) or [04-Backend-Development](../../../04-Backend-Development/) (NestJS is TypeScript-first).
