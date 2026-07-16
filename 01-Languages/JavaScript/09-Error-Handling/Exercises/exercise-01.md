# Exercise 01 — A Small Validation Library

[Back to lesson](../README.md)

## Task

Define two custom error classes, `RequiredFieldError` and `TypeMismatchError`, both extending `Error` with a correctly set `.name`. Then write `validateUser(data)` that checks a plain object `{ name, age }` and:

- Throws `RequiredFieldError` if `name` is missing/empty or `age` is `undefined`.
- Throws `TypeMismatchError` if `age` is not a number.
- Throws `RequiredFieldError` if `age` is negative (treat it as "a valid age was required, and this isn't one").
- Returns the validated `{ name, age }` object unchanged if everything passes.

Finally, write `describeValidationError(err)` that takes any caught error and returns a human-readable string, using `instanceof` to distinguish the two custom types from any unrelated error, which it should re-throw instead of describing.

## Constraints

- Both custom error classes must set `this.name` in their constructors.
- `describeValidationError` must not catch/swallow an error it doesn't recognize — it re-throws it.

## Starter Code

```js
class RequiredFieldError extends Error { /* ... */ }
class TypeMismatchError extends Error { /* ... */ }

function validateUser(data) {
  // your checks here
  return data;
}

function describeValidationError(err) {
  // instanceof checks + re-throw for anything else
}
```

## Expected Output

For `validateUser({ name: "", age: 30 })`, `describeValidationError` should report a required-field problem naming `"name"`. For `validateUser({ name: "Ada", age: "old" })`, it should report a type-mismatch problem naming `"age"`. For `validateUser({ name: "Ada", age: 30 })`, no error is thrown at all and the object is returned as-is.

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.js](../Solutions/solution-01.js).
