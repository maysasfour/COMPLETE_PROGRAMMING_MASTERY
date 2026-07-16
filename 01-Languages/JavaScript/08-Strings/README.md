# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use template literals instead of concatenation.
- Use the most common string methods for searching, slicing, and transforming text.
- Explain why strings are immutable in JavaScript.
- Convert between strings and arrays with `split`/`join`.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

Strings in JavaScript are **immutable** — every "string method" (`.toUpperCase()`, `.slice()`, `.replace()`) returns a brand-new string; none of them modify the original in place. This is the same immutability model Python strings have, and for the same reason: it makes strings safe to share freely without defensive copying.

## Syntax: Template Literals

```js
const name = "Ada";
const age = 30;
console.log(`${name} is ${age} years old`); // "Ada is 30 years old"
console.log(`Next year: ${age + 1}`);       // expressions work directly inside ${}

const multiline = `Line one
Line two`; // template literals also support real line breaks with no \n needed
```

Template literals (backtick strings) replace both string concatenation and most uses of `.format()`/`%`-style formatting from other languages — any expression can go inside `${}`, not just variables.

## Common String Methods

```js
"  hello  ".trim();          // "hello"           -- removes leading/trailing whitespace
"hello".toUpperCase();        // "HELLO"
"HELLO".toLowerCase();        // "hello"
"hello world".includes("wor"); // true
"hello world".startsWith("hello"); // true
"hello world".indexOf("world");    // 6
"hello".slice(1, 3);           // "el"             -- like Python slicing, stop is exclusive
"hello".replace("l", "L");     // "heLlo"          -- replaces only the FIRST match
"hello".replaceAll("l", "L");  // "heLLo"          -- replaces every match (ES2021+)
"a,b,c".split(",");            // ["a", "b", "c"]
["a", "b", "c"].join("-");     // "a-b-c"
"abc".padStart(5, "0");        // "00abc"
```

## Strings Are Immutable

```js
let greeting = "hello";
greeting.toUpperCase();     // returns "HELLO" -- but doesn't change `greeting`
console.log(greeting);      // still "hello"

greeting = greeting.toUpperCase(); // must reassign to actually update the variable
console.log(greeting);              // now "HELLO"
```

This is a very common beginner mistake: calling a string method and expecting the original variable to change, when every string method returns a new string that must be captured (reassigned or used directly) to have any effect.

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints template literal interpolation (including an inline expression), results from the common string methods above (search, slice, replace vs. replaceAll, split/join, padStart), and a demonstration that calling `.toUpperCase()` without reassigning leaves the original variable unchanged.

## Common Mistakes

- Calling a string method and expecting in-place mutation, forgetting the result must be captured.
- Using `.replace()` when `.replaceAll()` (or a global regex) is actually needed, and being surprised only the first occurrence changed.
- String concatenation with `+` across many pieces instead of a single template literal, hurting readability.
- Off-by-one errors with `.slice(start, end)` — like array slicing and Python, `end` is exclusive.

## Best Practices

- Use template literals for any string built from more than one static piece plus a variable.
- Use `.replaceAll()` (or a `/g` regex with `.replace()`) whenever every occurrence should change, not just the first.
- Use `.trim()` on any user-supplied text before validating or comparing it, to avoid whitespace-only false negatives.
- Prefer `.includes()` over `.indexOf(x) !== -1` for a plain existence check — it reads more directly as a boolean question.

## Real-World Usage

Template literals are the standard way to build dynamic UI strings, log messages, and SQL/HTTP query fragments (though never for interpolating untrusted user input directly into SQL or shell commands — see [16-Security](../../../16-Security/) on injection attacks); `.split`/`.join` are the everyday tools for parsing and rebuilding delimited text like CSV rows or URL query strings.

## Security Considerations

Never build a SQL query or shell command by directly interpolating user input into a template literal — this is exactly how SQL injection and command injection happen. Use parameterized queries and proper escaping/argument arrays instead (covered in [07-Databases](../../../07-Databases/) and [16-Security](../../../16-Security/)).

## Summary

- Strings are immutable; every method returns a new string that must be captured to have an effect.
- Template literals (`` `${}` ``) are the idiomatic way to build dynamic strings, supporting arbitrary expressions and real line breaks.
- `.replace()` changes only the first match; `.replaceAll()` changes every match.
- `.split`/`.join` convert between strings and arrays; `.slice` uses exclusive end indices, matching array/Python conventions.

## Key Terms

- **Immutability (strings)** — no string method changes the original string; each returns a new one.
- **Template literal** — a backtick-delimited string supporting `${expression}` interpolation and real line breaks.

## Review Questions

1. Why does `greeting.toUpperCase();` on its own line have no visible effect?
2. What's the difference between `.replace()` and `.replaceAll()`?
3. Why is `.slice(1, 3)` two characters long, not three?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **Why are strings immutable in JavaScript, and what does that mean practically?**
   Every string method returns a new string rather than modifying the original in place, which makes strings safe to pass around and share without defensive copying (no other code can ever mutate a string out from under you). Practically, it means you must always capture (reassign, or use directly) the result of a string method — calling one and discarding the result changes nothing.

2. **What's the difference between `.replace()` and `.replaceAll()`?**
   `.replace(search, replacement)` with a plain string `search` argument replaces only the first occurrence. `.replaceAll()` (ES2021+) replaces every occurrence. `.replace()` with a regex that has the global (`/g`) flag also replaces every match — `.replaceAll()` was added mainly to make the "replace everything" case obvious without needing a regex.

3. **How would you check if a string contains a substring, and how did people do it before `.includes()` existed?**
   `"hello world".includes("wor")` is the modern, readable way. Before ES2015, the idiom was `"hello world".indexOf("wor") !== -1`, checking that the substring's index isn't the "not found" sentinel value `-1`.

## Recommended Next Lesson

Lessons 09 onward (Error Handling, File Handling, OOP, Functional Concepts, Async/Concurrency, Modules, Database Access, API Integration, Testing, Best Practices) are not yet built for JavaScript — see [BUILD_STATUS.md](../../../BUILD_STATUS.md). Until then, apply what you've learned in [03-Frontend-Development](../../../03-Frontend-Development/), which builds directly on JavaScript fundamentals with browser-specific APIs (the DOM, `fetch`, events).
