# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`finally` with the compiler's default `unknown`-typed caught error.
- Write typed custom `Error` subclasses and narrow `catch` blocks safely with `instanceof`.
- Model recoverable failures with a `Result<T, E>`-style discriminated union instead of throwing.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

Error handling syntax is identical to [01-Languages/JavaScript/09-Error-Handling](../../JavaScript/09-Error-Handling/README.md); what TypeScript adds is that a caught error is typed `unknown` (not `any`) under `"useUnknownInCatchVariables"`, which is implied by `"strict": true`. This forces exactly the same narrow-before-use discipline from Lesson 03/04 onto every `catch` block — you cannot call `.message` on a caught error without first proving it's actually an `Error`.

## `catch` Is Typed `unknown`

```ts
try {
  throw new Error("boom");
} catch (err) {
  // err is `unknown` here, NOT `any` and NOT `Error` -- even though we know it's an Error in this case
  // console.log(err.message); // error: 'err' is of type 'unknown'
  if (err instanceof Error) {
    console.log(err.message); // safe: narrowed to Error
  }
}
```

This is deliberate: JavaScript allows `throw` on **any** value (a string, a number, `undefined`), so TypeScript cannot assume a caught value is an `Error` just because that's the common case — you must narrow it, exactly like any other `unknown` value.

## Custom Error Classes

```ts
class ValidationError extends Error {
  constructor(message: string, public readonly field: string) {
    super(message);
    this.name = "ValidationError";
  }
}

function validateAge(age: number): number {
  if (age < 0) throw new ValidationError("Age cannot be negative", "age");
  return age;
}

try {
  validateAge(-5);
} catch (err) {
  if (err instanceof ValidationError) {
    console.log(`Validation failed on "${err.field}": ${err.message}`);
  } else if (err instanceof Error) {
    console.log("Unexpected error:", err.message);
  } else {
    throw err; // not even an Error instance -- re-throw whatever it was
  }
}
```

`public readonly field: string` in the constructor parameter list is a TypeScript shorthand (a **parameter property**) that both declares `field` as a class field and assigns it from the constructor argument in one line — equivalent to declaring `readonly field: string;` separately and writing `this.field = field;` in the constructor body.

## `Result<T, E>`: Modeling Failure Without Throwing

```ts
type Result<T, E> = { ok: true; value: T } | { ok: false; error: E };

function parseAge(input: string): Result<number, string> {
  const parsed = Number(input);
  if (Number.isNaN(parsed) || parsed < 0) {
    return { ok: false, error: `"${input}" is not a valid age` };
  }
  return { ok: true, value: parsed };
}

const result = parseAge("abc");
if (result.ok) {
  console.log("Parsed age:", result.value); // narrowed to { ok: true; value: number }
} else {
  console.log("Error:", result.error); // narrowed to { ok: false; error: string }
}
```

A `Result<T, E>` type (a discriminated union on `ok`, per Lesson 05) makes failure an explicit, type-checked part of a function's return type instead of an invisible `throw` a caller might forget to handle — the compiler forces the caller to check `result.ok` before accessing either `.value` or `.error`, since only one exists on each branch.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints a caught error correctly narrowed from `unknown` to `Error`, a custom `ValidationError` distinguished via `instanceof` from a generic error, and a `Result<T, E>`-based parse function demonstrating both its success and failure branches without ever throwing.

## Common Mistakes

- Assuming `catch (err)` gives you an `Error`-typed (or `any`-typed) value by default — under strict mode it's `unknown`, and using it without narrowing is a compile error.
- Forgetting `instanceof` checks can fail across certain module/realm boundaries (rare, but real) — for most single-module code this isn't a practical concern, but it's why some codebases add a `code`/`kind` discriminant field instead of relying purely on `instanceof`.
- Overusing `Result<T, E>` for truly exceptional, unrecoverable failures (a corrupted database connection) where a plain `throw` is more appropriate — `Result` shines for expected, recoverable failure modes (validation, parsing), not universally.

## Best Practices

- Always narrow a caught error (`instanceof Error`, or a custom type guard) before accessing any property on it.
- Use parameter properties (`constructor(public readonly field: string)`) to reduce boilerplate in simple data-carrying error/class constructors.
- Reach for `Result<T, E>` when a failure is an expected, common outcome a caller should be type-checked into handling; reach for `throw` when a failure is truly exceptional.

## Real-World Usage

`Result<T, E>`-style types are common in TypeScript codebases influenced by Rust/functional-language error handling, particularly for form validation and parsing pipelines where "this input is invalid" is a completely normal, frequent outcome rather than an exceptional one.

## Summary

- `catch` variables are typed `unknown` under strict mode, requiring narrowing (typically `instanceof Error`) before use.
- Parameter properties (`constructor(public readonly x: T)`) are a shorthand for declaring and assigning a class field in one line.
- `Result<T, E>` (a discriminated union) models recoverable failure as an explicit, compiler-checked return type instead of an invisible thrown exception.

## Key Terms

- **Parameter property** — a constructor parameter prefixed with an access modifier (`public`/`private`/`readonly`), which both declares and assigns a class field in one line.
- **`Result<T, E>`** — a discriminated union type representing either a successful value or an error, without throwing.

## Interview Questions

1. **What type is a caught error given in TypeScript under strict mode, and why?**
   `unknown`, not `any` or `Error` — because JavaScript's `throw` statement can throw any value at all, not just `Error` instances, TypeScript cannot safely assume a caught value has any particular shape. This forces the same narrowing discipline (`instanceof Error`, or a custom check) used for any other `unknown` value before the caught value can be used.

2. **What is a `Result<T, E>` type, and why would you use it instead of throwing?**
   A discriminated union like `{ ok: true; value: T } | { ok: false; error: E }` representing either success or failure as an explicit, type-checked return value. Unlike a thrown exception (which a caller can silently forget to catch), a `Result` return type forces the caller to check the `ok` discriminant before the compiler will let them access either `.value` or `.error` — making expected failure modes impossible to accidentally ignore.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
