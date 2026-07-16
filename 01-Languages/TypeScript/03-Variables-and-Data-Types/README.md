# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Use TypeScript's primitive types plus its TypeScript-only additions: `any`, `unknown`, `never`, `void`.
- Use union (`|`) and literal types to model a closed set of valid values.
- Explain `strictNullChecks` and why `null`/`undefined` are not assignable to other types under it.
- Explain why `any` defeats the purpose of TypeScript and when `unknown` is the safer alternative.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

TypeScript has all of JavaScript's runtime types (Lesson 03 of the JS course) plus several **type-system-only** concepts that exist purely for the compiler and vanish at runtime: `any` (opt out of type checking entirely), `unknown` (safely opt out while still requiring a check before use), `never` (a value that can never occur, e.g. a function that always throws), and `void` (a function's return value that should never be used).

## Basic Types (Recap with Annotations)

```ts
let count: number = 42;
let name: string = "Ada";
let active: boolean = true;
let tags: string[] = ["a", "b"];       // array of strings
let coordinates: [number, number] = [1, 2]; // tuple: fixed length, fixed per-position types
```

## `any` vs. `unknown`

```ts
let dataAny: any = fetchSomeJson();
dataAny.whatever.you.want(); // compiles -- ALL type checking disabled for this value

let dataUnknown: unknown = fetchSomeJson();
// dataUnknown.whatever;     // error -- must narrow the type before using it
if (typeof dataUnknown === "object" && dataUnknown !== null && "name" in dataUnknown) {
  console.log((dataUnknown as { name: string }).name); // now safe, after a real check
}
```

`any` is TypeScript's escape hatch — assigning `any` to a variable disables type checking for everything done with it afterward, effectively opting that value back out to plain JavaScript. `unknown` is the type-safe alternative for "I don't know this value's type yet": it can hold anything, but the compiler *forces* you to narrow it (via `typeof`, `instanceof`, or a custom check) before you're allowed to do anything with it. Prefer `unknown` over `any` for genuinely uncertain values (API responses, `JSON.parse` results, `catch` block errors).

## `never` and `void`

```ts
function throwError(message: string): never {
  throw new Error(message); // never actually returns -- return type is `never`
}

function logMessage(msg: string): void {
  console.log(msg); // returns undefined, but callers shouldn't rely on/use the return value
}
```

`void` means "this function's return value should be ignored," but technically the runtime value is still `undefined`. `never` is stronger: it means execution can **never reach** the point after the call — used for functions that always throw or always loop forever, and for exhaustiveness checks (a `switch` covering every union member has a `never`-typed fallthrough case, which is how the compiler catches an unhandled new member added later).

## Union Types and Literal Types

```ts
type Status = "pending" | "active" | "done"; // a literal union: only these three strings are valid

function setStatus(status: Status) {
  console.log("Status set to:", status);
}

setStatus("active");   // fine
// setStatus("cancelled"); // error: not assignable to type 'Status'

let id: number | string; // union type: either a number or a string, nothing else
id = 42;
id = "abc-123";
```

## `strictNullChecks`

```ts
function getLength(text: string): number {
  return text.length;
}

let maybeText: string | undefined = undefined;
// getLength(maybeText); // error under strict mode: 'string | undefined' is not assignable to 'string'

if (maybeText !== undefined) {
  console.log(getLength(maybeText)); // safe -- TypeScript "narrows" the type inside this branch
}
```

Under `"strict": true` (which includes `strictNullChecks`), `null` and `undefined` are **not** automatically part of every type — a plain `string` genuinely cannot be `undefined` unless you explicitly write `string | undefined`. This single check eliminates an enormous class of real-world "cannot read properties of undefined" runtime errors by forcing them to be compile-time errors instead.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints demonstrations of arrays/tuples, `unknown` requiring a narrowing check before use (contrasted with what `any` would have allowed unchecked), a `never`-returning function used in a caught error path, a union/literal type rejecting an invalid value at compile time (shown as a comment, since a real rejection can't "run"), and a `strictNullChecks` narrowing example.

## Common Mistakes

- Reaching for `any` as a shortcut whenever a type is momentarily inconvenient to express — this silently disables checking for that value and everything derived from it, often propagating far beyond the original line.
- Forgetting that `void` doesn't mean "no return value" the way it might in C/Java — the function still runs and technically returns `undefined`; `void` just signals callers shouldn't use that value.
- Not using literal union types (`"pending" | "active" | "done"`) where a plain `string` would silently accept any typo'd status string.
- Believing `unknown` and `any` are interchangeable — `unknown` requires narrowing before use; `any` doesn't, which is exactly why `any` is far more dangerous.

## Best Practices

- Prefer `unknown` over `any` for values of genuinely uncertain type (parsed JSON, caught errors, third-party data); narrow it properly before use.
- Model closed sets of valid values with literal union types instead of a bare `string`/`number`.
- Keep `strictNullChecks` on; it is one of the highest-value checks in the entire type system.
- Reserve `any` for genuine escape hatches (interfacing with untyped legacy code, gradual migration) and mark such uses with a comment explaining why.

## Real-World Usage

API response typing almost always starts with `unknown` (or a runtime validation library like Zod) rather than trusting a network response to already match your expected shape — `fetch(...).then(r => r.json())` in TypeScript returns `Promise<any>` by default, which is exactly the kind of unchecked value that should be narrowed or validated before use, not passed around as `any`.

## Summary

- TypeScript adds `any` (opt out of checking), `unknown` (safe opt-out, requires narrowing), `never` (unreachable/always-throws), and `void` (ignore the return) on top of JavaScript's runtime types.
- Union types (`A | B`) and literal types (`"a" | "b" | "c"`) model closed sets of valid values precisely.
- `strictNullChecks` makes `null`/`undefined` explicit members of a type rather than implicitly allowed everywhere, catching a huge class of real-world null-reference bugs at compile time.

## Key Terms

- **`any`** — a type that disables type checking entirely for a value.
- **`unknown`** — a type-safe "I don't know yet" that requires narrowing before use.
- **`never`** — the type of a value that can never occur (an always-throwing function, an exhaustively-handled union's impossible remainder).
- **Union type** — a type allowing any one of several specified types (`A | B`).
- **Type narrowing** — refining a broader type to a more specific one within a conditional branch, based on a runtime check.

## Review Questions

1. Why is `unknown` considered safer than `any`, given both can hold any value?
2. What does `strictNullChecks` change about whether `undefined` is assignable to `string`?
3. When would a function's return type be `never` rather than `void`?

## Exercises

None yet for this lesson — see the JavaScript course's equivalent exercises for closely related practice, or attempt writing a `Status`-style literal union type for a domain of your choosing as self-practice.

## Interview Questions

1. **What's the difference between `any` and `unknown`?**
   Both can hold a value of any type, but `any` disables type checking entirely — you can call any method or access any property on it with no compiler complaint, and that lack of checking propagates to anything derived from it. `unknown` is type-safe: the compiler forces you to narrow it (via `typeof`, `instanceof`, or a custom type guard) before you're allowed to use it in any specific way, preserving safety while still allowing genuinely unknown-typed values.

2. **What does `strictNullChecks` actually do?**
   Without it, `null` and `undefined` are treated as assignable to every type, meaning a `string`-typed value could silently be `null` at runtime with no compile-time warning — a major source of "cannot read properties of null/undefined" runtime crashes. With it on, `null`/`undefined` are only assignable where explicitly included in a type (`string | null`), forcing every genuinely nullable value to be checked before use.

3. **What is `never` used for, and how is it different from `void`?**
   `void` describes a function that returns (control flow continues afterward) but whose return value is meaningless (`undefined` at runtime) and shouldn't be used by the caller. `never` describes a function that **never returns at all** — it either always throws or loops forever — and is also used by the compiler to verify a `switch`/conditional exhaustively handles every case of a union type, since the theoretically-unreachable fallthrough branch should have type `never`.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
