# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Branch with `if`/`else if`/`else` and `switch`.
- Choose correctly between `for`, `for...of`, `for...in`, and `while`.
- Explain JavaScript's truthy/falsy rules.
- Use `break`/`continue` correctly, including with labeled loops.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Like Python, JavaScript lets any value act as a condition, not just booleans — but its falsy set is different (and stricter) than Python's. JavaScript has three distinct `for` forms plus `while`, each suited to a different iteration shape, unlike Python's single unified `for`.

## Truthy / Falsy

JavaScript's exact list of **falsy** values (everything else is truthy):

```
false, 0, -0, 0n, "", null, undefined, NaN
```

Notably, `[]` and `{}` are **truthy** in JavaScript — unlike Python, where an empty list/dict is falsy. This is a frequent source of bugs for developers moving between the two languages.

```js
if ([]) {
  console.log("this runs -- an empty array is truthy in JS");
}
```

## `if` / `else if` / `else`

```js
const temperature = 15;
if (temperature > 30) {
  console.log("hot");
} else if (temperature > 15) {
  console.log("warm");
} else {
  console.log("cool");
}
```

## `switch`

```js
switch (day) {
  case "Sat":
  case "Sun":                 // fall-through: both cases share this block
    console.log("weekend");
    break;                    // without break, execution falls into the next case
  default:
    console.log("weekday");
}
```

Forgetting `break` is one of the most common `switch` bugs — without it, execution "falls through" into the next case's code regardless of whether its condition matched.

## `for`, `for...of`, `for...in`, `while`

```js
for (let i = 0; i < 3; i++) {  // classic counter loop
  console.log(i);
}

for (const fruit of ["apple", "banana"]) {  // iterates VALUES -- use for arrays/strings/Maps/Sets
  console.log(fruit);
}

for (const key in { a: 1, b: 2 }) {  // iterates KEYS (as strings) -- for objects, not arrays
  console.log(key);
}

let count = 0;
while (count < 3) {
  console.log(count);
  count++;
}
```

`for...in` on an array technically works but iterates *index keys as strings* (`"0"`, `"1"`, ...) and also walks inherited enumerable properties — `for...of` is almost always the right choice for arrays instead.

## `break` / `continue` / Labeled Loops

```js
outer: for (let i = 0; i < 3; i++) {
  for (let j = 0; j < 3; j++) {
    if (j === 1) continue outer;  // labeled continue: skips to the next i, not just the next j
    console.log(i, j);
  }
}
```

Labels let `break`/`continue` target an outer loop directly — JavaScript has no loop `else` clause like Python's, so this is the closest equivalent tool for controlling nested loops precisely.

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints results demonstrating truthy `[]`/`{}`, a `switch` with intentional fall-through, all three `for` forms, and a labeled `continue` skipping to the outer loop's next iteration.

## Common Mistakes

- Forgetting `break` in a `switch`, causing unintended fall-through.
- Using `for...in` on an array instead of `for...of`, picking up index-as-string keys and any inherited enumerable properties.
- Assuming `[]`/`{}` are falsy (true in Python, false in JavaScript).
- Writing an infinite `while (true)` loop without a reachable `break`.

## Best Practices

- Always include `break` in `switch` cases unless fall-through is deliberate and commented as such.
- Use `for...of` for arrays/iterables, `for...in` only for plain-object keys (and even then, `Object.keys()`/`Object.entries()` with `for...of` is often clearer).
- Prefer array methods (`.forEach`, `.map`, `.filter` — Lesson 07) over manual loops when transforming/filtering data, reserving raw loops for cases that need early exit or side effects mid-iteration.

## Real-World Usage

`for...of` over `Object.entries(obj)` is the standard modern pattern for iterating key/value pairs; `switch` remains common for parsing a small closed set of string discriminants (HTTP methods, action types in a Redux-style reducer).

## Summary

- JavaScript's falsy set is `false, 0, -0, 0n, "", null, undefined, NaN` — `[]` and `{}` are truthy, unlike Python.
- `switch` requires explicit `break` to avoid fall-through.
- `for...of` iterates values (arrays, strings, Maps, Sets); `for...in` iterates object keys — don't mix them up.
- Labeled `break`/`continue` control nested loops precisely; there is no loop `else` clause.

## Key Terms

- **Falsy** — a value that coerces to `false` in a boolean context.
- **Fall-through** — `switch` execution continuing into the next `case` because a `break` was omitted.
- **Labeled statement** — a named loop (`outer:`) that `break`/`continue` can target directly from a nested loop.

## Review Questions

1. Why is `if ([])` true in JavaScript but would be false for an equivalent check in Python?
2. What happens if you omit `break` from every case in a `switch`?
3. When would `for...in` produce different results than `for...of` on the same array?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What are all of JavaScript's falsy values?**
   `false`, `0`, `-0`, `0n` (BigInt zero), `""` (empty string), `null`, `undefined`, and `NaN`. Every other value, including `[]` and `{}`, is truthy.

2. **What's the difference between `for...of` and `for...in`?**
   `for...of` iterates over the *values* of an iterable (arrays, strings, `Map`, `Set`). `for...in` iterates over the *enumerable property keys* (as strings) of an object, including inherited ones — using it on an array gives you index strings, not values, and is generally discouraged for that reason.

3. **What happens if a `switch` case doesn't have a `break`?**
   Execution "falls through" into the next case's statements regardless of whether that case's value matches, continuing until a `break` is hit or the `switch` ends. This is sometimes used deliberately to group cases (e.g., multiple day names both leading to "weekend"), but is a common source of bugs when accidental.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
