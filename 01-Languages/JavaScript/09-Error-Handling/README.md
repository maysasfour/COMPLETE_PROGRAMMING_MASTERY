# 09 — Error Handling

[Back to course overview](../README.md) | [Previous: Strings](../08-Strings/README.md)

## Learning Objectives

- Use `try`/`catch`/`finally` correctly.
- Throw and catch custom error types by extending `Error`.
- Understand how errors propagate through synchronous call stacks vs. Promises.
- Know when to let an error propagate versus when to handle it locally.

## Prerequisites

[08-Strings](../08-Strings/README.md)

## Concept

JavaScript uses exceptions for error handling, the same general model as Python. `throw` can technically throw *any* value (a string, a number, an object), but the idiomatic and strongly recommended approach is to always throw an `Error` (or subclass), because only `Error` instances carry a `.stack` trace, which is essential for debugging.

## Syntax

```js
try {
  riskyOperation();
} catch (err) {
  console.error("Something went wrong:", err.message);
} finally {
  console.log("Runs whether or not an error was thrown");
}
```

`finally` always runs — whether the `try` block succeeded, threw, or even if a `return` happened inside `try`/`catch`. It's the right place for cleanup (closing a file handle, releasing a lock) that must happen regardless of outcome.

## Custom Error Types

```js
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = "ValidationError"; // otherwise err.name would just say "Error"
    this.field = field;
  }
}

function validateAge(age) {
  if (age < 0) {
    throw new ValidationError("Age cannot be negative", "age");
  }
  return age;
}

try {
  validateAge(-5);
} catch (err) {
  if (err instanceof ValidationError) {
    console.log(`Validation failed on field "${err.field}": ${err.message}`);
  } else {
    throw err; // re-throw anything we didn't specifically anticipate
  }
}
```

`instanceof` lets calling code distinguish error types and handle each appropriately — a `ValidationError` might be shown to a user directly, while an unexpected `TypeError` should probably be logged and shown as a generic failure instead.

## Catching Specific Errors, Re-throwing the Rest

A `catch` block in JavaScript has no per-type filtering syntax (unlike Python's `except SpecificError:`) — you catch everything and branch manually with `instanceof`, re-throwing what you don't intend to handle, exactly as shown above. Swallowing every error indiscriminately (an empty `catch {}`) hides real bugs, including ones that have nothing to do with what you were trying to guard against.

## Errors in Promises

```js
async function loadUser(id) {
  if (id <= 0) throw new Error("Invalid id");
  return { id, name: "Ada" };
}

async function main() {
  try {
    const user = await loadUser(-1);
    console.log(user);
  } catch (err) {
    console.log("Caught from an async function:", err.message);
  }
}
```

`try`/`catch` works around `await`ed calls exactly like synchronous code — this is one of the biggest ergonomic wins `async`/`await` (Lesson 14) has over raw `.then()`/`.catch()` chains.

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints a `finally` block running after a caught error, a custom `ValidationError` being distinguished from a generic error via `instanceof`, an unrecognized error type being re-thrown and caught one level up, and an async function's thrown error being caught with a plain `try`/`catch` around an `await`.

## Common Mistakes

- Throwing plain strings/objects instead of `Error` instances, losing the `.stack` trace needed for debugging.
- An empty `catch {}` block that silently swallows every error, including ones unrelated to what you intended to guard against.
- Forgetting that a `finally` block's own `return`/`throw` overrides whatever the `try`/`catch` was about to do — a `finally` with a `return` inside it is a well-known footgun.
- Not distinguishing error types with `instanceof`, treating every failure identically regardless of whether it's recoverable.

## Best Practices

- Always throw `Error` (or a subclass), never a bare string or plain object.
- Give custom error classes a distinct `this.name` in the constructor, since `console.log`/stack traces otherwise report every custom error as generically `"Error"`.
- Catch only the errors you can meaningfully handle; re-throw the rest.
- Use `finally` strictly for cleanup, not for flow control (don't `return` from inside it).

## Real-World Usage

Custom error classes (`ValidationError`, `NotFoundError`, `AuthenticationError`) are the standard way backend frameworks ([04-Backend-Development](../../../04-Backend-Development/)) distinguish error categories to map them to correct HTTP status codes (400, 404, 401) in a single centralized error-handling middleware, rather than duplicating that logic at every route.

## Summary

- `try`/`catch`/`finally` is JavaScript's exception-handling structure; `finally` always runs.
- Always throw `Error` or a subclass, never a bare value, to preserve stack traces.
- `instanceof` distinguishes error types since JavaScript has no per-type `catch` syntax; re-throw errors you don't specifically handle.
- `try`/`catch` works transparently around `await`ed calls inside `async` functions.

## Key Terms

- **Exception** — an error thrown during execution, propagating up the call stack until caught.
- **Custom error class** — a class extending `Error`, adding a distinct `name` and any extra context fields.
- **Re-throw** — deliberately throwing an already-caught error again, typically after deciding it isn't the kind you can handle here.

## Review Questions

1. Why does a `finally` block run even if the `try` block returns?
2. Why should you always throw `Error` instances instead of plain strings?
3. How do you distinguish between different error types in a single `catch` block?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **Why is it bad practice to `throw` a plain string instead of an `Error` object?**
   An `Error` instance automatically captures a `.stack` property recording the call stack at the moment it was created, which is essential for tracing where and why a failure happened. A thrown string has no stack trace at all, making the exact same failure far harder to debug in production.

2. **What does `finally` guarantee, and what's the classic bug with it?**
   `finally` runs regardless of whether the `try` block succeeded, threw, or returned — making it the right place for cleanup that must always happen. The classic bug is putting a `return` (or `throw`) inside `finally` itself: it silently overrides any `return`/`throw` from the `try`/`catch` blocks, which is almost never the intended behavior.

3. **How do you handle different error types differently in JavaScript, given there's no `except SpecificError:` syntax?**
   Catch everything in one `catch` block, then use `instanceof` to check the error's actual type/class and branch accordingly, re-throwing (`throw err;`) any error type you didn't anticipate so it isn't silently swallowed.

## Recommended Next Lesson

[10 — File Handling](../10-File-Handling/README.md)
