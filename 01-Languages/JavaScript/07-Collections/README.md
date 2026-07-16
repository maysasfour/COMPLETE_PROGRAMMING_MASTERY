# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use arrays and objects as JavaScript's two core collection types.
- Use `Map` and `Set` where they're a better fit than a plain object/array.
- Transform data with `map`/`filter`/`reduce` instead of manual loops.
- Destructure arrays and objects, and use the spread operator to copy/merge them.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

JavaScript has two general-purpose collection types built into the language's syntax — arrays (ordered, index-based) and objects (key-based, keys coerced to strings) — plus two ES6 additions, `Map` (key-based, keys can be *any* type, preserves insertion order, has a real `.size`) and `Set` (unique values, preserves insertion order). Arrays come with a rich set of higher-order methods (`map`, `filter`, `reduce`, and more) that are the idiomatic way to transform data, replacing most manual `for` loops for that purpose.

## Arrays

```js
const numbers = [1, 2, 3, 4, 5];

numbers.push(6); numbers.pop();          // add/remove from the end
numbers.unshift(0); numbers.shift();     // add/remove from the start

const doubled = numbers.map(n => n * 2);           // new array, same length
const evens = numbers.filter(n => n % 2 === 0);    // new array, same or shorter
const total = numbers.reduce((acc, n) => acc + n, 0); // single accumulated value
const found = numbers.find(n => n > 3);            // first match, or undefined
const hasEven = numbers.some(n => n % 2 === 0);    // true if ANY element matches
const allPositive = numbers.every(n => n > 0);     // true if ALL elements match
```

`map`/`filter`/`reduce` never mutate the original array — they return a new one. This is the idiomatic, predictable style; mutating methods (`push`, `sort`, `splice`, `reverse`) change the array in place and should be used deliberately, not accidentally.

## Objects

```js
const user = { name: "Ada", age: 30 };
user.age = 31;                 // mutate an existing property
user.email = "ada@example.com"; // add a new property
delete user.email;              // remove a property

Object.keys(user);    // ["name", "age"]
Object.values(user);  // ["Ada", 31]
Object.entries(user); // [["name", "Ada"], ["age", 31]]
```

## Destructuring and Spread

```js
const [first, second, ...rest] = [1, 2, 3, 4]; // first=1, second=2, rest=[3,4]
const { name, age } = user;                     // pulls out named properties

const arrCopy = [...numbers];        // shallow copy
const merged = { ...user, age: 32 }; // shallow copy with an override
```

Both `...` uses (destructuring's rest, and spread) are only **shallow** — nested objects/arrays inside are still shared by reference between the original and the copy.

## `Map` and `Set`

```js
const scores = new Map();
scores.set("Ada", 95);
scores.set("Lin", 88);
scores.get("Ada");   // 95
scores.has("Lin");   // true
scores.size;         // 2

const uniqueTags = new Set(["js", "css", "js", "html"]); // {"js", "css", "html"} -- duplicates removed
uniqueTags.has("css"); // true
```

Reach for `Map` over a plain object when keys aren't naturally strings, when insertion order matters and must be guaranteed, or when you need a reliable `.size`. Reach for `Set` whenever "does this collection contain duplicates" or "give me only the unique values" comes up — `[...new Set(array)]` is the standard one-line dedupe idiom.

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints results for array transformation methods (`map`/`filter`/`reduce`/`find`/`some`/`every`), object key/value/entry extraction, destructuring with rest, spread-based shallow copies (including a demonstration that nested objects are still shared), and `Map`/`Set` usage including the one-line array-dedupe idiom.

## Common Mistakes

- Using `map` when you actually want `forEach` (a side effect, no transformation) — `map`'s return value should always be used; if you're not using it, `forEach` or a `for...of` loop signals intent better.
- Forgetting spread/rest copies are shallow — mutating a nested object inside a "copy" also mutates the original.
- Using a plain object as a `Map` and being surprised numeric-looking keys get stringified, or that insertion order for integer-like keys can differ from insertion order for others.
- Comparing two arrays/objects with `===` expecting structural equality — it's always reference equality for these types.

## Best Practices

- Prefer `map`/`filter`/`reduce` over manual loops for pure data transformations; keep manual loops for cases needing early exit or side effects.
- Use `const` for arrays/objects you don't reassign (you can still mutate their contents) — this documents intent even though `const` doesn't freeze the value.
- Use `Object.freeze()` when you need actual immutability (shallow only — nested objects are still mutable unless frozen themselves).
- Prefer `[...new Set(arr)]` for deduping over manual loop-based approaches.

## Real-World Usage

`map`/`filter`/`reduce` chains are the standard way to shape API response data for rendering in frontend frameworks (`data.filter(...).map(...)`), and `Map`/`Set` show up constantly in algorithmic code (frequency counting, adjacency lists, deduplication) covered in [08-Data-Structures-and-Algorithms](../../../08-Data-Structures-and-Algorithms/).

## Performance Considerations

`Array.prototype.includes()`/`indexOf()` on a large array is O(n) per lookup; a `Set` gives O(1) average-case membership checks, which matters when checking membership repeatedly inside a loop (turning an O(n²) pattern into O(n)).

## Summary

- Arrays are ordered and index-based; objects are key-based with string(-coercible) keys; `Map`/`Set` are ES6 additions for any-type keys and guaranteed uniqueness respectively.
- `map`/`filter`/`reduce` are the idiomatic, non-mutating way to transform arrays.
- Destructuring and spread are convenient but only shallow-copy.
- `Set` gives O(1) average membership checks versus O(n) for array `.includes()`.

## Key Terms

- **Higher-order function** — a function that takes another function as an argument (`map`, `filter`, `reduce` all qualify).
- **Shallow copy** — a copy where the top-level structure is new but nested objects/arrays are still shared references.
- **`Map`** — an ES6 key-value collection allowing any key type, with guaranteed insertion order and a real `.size`.
- **`Set`** — an ES6 collection of unique values, with guaranteed insertion order.

## Review Questions

1. Why does `map` never mutate the original array, and why does that matter?
2. When would you choose `Map` over a plain object for key-value storage?
3. Why is `[...new Set(arr)]` the standard array-dedupe idiom?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between `map` and `forEach`?**
   `map` returns a new array built from transforming each element, and is meant to be used for its return value. `forEach` returns `undefined` and exists purely to run a side effect per element (logging, pushing into an external array, etc.) — using `map` and discarding its result is a common code-smell signal that `forEach` was intended.

2. **When would you use a `Map` instead of a plain object?**
   When keys aren't naturally strings (objects, functions, or other reference types as keys), when guaranteed insertion-order iteration matters, or when you need a reliable `.size` without manually tracking a count — plain objects can technically be used as maps but were not designed for it and have subtle edge cases (e.g., a key literally named `"__proto__"`).

3. **How would you remove duplicates from an array in one line?**
   `[...new Set(array)]` — `Set` automatically drops duplicate values on insertion, and the spread operator expands it back into a plain array, preserving insertion order.

4. **What's the difference between `reduce` and `filter`/`map`?**
   `map` and `filter` always return arrays (same length, or same-or-shorter, respectively). `reduce` can produce *any* single value — a number, an object, a string, even another array — by folding the array down via an accumulator function, making it the most general (and often least readable) of the three.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
