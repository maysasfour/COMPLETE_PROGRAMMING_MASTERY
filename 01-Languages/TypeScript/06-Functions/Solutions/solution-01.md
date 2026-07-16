# Solution 01 — An Overloaded `wrapInArray` Function

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- The two overload signatures (`value: T` and `value: T[]`) both promise a return type of `T[]` to callers — the difference is purely in what's accepted as input, which is enough for TypeScript to type-check each call site correctly regardless of which overload matched.
- The implementation signature `(value: T | T[]): T[]` uses `Array.isArray(value)` — a genuine runtime check — to decide whether to wrap the value or return it unchanged, exactly the narrowing discipline from Lesson 05 applied inside a generic function.
- No `as` assertion was needed anywhere: `Array.isArray` is a real type guard recognized by TypeScript, narrowing `value` to `T[]` in the `true` branch and to `T` in the `false` branch automatically.

## Verification

Ran with `tsc Solutions/solution-01.ts --strict --target ES2022 --skipLibCheck && node Solutions/solution-01.js`; actual output:

```
single: 1 item(s)
already-array: 3 item(s)
single-string: 1 item(s)
```

The first two lines match the exercise's expected output exactly. A third case (wrapping a single string) was added to confirm the generic `<T>` genuinely works across different element types, not just numbers.
