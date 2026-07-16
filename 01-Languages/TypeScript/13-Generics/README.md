# 13 — Generics

[Back to course overview](../README.md) | [Previous: Functional Concepts](../12-Functional-Concepts/README.md)

## Learning Objectives

- Write generic functions, interfaces, and classes with type parameters (`<T>`).
- Constrain a generic type parameter with `extends`.
- Use multiple type parameters and default type parameters.
- Understand this is exactly the compile-time-checked feature [01-Languages/JavaScript/13-Generics](../../JavaScript/13-Generics/README.md) explained plain JavaScript doesn't have.

## Prerequisites

[12-Functional-Concepts](../12-Functional-Concepts/README.md)

## Concept

A **generic** is a type parameter — a placeholder type, written `<T>`, filled in with a concrete type at each specific use — that lets you write one function, interface, or class that works correctly and *safely* across many types, without falling back to `any` and losing all type checking. This is precisely the feature the JavaScript course's Lesson 13 explained plain JavaScript lacks entirely; TypeScript is where it actually exists in this ecosystem.

## Generic Functions

```ts
function first<T>(items: T[]): T | undefined {
  return items[0];
}

const firstNumber = first([1, 2, 3]);      // T inferred as number -> firstNumber: number | undefined
const firstString = first(["a", "b", "c"]); // T inferred as string -> firstString: string | undefined
```

Compare this to the JavaScript course's `function first(items) { return items[0]; }`, which "worked for any type" only because JavaScript checks nothing at all. The generic version here is genuinely type-checked: `first([1, 2, 3])` is provably typed `number | undefined`, and calling `.toUpperCase()` on the result would be a compile error, exactly as it should be.

## Constraining a Generic with `extends`

```ts
interface HasLength {
  length: number;
}

function logLength<T extends HasLength>(value: T): T {
  console.log(`Length: ${value.length}`);
  return value;
}

logLength("hello");       // fine -- strings have .length
logLength([1, 2, 3]);      // fine -- arrays have .length
// logLength(42);           // error: number doesn't have a .length property
```

`T extends HasLength` restricts `T` to only types that have a `.length: number` property — this is a **constraint**, not inheritance in the class sense; it just means "whatever concrete type fills in `T` must at least have this shape." Without the constraint, `value.length` inside the function body would be a compile error, since a fully unconstrained `T` could be anything, including something with no `.length` at all.

## Generic Interfaces and Classes

```ts
interface Box<T> {
  value: T;
}

const numberBox: Box<number> = { value: 42 };
const stringBox: Box<string> = { value: "hello" };

class Stack<T> {
  private items: T[] = [];

  push(item: T): void {
    this.items.push(item);
  }

  pop(): T | undefined {
    return this.items.pop();
  }

  get size(): number {
    return this.items.length;
  }
}

const numberStack = new Stack<number>();
numberStack.push(1);
numberStack.push(2);
```

`Stack<T>` is written once and works safely for `Stack<number>`, `Stack<string>`, `Stack<User>`, or anything else — each instantiation gets its own fully type-checked `push`/`pop` without any code duplication and without `any` anywhere.

## Multiple and Default Type Parameters

```ts
interface KeyValuePair<K, V = string> { // V defaults to `string` if not specified
  key: K;
  value: V;
}

const pair1: KeyValuePair<number> = { key: 1, value: "one" };       // V defaults to string
const pair2: KeyValuePair<number, boolean> = { key: 1, value: true }; // V explicitly overridden
```

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints results from a generic `first<T>` function correctly inferring `number` and `string` per call, a constrained `logLength<T extends HasLength>` function working for both strings and arrays, a generic `Box<T>` and `Stack<T>` used with different concrete types, and a `KeyValuePair<K, V = string>` demonstrating a default type parameter being used and overridden.

## Common Mistakes

- Reaching for `any` instead of a genuine generic parameter whenever a function needs to "work for any type" — `any` discards type safety entirely, while a generic preserves it fully.
- Forgetting a constraint (`extends`) when the function body needs to assume *something* about `T` (like having a `.length`), then fighting compiler errors about properties that "might not exist" on a fully unconstrained type.
- Confusing a constrained generic (`T extends HasLength`) with `T` being *required to be exactly* `HasLength` — it can be any type that merely satisfies the shape, including a much richer type like a full `string` or a custom class with more than just `.length`.

## Best Practices

- Prefer a genuine generic (`<T>`) over `any` whenever a function/class needs to work across multiple types but should still be fully type-checked for each specific use.
- Add the narrowest constraint (`extends`) that the function body actually needs — don't over-constrain (limiting real-world usefulness) or under-constrain (losing needed type information inside the function body).
- Use default type parameters (`<K, V = string>`) to keep common-case usage concise while still allowing full control when needed.

## Real-World Usage

Generic containers (`Array<T>`, `Map<K, V>`, `Promise<T>`, all already used throughout this course) are themselves written using exactly this generic syntax; application code commonly defines its own generics for reusable data structures (`Stack<T>`, `Queue<T>`), API response wrappers (`ApiResponse<T>`), and repository/service patterns (`Repository<T>` with typed `find`/`save` methods) covered further in [07-Databases](../../../07-Databases/) and [13-Software-Architecture](../../../13-Software-Architecture/).

## Summary

- Generics (`<T>`) let one function/interface/class work safely across many concrete types, fully type-checked, unlike JavaScript's "works for anything because nothing is checked" duck typing (JS course, Lesson 13).
- `T extends SomeShape` constrains a generic to types satisfying at least that shape, enabling safe use of specific properties/methods inside the generic code.
- Multiple type parameters (`<K, V>`) and default type parameters (`<K, V = string>`) support more expressive, still fully-checked generic APIs.

## Key Terms

- **Generic type parameter (`<T>`)** — a placeholder type filled in with a concrete type at each use, checked by the compiler at every specific instantiation.
- **Generic constraint (`extends`)** — restricting a type parameter to types satisfying at least a given shape.
- **Default type parameter** — a generic parameter's fallback type when not explicitly specified at a use site.

## Interview Questions

1. **Why is a generic function safer than one typed with `any` while still "working for any type"?**
   A generic (`<T>`) is checked separately for each concrete type it's used with — `first([1,2,3])` is provably `number | undefined`, and misusing that result (calling a string method on it) is a compile error. `any` disables checking entirely for the value and everything derived from it, so the exact same misuse would compile without any warning and only fail (or silently misbehave) at runtime.

2. **What does `T extends HasLength` mean in a generic function signature?**
   It constrains the generic type parameter `T` to only types that are structurally compatible with `HasLength` (here, having at least a `.length: number` property) — it is not classical inheritance, just a shape requirement enforced at compile time, letting the function body safely use `value.length` since every valid `T` is now guaranteed to have it.

3. **How does `Array<T>` (or any built-in generic container) relate to what you learn writing your own generics?**
   `Array<T>`, `Map<K,V>`, `Promise<T>`, and every other built-in generic container are implemented using the exact same generic type-parameter mechanism covered in this lesson — understanding how to write `Stack<T>` or `Box<T>` directly explains how `Array<T>` can safely support `.push(item: T)` and return `T` from `.pop()` for any element type, without a separate implementation per type.

## Recommended Next Lesson

[14 — Async and Concurrency](../14-Async-and-Concurrency/README.md)
