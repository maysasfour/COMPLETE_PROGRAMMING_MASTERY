# Solution 01 — A Small Validation Library

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- Both `RequiredFieldError` and `TypeMismatchError` extend `Error` and set `this.name` in their constructor — without that line, `err.name` would report the generic `"Error"` for both, making them indistinguishable in logs even though `instanceof` still works correctly.
- `validateUser` checks in a deliberate order: missing `name` first, then missing `age`, then `age`'s type, then `age`'s value — each check assumes the previous ones passed, so a wrong-type `age` never reaches the negative-number check (which would crash comparing a string with `<`).
- `describeValidationError` uses `instanceof` to branch, and **re-throws** anything that isn't one of the two recognized types — this is the "catch what you can handle, propagate the rest" pattern from the lesson, verified explicitly at the bottom of the solution file with an unrelated `TypeError`.

## Verification

Ran with `node Solutions/solution-01.js`; actual output:

```
Missing or invalid required field: "name" (name is required)
Type mismatch on field: "age" (age must be a number)
Valid: { name: 'Ada', age: 30 }
Correctly re-thrown, not described: TypeError - unrelated failure
```

Matches all three cases from the exercise (empty name, wrong-type age, fully valid input) plus confirms an unrecognized error type is genuinely re-thrown rather than silently described as something it isn't.
