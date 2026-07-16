# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Type `Promise<T>` and `async` functions correctly.
- Type `Promise.all`'s result as a tuple, preserving each element's specific type.
- Use a generic `fetchWithTimeout<T>`-style helper combining Promises with generics.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

The event loop, Promises, and `async`/`await` behave identically to [01-Languages/JavaScript/14-Async-and-Concurrency](../../JavaScript/14-Async-and-Concurrency/README.md). TypeScript's addition is typing what a Promise resolves to (`Promise<T>`), and — critically — `Promise.all` preserving each individual element's specific type in the resulting tuple, rather than collapsing everything into a single union.

## Typing `Promise<T>` and `async` Functions

```ts
function delay<T>(ms: number, value: T): Promise<T> {
  return new Promise((resolve) => {
    setTimeout(() => resolve(value), ms);
  });
}

async function loadGreeting(): Promise<string> {
  const message = await delay(10, "Hello!"); // inferred as string
  return message.toUpperCase();
}
```

An `async function`'s declared return type is always wrapped in `Promise<...>` — writing `async function f(): string` (without `Promise<>`) is a compile error, since an `async` function's actual runtime return value is always a Promise, never the bare value.

## `Promise.all` Preserves Per-Element Types

```ts
async function loadDashboard() {
  const [user, orderCount, isPremium] = await Promise.all([
    delay(50, { name: "Ada" }),  // Promise<{ name: string }>
    delay(30, 5),                 // Promise<number>
    delay(20, true),              // Promise<boolean>
  ]);
  // user: { name: string }, orderCount: number, isPremium: boolean -- each its OWN type, not a union
  console.log(user.name, orderCount, isPremium);
}
```

This is a genuinely valuable TypeScript-specific benefit: `Promise.all([...])` with a fixed-length array literal infers a **tuple** result type, where each position keeps its own specific resolved type — `user` is never accidentally typed as `{name:string} | number | boolean`, which would force an unnecessary narrowing check before using any of them.

## A Generic `fetchWithTimeout<T>`

```ts
function fetchWithTimeout<T>(task: () => Promise<T>, timeoutMs: number): Promise<T> {
  const timeout = new Promise<never>((_, reject) => {
    setTimeout(() => reject(new Error(`Timed out after ${timeoutMs}ms`)), timeoutMs);
  });
  return Promise.race([task(), timeout]);
}
```

`Promise<never>` for the timeout Promise is a precise, honest type: this Promise can never actually *resolve* with a value (it only ever rejects), so `never` — not `void`, not `unknown` — correctly describes its non-existent success type. `Promise.race([task(), timeout])` then correctly infers the overall result as `Promise<T>`, since a `Promise<never>` contributes nothing to the union of possible resolved types.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints a typed `delay<T>` helper used with different concrete types, a `Promise.all` call whose destructured results retain their individual types (verified by using type-specific operations on each without any assertion), and a generic `fetchWithTimeout<T>` succeeding for a fast task and correctly timing out for a slow one.

## Common Mistakes

- Writing `async function f(): string` instead of `Promise<string>` — a common mistake for developers new to typing async functions.
- Not realizing `Promise.all` on a fixed-length array literal gives a tuple with per-element types — sometimes leading to unnecessary manual type assertions "just to be safe" on values that are already precisely typed.
- Typing a timeout Promise's rejection-only executor as `Promise<void>` instead of `Promise<never>`, which is slightly less precise (implying a resolve to `undefined` is possible, when it structurally never is).

## Best Practices

- Always declare `async` function return types as `Promise<T>`, matching their true runtime behavior.
- Rely on `Promise.all`'s tuple inference rather than adding manual type assertions on its destructured results.
- Type a rejection-only Promise as `Promise<never>` to precisely communicate "this can only fail, never succeed with a value."

## Real-World Usage

Typed `Promise<T>` return values are what let editor tooling autocomplete correctly on `await`ed API/database calls throughout [04-Backend-Development](../../../04-Backend-Development/) TypeScript codebases; `Promise.all`'s tuple-preserving inference is what makes concurrently loading several differently-typed pieces of data (a user, a count, a flag) both fast and fully type-safe in one line.

## Summary

- `async` functions must declare `Promise<T>` return types, reflecting their actual runtime behavior.
- `Promise.all` on a fixed-length array literal infers a tuple, preserving each element's specific type rather than collapsing to a union.
- `Promise<never>` precisely types a Promise that can only reject, never resolve with a value.

## Key Terms

- **`Promise<T>`** — a Promise that resolves with a value of type `T`.
- **Tuple-preserving inference** — `Promise.all`'s ability to infer a result tuple where each position keeps its own specific type.

## Interview Questions

1. **Why must an `async` function's declared return type be wrapped in `Promise<T>`?**
   An `async` function always returns a Promise at runtime, regardless of what its `return` statements produce — even `return 5;` inside an `async function` actually returns `Promise<number>` to the caller. Declaring the return type as `Promise<T>` reflects this real runtime behavior; declaring it as just `T` would be incorrect and is a compile error.

2. **What does `Promise.all` return when given a fixed-length array literal of Promises with different resolved types, and why does this matter?**
   TypeScript infers a tuple type where each position retains its own specific resolved type (e.g., `[User, number, boolean]`), rather than collapsing everything into a union like `(User | number | boolean)[]`. This matters because destructuring the result gives each variable its own precise, immediately-usable type with no additional narrowing needed.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
