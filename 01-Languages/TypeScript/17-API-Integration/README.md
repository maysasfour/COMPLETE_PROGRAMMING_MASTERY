# 17 — API Integration

[Back to course overview](../README.md) | [Previous: Database Access](../16-Database-Access/README.md)

## Learning Objectives

- Type `fetch()` responses correctly, understanding `response.json()` returns `Promise<any>`.
- Write a validating helper combining a type guard with a typed `fetch` call, so API responses are genuinely checked, not just annotated.

## Prerequisites

[16-Database-Access](../16-Database-Access/README.md)

## Concept

`fetch()` itself behaves identically to [01-Languages/JavaScript/17-API-Integration](../../JavaScript/17-API-Integration/README.md), including the critical "doesn't throw on 404" trap. TypeScript's specific gap here: `response.json()` returns `Promise<any>` — TypeScript has no way to know what shape a network response actually has, so (exactly like `JSON.parse` in Lesson 10 and a raw database row in Lesson 16) the result must be validated, not merely annotated.

## The Same Validation Pattern, Applied to `fetch`

```ts
interface Todo {
  userId: number;
  id: number;
  title: string;
  completed: boolean;
}

function isTodo(value: unknown): value is Todo {
  return (
    typeof value === "object" &&
    value !== null &&
    typeof (value as Todo).userId === "number" &&
    typeof (value as Todo).id === "number" &&
    typeof (value as Todo).title === "string" &&
    typeof (value as Todo).completed === "boolean"
  );
}

async function fetchTodo(id: number): Promise<Todo> {
  const response = await fetch(`https://api.example.com/todos/${id}`);
  if (!response.ok) {
    throw new Error(`Request failed with status ${response.status}`);
  }
  const data: unknown = await response.json(); // widen the `any` back to `unknown`
  if (!isTodo(data)) {
    throw new Error("Response did not match the expected Todo shape");
  }
  return data; // NOW genuinely, verifiably typed as Todo
}
```

This is the exact same three-step pattern from Lesson 10 (JSON files) and Lesson 16 (database rows), applied a third time to network responses: **widen to `unknown`, validate with a real type guard, only then trust the specific type**. All three data sources share the same fundamental property — they originate outside the compiler's knowledge — and all three need the identical discipline.

## Detailed Example

See [example.ts](example.ts) — makes a real network call to the public `jsonplaceholder.typicode.com` test API (same service as the JavaScript course's equivalent lesson, and the Python course's, for direct three-way comparison), validates the response with `isTodo`, demonstrates the `response.ok` trap still applies, and confirms the type guard correctly rejects a deliberately wrong-shaped object.

## Expected Output

Compiling and running `example.ts` (requires internet access) prints a real, validated `Todo` fetched from the public API with a type-specific method called on it safely, confirms a 404 response resolves normally (`ok: false`) rather than throwing, and confirms `isTodo` correctly returns `false` for an object with a wrong-typed field.

## Common Mistakes

- Writing `const data: Todo = await response.json()` and trusting it — this is an unverified annotation, identical in kind to the `JSON.parse`/database-row mistakes from earlier lessons, just at a different data source.
- Forgetting `response.ok` still needs a manual check — typing the response doesn't change `fetch`'s fundamental behavior of not throwing for HTTP error statuses.

## Best Practices

- Apply the same widen-to-`unknown`-then-validate pattern to every external data source: files (Lesson 10), databases (Lesson 16), and network responses (this lesson) — they're all fundamentally the same problem.
- In a larger real project, prefer a schema-validation library (Zod, Valibot) over hand-written type guards once the number of validated shapes grows past a handful — they generate both the guard and the matching `interface`/`type` from one schema definition, removing the risk of the two drifting out of sync.

## Real-World Usage

This validate-at-the-boundary pattern is standard practice in production TypeScript API clients — a typed `interface` alone gives you excellent editor tooling and internal consistency, but only real runtime validation (this lesson's `isTodo`, or a schema library) actually protects against an API returning something unexpected, whether from a bug, a version mismatch, or a breaking change on the server side.

## Summary

- `fetch()`'s runtime behavior (including the "doesn't throw on 404" trap) is unchanged from JavaScript; `response.json()` returns `Promise<any>`.
- API responses need the same widen-to-`unknown`-then-validate pattern as JSON files (Lesson 10) and database rows (Lesson 16) — an interface annotation alone verifies nothing.
- This is the third and final lesson in this course to apply that same three-data-source pattern, reinforcing it as a general principle rather than a one-off trick.

## Key Terms

- **Boundary validation** — checking data from any source outside the compiler's control (files, databases, network) against an expected shape at runtime, before trusting a type annotation.

## Interview Questions

1. **What type does `response.json()` return, and what does that imply for how you should use it?**
   `Promise<any>` — TypeScript cannot know what shape a network response actually has. This implies you should never directly trust an annotation on its result; instead, widen it to `unknown` and pass it through a real runtime validator (a type guard or schema library) before treating it as a specific interface.

2. **What do JSON files, database rows, and API responses have in common from a TypeScript type-safety perspective?**
   All three originate from outside the compiler's control — none of them can be verified by TypeScript's static type checking alone, since they represent data that exists only at runtime and could, in principle, be anything. Each needs the identical discipline: parse/fetch into an `unknown`-typed value, then validate its actual shape with a real runtime check before trusting any more specific type for it.

## Recommended Next Lesson

[18 — Testing](../18-Testing/README.md)
