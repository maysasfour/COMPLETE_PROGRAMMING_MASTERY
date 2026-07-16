# 03 — Variables and Data Types

[Back to course overview](../README.md) | [Previous: Syntax](../02-Syntax/README.md)

## Learning Objectives

- Choose correctly between `let`, `const`, and (never, in new code) `var`.
- Name and describe JavaScript's primitive types.
- Explain the difference between `null` and `undefined`.
- Use `typeof` and understand its one famous bug.
- Explain what type coercion is and where it silently happens.

## Prerequisites

[02-Syntax](../02-Syntax/README.md)

## Concept

JavaScript is **dynamically typed**: a variable itself has no fixed type, only the value currently stored in it does, and that can change. It has 7 primitive types (`number`, `string`, `boolean`, `undefined`, `null`, `bigint`, `symbol`) plus `object` (which includes arrays and functions, both technically objects). Declarations use `let` (reassignable, block-scoped), `const` (not reassignable, block-scoped), or the legacy `var` (function-scoped, hoisted, avoid in new code).

## Syntax

```js
const pi = 3.14159;      // cannot be reassigned
let count = 0;            // can be reassigned
count = count + 1;

// var age = 30;          // avoid: function-scoped and hoisted, unlike let/const
```

## Primitive Types

```js
typeof 42;          // "number"       -- one numeric type for both integers and floats
typeof "hello";      // "string"
typeof true;         // "boolean"
typeof undefined;    // "undefined"
typeof null;         // "object"      -- a decades-old bug, kept for backward compatibility
typeof 10n;          // "bigint"      -- arbitrary-precision integers
typeof Symbol("id"); // "symbol"      -- unique, non-string identifiers
typeof {};           // "object"
typeof [];           // "object"      -- arrays are objects; use Array.isArray() to detect them
typeof function(){};  // "function"
```

## `null` vs. `undefined`

```js
let a;               // declared, never assigned -> undefined
let b = null;        // explicitly assigned "no value"

console.log(a === undefined); // true
console.log(b === null);      // true
console.log(a == b);          // true  -- == treats null and undefined as loosely equal to each other
console.log(a === b);         // false -- === also checks type, and they're different types
```

`undefined` is what JavaScript gives you by default (an uninitialized variable, a missing object property, a missing function argument, a function with no `return`). `null` is a value a programmer assigns deliberately to mean "intentionally empty."

## Type Coercion

```js
"5" + 3;    // "53"  -- + with a string operand triggers string concatenation
"5" - 3;    // 2     -- -  has no string meaning, so both sides coerce to numbers
"5" == 5;   // true  -- == coerces types before comparing
"5" === 5;  // false -- === never coerces
```

Coercion is one of JavaScript's most criticized features precisely because `+` behaves differently depending on operand types, while every other arithmetic operator coerces towards numbers. This is the single strongest reason to always use `===`/`!==`.

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints the `typeof` of each primitive (including the `typeof null === "object"` quirk), demonstrates `null` vs `undefined` equality behavior under `==` and `===`, and shows several coercion results side by side with their non-coerced strict-equality counterparts.

## Common Mistakes

- Using `var`, which is function-scoped (not block-scoped) and hoisted with its declaration split from its initialization — a `var` inside an `if` block is visible outside that block, unlike `let`/`const`.
- Assuming `typeof null === "null"` — it's actually `"object"`, a bug from JavaScript's original 1995 implementation that can never be fixed without breaking the web.
- Using `==` and being surprised by results like `"" == 0` being `true` or `null == undefined` being `true` but `null == 0` being `false`.
- Forgetting that `const` prevents *reassignment*, not mutation — `const arr = []; arr.push(1);` is legal; `arr = []` is not.

## Best Practices

- Default to `const`; use `let` only when you know the variable needs reassignment; never use `var` in new code.
- Always use `===`/`!==`.
- Use `Number.isNaN()`, not the global `isNaN()`, to check for `NaN` — the global version coerces its argument first, producing surprises like `isNaN("hello")` being `true`.
- Prefer `??` (nullish coalescing, next lesson) over `||` when you specifically want to distinguish `null`/`undefined` from other falsy values like `0` or `""`.

## Real-World Usage

Type coercion bugs are a common source of subtle production issues in form-handling code, where every HTML input value arrives as a string (`"0"` is truthy even though the number `0` isn't) — this exact gap is why [TypeScript](../TypeScript/) (planned) exists, catching these mismatches before runtime.

## Summary

- `const` by default, `let` when reassignment is needed, never `var` in new code.
- 7 primitive types plus `object`; `typeof null` is a long-standing quirk returning `"object"`.
- `undefined` means "no value was ever assigned"; `null` means "deliberately assigned as empty."
- `==` coerces types before comparing; `===` never does — always prefer `===`.

## Key Terms

- **Dynamic typing** — a variable's type is determined by its current value, not declared in advance.
- **Type coercion** — automatic conversion between types, most visibly with `==` and `+`.
- **Hoisting** — `var`/function declarations being conceptually "moved" to the top of their scope during execution setup.
- **NaN** — "Not a Number," the result of an invalid numeric operation; famously not equal to itself (`NaN === NaN` is `false`).

## Interview Questions

1. **Why does `typeof null` return `"object"`?**
   It's a bug in the very first JavaScript implementation (1995): values were tagged with a type, and the tag for objects happened to be `0`, the same internal representation used for `null`, so `typeof` misreported it. It has never been fixed because doing so would break existing code that (often unknowingly) depends on the current behavior.

2. **What's the difference between `let`, `const`, and `var`?**
   `var` is function-scoped and hoisted (accessible, as `undefined`, even before its declaration line); `let`/`const` are block-scoped and inaccessible before their declaration (the "temporal dead zone"), throwing a `ReferenceError` instead of silently returning `undefined`. `const` additionally forbids reassignment of the binding itself, though it does not make the referenced object/array immutable.

3. **What causes `NaN !== NaN` to be true?**
   By the IEEE 754 floating-point and ECMAScript spec, `NaN` is defined to never equal anything, including itself — it represents "the result of an operation that doesn't have a valid numeric result," and there's no single canonical `NaN` value to compare against. Use `Number.isNaN(x)` to test for it.

## Recommended Next Lesson

[04 — Operators](../04-Operators/README.md)
