# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Write and use higher-order functions.
- Write a decorator-style wrapper function (JavaScript has no `@decorator` syntax built in, but the pattern is easy to express as a plain function).
- Use currying and partial application.
- Explain function composition and write a small `compose`/`pipe` helper.

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Because functions are first-class values in JavaScript (Lesson 06), most functional-programming patterns from [10-Functional-Programming](../../../10-Functional-Programming/) translate directly with no special language support required — a "decorator" is just a function that takes a function and returns a new one; "currying" is just returning a function from a function.

## Higher-Order Functions (Review + Extension)

```js
function withLogging(fn) {
  return function (...args) {
    console.log(`Calling ${fn.name} with`, args);
    const result = fn(...args);
    console.log(`${fn.name} returned`, result);
    return result;
  };
}

function add(a, b) { return a + b; }
const loggedAdd = withLogging(add);
loggedAdd(2, 3); // logs the call and result, then returns 5
```

This "wrap a function to add behavior around it" pattern is what other languages formalize as decorators (Python's `@decorator`, covered in [01-Languages/Python/12-Functional-Concepts](../../Python/12-Functional-Concepts/README.md)) — JavaScript achieves the same result with a plain higher-order function, no special syntax needed. (A `@decorator` proposal for classes does exist at Stage 3 in TC39 as of this writing, but it's for class members specifically, not arbitrary functions.)

## Currying and Partial Application

```js
function curry(fn) {
  return function curried(...args) {
    if (args.length >= fn.length) return fn(...args);
    return (...more) => curried(...args, ...more);
  };
}

function add3(a, b, c) { return a + b + c; }
const curriedAdd3 = curry(add3);

curriedAdd3(1)(2)(3);     // 6
curriedAdd3(1, 2)(3);     // 6 -- also works with any grouping of arguments
curriedAdd3(1, 2, 3);     // 6
```

**Currying** transforms a function taking multiple arguments into a sequence of functions each taking one (or a subset), returning a new function until all arguments have arrived. **Partial application** is the related, more general idea of fixing some arguments now and supplying the rest later — currying is one specific, systematic way to achieve that.

## Function Composition

```js
const compose = (...fns) => (input) => fns.reduceRight((value, fn) => fn(value), input);
const pipe = (...fns) => (input) => fns.reduce((value, fn) => fn(value), input);

const double = (n) => n * 2;
const increment = (n) => n + 1;

const pipeline = pipe(double, increment); // double THEN increment
pipeline(5); // (5*2)=10, then (10+1)=11

const composed = compose(increment, double); // same order as pipe here, written right-to-left
composed(5); // double(5)=10, then increment(10)=11
```

`pipe` reads left-to-right (the order you'd naturally describe the steps); `compose` reads right-to-left (matching mathematical function composition notation, `f(g(x))`). Both are equally valid; codebases typically pick one convention and stick with it.

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints a logged function call via the `withLogging` wrapper, three equivalent calling styles of a curried three-argument function all producing the same result, and a `pipe`-based data pipeline transforming a value through several steps in sequence.

## Common Mistakes

- Writing a curry helper that doesn't account for functions taking a variable number of arguments (`fn.length` doesn't count rest parameters) — the curry implementation shown here only works correctly for functions with a fixed, explicit parameter count.
- Confusing `compose`'s right-to-left order with `pipe`'s left-to-right order and getting a pipeline's steps backwards.
- Over-applying functional patterns (currying everything, deeply composed pipelines) where a plain, readable function body would be clearer — these tools shine for reusable transformation pipelines, not as a default style for all code.

## Best Practices

- Reserve currying/composition for genuinely reusable transformation pipelines (data processing, validation chains) rather than applying them reflexively everywhere.
- Name higher-order wrapper functions descriptively (`withLogging`, `withRetry`, `memoize`) so their purpose is clear at the call site.
- Prefer `pipe` for readability in most codebases — most developers find left-to-right reading order more intuitive than `compose`'s right-to-left.

## Real-World Usage

Middleware chains in Express ([04-Backend-Development](../../../04-Backend-Development/)) are conceptually a composition pipeline: each middleware function wraps/precedes the next. Redux's `applyMiddleware` and various logging/caching wrappers around API client functions are direct applications of the `withLogging`-style higher-order function pattern shown above.

## Summary

- Because functions are first-class, decorator-like wrapping is just a higher-order function returning a new function — no special syntax needed.
- Currying transforms a multi-argument function into a chain of single/partial-argument calls; partial application is the more general "fix some arguments now" idea.
- `pipe` (left-to-right) and `compose` (right-to-left) both build a pipeline from smaller functions; pick one convention per codebase.

## Key Terms

- **Higher-order function** — a function that takes and/or returns another function.
- **Currying** — transforming a function of several arguments into a chain of functions each taking one (or a subset).
- **Partial application** — fixing some of a function's arguments now, returning a new function awaiting the rest.
- **Function composition** — building a new function by chaining several functions so one's output feeds the next's input.

## Review Questions

1. Why doesn't JavaScript need special `@decorator` syntax to achieve the decorator pattern?
2. What's the difference between currying and partial application?
3. Why does `compose` read right-to-left while `pipe` reads left-to-right?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's a higher-order function?**
   A function that takes one or more functions as arguments, returns a function, or both. `map`/`filter`/`reduce` (Lesson 07) are higher-order functions because they take a callback; a function like `withLogging` above is higher-order because it both takes and returns a function.

2. **What's the difference between currying and partial application?**
   Currying systematically transforms an n-argument function into a nested chain of unary (or grouped) functions, one argument-group at a time, until all arguments are supplied. Partial application is the broader, less rigid idea of pre-filling some arguments of a function and getting back a new function that only needs the rest — currying is one disciplined way to implement partial application, but not the only way.

3. **How would you implement a simple `pipe` function?**
   `const pipe = (...fns) => (input) => fns.reduce((value, fn) => fn(value), input);` — it takes any number of functions, returns a new function that takes the initial input, and folds that input through each function left-to-right using `reduce`, each function's output becoming the next function's input.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
