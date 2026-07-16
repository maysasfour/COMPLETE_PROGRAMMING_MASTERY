# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Distinguish statements from expressions.
- Understand semicolons and Automatic Semicolon Insertion (ASI), and why relying on ASI is discouraged.
- Write comments correctly.
- Understand strict mode and why modules use it implicitly.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

JavaScript source is a sequence of **statements** (do something: declare a variable, run a loop, branch with `if`) built from **expressions** (produce a value: `2 + 2`, a function call, a comparison). Almost anything that produces a value is an expression, and expressions can be nested inside statements — `if (isValid(user))` uses a function-call expression as the condition of an `if` statement.

## Syntax

```js
// single-line comment
/* multi-line
   comment */

let x = 5;        // statement (declaration)
x + 1;            // expression statement (value produced, then discarded)
console.log(x);   // statement containing a call expression
```

### Semicolons and ASI

```js
let a = 1
let b = 2
console.log(a + b) // works: ASI inserts semicolons at line breaks in most cases
```

JavaScript can technically run without semicolons because the parser inserts them automatically at certain line breaks (**Automatic Semicolon Insertion**). This course writes semicolons explicitly anyway, because ASI has documented edge cases — most famously, a line starting with `(` or `[` can get merged with the previous line instead of starting a new statement:

```js
let x = 1
[1, 2, 3].forEach(n => console.log(n))
// ASI does NOT insert a semicolon after `1` here -- this parses as
// `let x = 1[1, 2, 3].forEach(...)`, a single statement, and throws a runtime error.
```

### Strict Mode

```js
"use strict";
// or, implicitly, inside any ES module (a file using import/export)
```

Strict mode disables several error-prone legacy behaviors (like silently creating a global variable when you forget `let`/`const`). Every ES module is strict by default; this course uses explicit `let`/`const` everywhere, which sidesteps most of what strict mode protects against regardless.

## Simple Example

```js
console.log(2 + 2); // expression `2 + 2` inside a statement
```

## Detailed Example

See [example.js](example.js) — demonstrates the statement/expression distinction and an ASI pitfall.

## Expected Output

Running `node example.js` prints the results of several expressions and demonstrates that a missing semicolon before a line starting with `[` or `(` changes what actually executes, confirmed by a `try`/`catch` around the risky pattern.

## Common Mistakes

- Relying on ASI and then hitting the `(`/`[`-at-start-of-line pitfall shown above.
- Writing a comment intending it to disable a whole block but only closing `/* */` around part of it, accidentally re-enabling code partway through.
- Assuming JavaScript requires semicolons the way C/Java do (it doesn't, strictly) or the reverse — believing they never matter (they do, in specific cases).

## Best Practices

- Write semicolons explicitly at the end of every statement — don't rely on ASI, even though it usually works.
- Prefer `let`/`const` everywhere, which avoids the specific footguns strict mode targets and produces clearer error messages when you actually forget a declaration.
- Use `//` for short comments and reserve `/* */` for larger blocks, watching nesting carefully since `/* */` comments do not nest.

## Real-World Usage

Every linter (ESLint) and formatter (Prettier) used in professional JavaScript codebases enforces consistent semicolon usage precisely because of the ASI edge cases shown above — this is one of the most commonly linted rules in the ecosystem.

## Summary

- Statements do things; expressions produce values; expressions nest inside statements.
- ASI lets JavaScript run without semicolons in most cases, but has documented edge cases around lines starting with `(` or `[`.
- Explicit semicolons avoid relying on ASI's edge-case behavior.

## Key Terms

- **Statement** — an instruction that performs an action.
- **Expression** — code that evaluates to a value.
- **ASI (Automatic Semicolon Insertion)** — the parser's rules for inserting semicolons when they're omitted.
- **Strict mode** — a stricter parsing/execution mode that disables several legacy JavaScript behaviors.

## Interview Questions

1. **Are semicolons required in JavaScript?**
   Not strictly, due to ASI, but relying on ASI has real edge cases (a line beginning with `(` or `[` can merge with the previous line), so writing them explicitly is the professional norm and what virtually every style guide and linter enforces.

2. **What does `"use strict"` do?**
   Enables strict mode, which disables several error-prone legacy behaviors, most notably preventing accidental creation of global variables when a declaration keyword is omitted, and making some silent failures throw real errors instead. ES modules are strict by default.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
