# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use arithmetic, comparison, and logical operators correctly.
- Explain why `===`/`!==` are preferred over `==`/`!=`.
- Use the nullish coalescing operator (`??`) and optional chaining (`?.`) to write safer, shorter code.
- Understand short-circuit evaluation.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Operators combine one or more expressions into a new value. JavaScript's comparison operators come in coercing (`==`, `!=`) and non-coercing (`===`, `!==`) pairs — a design choice most other mainstream languages don't have — and its logical operators (`&&`, `||`) return one of their *operands*, not necessarily a boolean, which is what makes patterns like `user.name || "Guest"` work.

## Syntax

```js
// Arithmetic
5 + 3; 5 - 3; 5 * 3; 5 / 3; 5 % 3; 5 ** 2; // ** is exponentiation

// Comparison
5 === "5";  // false: strict, no coercion
5 == "5";   // true:  loose, coerces
5 !== 5;    // false
5 < 10;

// Logical
true && false;  // false
true || false;  // true
!true;          // false

// Nullish coalescing: only null/undefined trigger the fallback
const value = input ?? "default";

// Optional chaining: short-circuits to undefined instead of throwing
const city = user?.address?.city;
```

## Short-Circuit Evaluation and Non-Boolean Results

```js
const name = "" || "Guest";     // "Guest" -- "" is falsy, so the right side is returned
const count = 0 ?? 5;           // 0       -- 0 is NOT null/undefined, so the left side is kept
```

This is the key difference between `||` and `??`: `||` falls back on *any* falsy value (`0`, `""`, `false`, `NaN`, `null`, `undefined`), while `??` falls back only on `null`/`undefined`. Using `||` for a numeric default is a classic bug — `settings.volume || 50` silently replaces a deliberately-set volume of `0` with `50`.

## Optional Chaining in Practice

```js
const user = { profile: null };
console.log(user.profile.bio);   // throws: Cannot read properties of null
console.log(user.profile?.bio);  // undefined -- short-circuits safely instead of throwing
```

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints results for arithmetic, the `==`/`===` contrast, `||` vs `??` on a zero value, and demonstrates `?.` preventing a `TypeError` that a plain `.` access would throw.

## Common Mistakes

- Using `||` for numeric/boolean defaults, which incorrectly overrides deliberately-falsy values like `0`, `""`, or `false`.
- Using `==`/`!=` out of habit from other languages, hitting coercion surprises like `[] == false` being `true`.
- Forgetting operator precedence and relying on it for complex boolean expressions instead of adding parentheses for clarity.
- Chaining `?.` past the point where it's meaningful — `a?.b.c` still throws if `a.b` exists but is `null` and `c` is accessed without its own `?.`.

## Best Practices

- Always use `===`/`!==`.
- Use `??` instead of `||` whenever `0`, `""`, or `false` are legitimate, intentional values that shouldn't be treated as "missing."
- Use `?.` when accessing a chain of properties that might not exist, especially on data from an external API.
- Add parentheses to clarify precedence in any expression mixing `&&`/`||`, even where technically unnecessary.

## Real-World Usage

`?.` and `??` were added in ES2020 specifically because handling possibly-missing nested API response fields (`response.data?.user?.profile?.bio ?? "No bio"`) was extremely verbose before them, requiring manual `if` checks at every level.

## Summary

- `===`/`!==` never coerce; `==`/`!=` do — prefer strict everywhere.
- `||` falls back on any falsy value; `??` falls back only on `null`/`undefined` — pick based on whether `0`/`""`/`false` are valid values.
- `?.` short-circuits to `undefined` instead of throwing when accessing a property on `null`/`undefined`.

## Key Terms

- **Coercion** — automatic type conversion, performed by `==`/`!=` and by `+`/`-` etc. across mismatched types.
- **Short-circuit evaluation** — `&&`/`||` stop evaluating as soon as the result is determined, without evaluating the remaining operand.
- **Nullish coalescing (`??`)** — returns the right operand only if the left is `null` or `undefined`.
- **Optional chaining (`?.`)** — short-circuits an entire property-access chain to `undefined` if any link is `null`/`undefined`.

## Interview Questions

1. **What's the difference between `||` and `??`?**
   `||` returns its right operand if the left is *any* falsy value (`0`, `""`, `false`, `NaN`, `null`, `undefined`). `??` returns its right operand only if the left is specifically `null` or `undefined`, leaving other falsy values like `0` or `""` untouched — important when `0`/`""` are valid, intentional values.

2. **What does `?.` (optional chaining) do?**
   It short-circuits a property-access or method-call chain: if the value immediately before `?.` is `null` or `undefined`, the whole expression evaluates to `undefined` instead of throwing a `TypeError`, without needing to check each level manually.

3. **Why is `===` preferred over `==`?**
   `==` performs type coercion before comparing, producing results that are easy to get wrong (`"" == 0` is `true`, `null == undefined` is `true` but `null == 0` is `false`). `===` never coerces, making comparisons predictable and matching what most developers actually intend.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
