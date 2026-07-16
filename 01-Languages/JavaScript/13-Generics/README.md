# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Understand why plain JavaScript has no generics as a language feature.
- Write duck-typed, type-agnostic code that behaves like generic code, relying on runtime structure rather than compile-time type parameters.
- Know where real generics come from in this ecosystem (TypeScript) and what they add.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept: Why This Lesson Is Different

Every other language in this repository with a dedicated Generics lesson (Java, C#, TypeScript, Rust) has **compile-time type parameters** — `List<T>`, `Box<T>`, etc. — checked before the program ever runs. Plain JavaScript has no static type system at all, so it has nothing to check at compile time and no `<T>` syntax. This isn't a missing feature so much as a direct consequence of dynamic typing (Lesson 03): a JavaScript function is already "generic" over any type, for free, because it never declares parameter types to begin with.

```js
function first(items) {
  return items[0];
}

first([1, 2, 3]);         // works: 1
first(["a", "b", "c"]);    // works: "a"
first([{ id: 1 }, { id: 2 }]); // works: { id: 1 }
```

`first` here behaves exactly like a generic `function first<T>(items: T[]): T` would in a statically-typed language — it works for any element type — but JavaScript gets this "for free" from dynamic typing rather than from an explicit generics feature, and critically, **nothing checks that `items` is even an array** until the code actually runs and something goes wrong.

## The Real Trade-off: Duck Typing vs. Compile-Time Generics

```js
function merge(a, b) {
  return { ...a, ...b };
}

merge({ x: 1 }, { y: 2 });   // { x: 1, y: 2 } -- works fine
merge({ x: 1 }, "oops");     // { '0':'o', '1':'o', '2':'p', '3':'s', x: 1 } -- silently "works", nonsensical result
```

This is the cost of not having real generics: `merge` silently accepts a string as its second argument and produces a nonsensical result instead of a compile-time error. A genuinely generic, type-checked version of this function (as you'd write in TypeScript with `merge<A, B>(a: A, b: B): A & B`) would reject the second call before the program ever ran.

## Where JavaScript-Ecosystem Generics Actually Live: TypeScript

```ts
// TypeScript, not plain JavaScript -- shown for contrast only
function first<T>(items: T[]): T {
  return items[0];
}

first([1, 2, 3]);        // T inferred as number
first(["a", "b", "c"]);   // T inferred as string
first([1, "mixed"]);      // T inferred as (string | number)[] -- still type-safe, just a union
```

[TypeScript](../../TypeScript/) (planned in this repository) is a superset of JavaScript that adds a real, compile-time-checked generics system, along with the rest of static typing. If you need actual generic type safety rather than duck typing, that's the direction to go — this lesson exists mainly to correctly frame *why* plain JavaScript doesn't have it and what the practical difference is.

## Detailed Example

See [example.js](example.js) — demonstrates duck-typed "generic" functions working correctly across multiple types, and the `merge` silent-failure case above, contrasted with what a type checker would have caught.

## Expected Output

Running `node example.js` prints `first()` and a generic `identity()`-style function working across numbers, strings, and objects, followed by the `merge` example showing a nonsensical-but-non-crashing result when passed a mismatched argument type.

## Common Mistakes

- Assuming "my function works with any type I've tried" is the same guarantee real generics provide — duck typing only tells you it worked for the inputs you happened to test.
- Writing runtime type checks (`typeof`, `Array.isArray`) as a substitute for generics in every function — reasonable at API boundaries, but excessive internally where TypeScript would be the better tool for the underlying problem.

## Best Practices

- For a script or small tool, duck typing is fine — the flexibility is a genuine advantage, not just a limitation.
- For a library or any code whose misuse would be expensive to debug in production, prefer [TypeScript](../../TypeScript/) generics over hand-rolled runtime type checks.
- Add targeted runtime validation (Lesson 09's custom errors) at the boundaries where untrusted or externally-sourced data enters your code, rather than trying to defensively type-check every internal function call.

## Summary

- Plain JavaScript has no generics because it has no static type system to check them against — dynamic typing gives you "generic-like" flexibility for free, with no compile-time safety net.
- Duck-typed code can silently accept the wrong type and produce a nonsensical (not crashing) result, which real generics would catch before runtime.
- TypeScript is where actual compile-time-checked generics live in this ecosystem.

## Key Terms

- **Duck typing** — code that works with any value exposing the right shape/behavior at runtime, with no compile-time type declaration.
- **Generic type parameter (`<T>`)** — a placeholder type, checked at compile time, used in statically-typed languages (and TypeScript) to write one implementation that works safely across many types.

## Interview Questions

1. **Why doesn't plain JavaScript have generics?**
   Generics are a static-typing feature — they let a compiler verify that a function written once behaves correctly for every type it's used with, before the program runs. JavaScript has no compile-time type system at all, so there's nothing for a `<T>` syntax to be checked against; dynamic typing already lets any function accept any type, just without any safety guarantee.

2. **What's the practical downside of relying on duck typing instead of real generics?**
   A duck-typed function can be called with a value that "sort of" matches the expected shape but isn't actually correct, and instead of a compile-time error, you get a silently wrong runtime result (as shown by `merge({x:1}, "oops")` above) — bugs that a generics-checked language would have caught before the code ever ran.

3. **Where do you get real generics in the JavaScript ecosystem?**
   TypeScript, a statically-typed superset of JavaScript that compiles down to plain JavaScript, adds a full compile-time generics system (`function first<T>(items: T[]): T`) along with the rest of static typing, and is the standard answer when a project needs that level of safety.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
