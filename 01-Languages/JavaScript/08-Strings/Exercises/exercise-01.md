# Exercise 01 — Slug Generator

[Back to lesson](../README.md)

## Task

Write a function `slugify(title)` that converts a title string into a URL-friendly "slug":

- Trim leading/trailing whitespace.
- Lowercase everything.
- Replace any run of whitespace with a single hyphen.
- Remove any character that isn't a lowercase letter, digit, or hyphen.
- Collapse multiple consecutive hyphens into one, and strip leading/trailing hyphens.

## Constraints

- Use only string methods and/or a single regular expression per transformation step — no manual character-by-character loops.
- `slugify("  Hello, World!  ")` must return `"hello-world"`.
- `slugify("What's New in JavaScript 2026?")` must return `"whats-new-in-javascript-2026"`.

## Starter Code

```js
function slugify(title) {
  return title
    .trim()
    .toLowerCase();
    // continue the chain here
}

console.log(slugify("  Hello, World!  "));
console.log(slugify("What's New in JavaScript 2026?"));
```

## Expected Output

```
hello-world
whats-new-in-javascript-2026
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.js](../Solutions/solution-01.js).
