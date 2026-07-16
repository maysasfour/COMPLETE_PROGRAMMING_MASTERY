# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Write function declarations, function expressions, and arrow functions, and know when each is appropriate.
- Use default and rest parameters.
- Explain closures and use them to create private state.
- Explain how `this` is determined differently for regular functions vs. arrow functions.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

JavaScript functions are **first-class values** — they can be assigned to variables, passed as arguments, and returned from other functions, exactly like a number or string. There are three ways to write one, each with different hoisting and `this` behavior, which is more variation than most languages expose for "the same feature."

## Syntax

```js
// Function declaration -- hoisted (usable before its definition line in the same scope)
function add(a, b) {
  return a + b;
}

// Function expression -- NOT hoisted the same way; the variable exists but is undefined until this line runs
const subtract = function (a, b) {
  return a - b;
};

// Arrow function -- concise, and has no own `this`/`arguments` (inherits from enclosing scope)
const multiply = (a, b) => a * b;
```

## Default and Rest Parameters

```js
function greet(name = "World") {
  return `Hello, ${name}`;
}
greet();          // "Hello, World"
greet("Ada");     // "Hello, Ada"

function sum(...numbers) {  // rest parameter: collects remaining args into a real array
  return numbers.reduce((total, n) => total + n, 0);
}
sum(1, 2, 3);      // 6
```

## Closures

```js
function makeCounter() {
  let count = 0;               // private to this closure -- no external code can touch it directly
  return function () {
    count += 1;
    return count;
  };
}

const counter = makeCounter();
counter();  // 1
counter();  // 2
```

A **closure** is a function that retains access to the variables of its enclosing scope even after that outer function has returned. `count` here is not a global or a class field — it lives only inside the closure created by `makeCounter()`, and each call to `makeCounter()` creates an entirely independent `count`.

## `this` — Regular Functions vs. Arrow Functions

```js
const obj = {
  name: "Widget",
  regularMethod() {
    console.log("regular:", this.name); // `this` is `obj`, because it's called as obj.regularMethod()
  },
  delayedArrow() {
    setTimeout(() => {
      console.log("arrow inside method:", this.name); // still `obj` -- arrow inherits `this` lexically
    }, 0);
  },
  delayedRegular() {
    setTimeout(function () {
      console.log("regular inside method:", this?.name); // undefined -- `this` here is not `obj`
    }, 0);
  },
};
```

This is the single most common practical reason to choose an arrow function: as a callback passed to `setTimeout`, an array method, or an event handler, you almost always want `this` to still refer to the surrounding object, which only an arrow function guarantees.

## Detailed Example

See [example.js](example.js).

## Expected Output

Running `node example.js` prints the results of declaration/expression/arrow function calls, a default-parameter call, a rest-parameter sum, two independent closures counting separately, and a side-by-side comparison proving arrow functions preserve `this` from a `setTimeout` callback while a regular function loses it.

## Common Mistakes

- Using a regular `function` as a callback where `this` needs to refer to the enclosing object (a very common bug inside class methods and object literals before arrow functions were common).
- Forgetting a function declaration is hoisted but a `const fn = function(){}` expression is not — calling the latter before its line throws a `ReferenceError` (temporal dead zone) rather than working like the declaration would.
- Assuming closures share state across every call to the outer function — each call creates a fresh, independent set of captured variables.
- Confusing rest parameters (`...args` in a function signature, collecting into an array) with the spread operator (`...arr` at a call site, expanding an array) — same syntax, opposite direction, covered together with arrays in Lesson 07.

## Best Practices

- Use named `function` declarations for standalone, reusable, top-level functions (clearer stack traces, hoisting available if needed).
- Use arrow functions for callbacks and anything that should inherit the enclosing `this`.
- Give functions a single clear responsibility; prefer composing several small functions over one large one with many parameters.
- Use default parameters instead of `param = param || defaultValue` inside the function body — the latter has the same `||`-vs-falsy-zero problem covered in Lesson 04.

## Real-World Usage

Closures are the standard way to implement private state in JavaScript modules before/without classes (e.g., a module exposing only `increment()`/`getValue()` while keeping the counter itself inaccessible from outside) and are the mechanism behind React's `useState` hook internally.

## Performance Considerations

Excessive closures capturing large objects can keep memory alive longer than expected, since the captured variables aren't garbage-collected while the closure itself is reachable — relevant in long-lived event listeners or timers that are never cleaned up.

## Summary

- Functions are first-class values with three syntaxes: declaration (hoisted), expression (not hoisted the same way), arrow (no own `this`).
- Default parameters and rest parameters (`...args`) make flexible signatures easy to write.
- A closure is a function plus the variables from its enclosing scope it still has access to, even after that scope's function has returned.
- Arrow functions inherit `this` lexically; regular functions get `this` from how they're called, which is usually wrong inside a callback.

## Key Terms

- **First-class function** — a function that can be assigned to a variable, passed as an argument, or returned from another function.
- **Hoisting** — function declarations are fully available before their line runs, within the same scope.
- **Closure** — a function bundled with access to variables from its enclosing scope at the time it was created.
- **Rest parameter** — `...args` in a function signature, collecting extra arguments into a real array.

## Review Questions

1. Why does calling a function-expression-based function before its declaration line throw, while calling a function-declaration-based one doesn't?
2. What does an arrow function *not* have of its own that a regular function does?
3. Why does each call to a closure-returning outer function produce independent state?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's a closure, concretely?**
   A function that "remembers" the variables from the scope it was defined in, even after that outer scope has finished running. It's created every time a function is defined inside another function, whether or not the inner function is ever returned or used as a callback — but it's most visibly useful when the inner function is returned or passed elsewhere and keeps working with its captured state.

2. **Why do arrow functions not have their own `this`?**
   By design — they capture `this` lexically from the scope in which they're *defined*, not the object they're called on. This avoids the extremely common bug of losing the intended `this` when passing a regular function as a callback, and is one of the main practical reasons ES6 arrow functions were introduced.

3. **What's the difference between a function declaration and a function expression?**
   A declaration (`function foo(){}`) is hoisted with its full body available before its line runs anywhere in the same scope. A function expression (`const foo = function(){}`) only becomes callable once its assignment line actually executes — before that, referencing `foo` throws (if declared with `let`/`const`) due to the temporal dead zone.

4. **What are default parameters, and why are they better than `param = param || default`?**
   Default parameters (`function f(x = 10)`) supply a value only when the argument is `undefined` (not passed at all, or explicitly passed as `undefined`). The `||` idiom incorrectly falls back for *any* falsy argument, including a deliberately passed `0`, `""`, or `false`.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
