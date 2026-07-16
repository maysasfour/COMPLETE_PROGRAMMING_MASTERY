# 06 — Functions

[Back to course overview](../README.md) | [Previous: Control Flow](../05-Control-Flow/README.md)

## Learning Objectives

- Annotate function parameters, return types, optional parameters, and default parameters.
- Type rest parameters and callback parameters correctly.
- Write function overload signatures for a function whose return type depends on its input type.
- Type arrow functions and function-typed variables/parameters.

## Prerequisites

[05-Control-Flow](../05-Control-Flow/README.md)

## Concept

Function typing in TypeScript covers parameters, the return type, and — for the trickiest cases — multiple possible signatures for the same function name via **overloads**. All of JavaScript's function forms ([01-Languages/JavaScript/06-Functions](../../JavaScript/06-Functions/README.md)) remain: declarations, expressions, and arrow functions, all typeable the same way.

## Basic Function Typing

```ts
function add(a: number, b: number): number {
  return a + b;
}

const multiply = (a: number, b: number): number => a * b;

function greet(name: string = "World"): string { // default parameter
  return `Hello, ${name}`;
}

function describe(name: string, nickname?: string): string { // optional parameter
  return nickname ? `${name} ("${nickname}")` : name;
}
```

An optional parameter (`nickname?: string`) has type `string | undefined` inside the function body — TypeScript forces you to handle the `undefined` case (directly, or via `??`) before treating it as a plain `string`, exactly like `strictNullChecks` (Lesson 03) would for any other possibly-undefined value.

## Typing Rest Parameters and Callbacks

```ts
function sum(...numbers: number[]): number {
  return numbers.reduce((total, n) => total + n, 0);
}

function processItems(items: string[], callback: (item: string, index: number) => void): void {
  items.forEach(callback);
}
```

A callback parameter's type (`(item: string, index: number) => void`) documents exactly what arguments it will be called with and what return value (if any) is expected — TypeScript then checks any function you pass against that exact signature.

## Function Overloads

```ts
function parseValue(value: string): string;
function parseValue(value: number): number;
function parseValue(value: string | number): string | number {
  if (typeof value === "string") {
    return value.trim();
  }
  return Math.round(value);
}

const a = parseValue("  hello  "); // typed as `string`, not `string | number`
const b = parseValue(3.7);          // typed as `number`, not `string | number`
```

The first two signatures are **overload signatures** — they're what callers see and what the compiler checks calls against. The third is the **implementation signature** — it must be compatible with every overload but is never directly visible to callers. Overloads exist specifically so that callers get a precise return type (`string` for a `string` input, `number` for a `number` input) instead of the union `string | number` the implementation itself has to work with internally.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints results from basic typed functions (including default and optional parameters), a rest-parameter sum, a typed callback used with `forEach`, and an overloaded `parseValue` function whose return type is precisely `string` or `number` per call site rather than the union both call sites would otherwise share.

## Common Mistakes

- Treating an optional parameter (`param?: T`) as always present without checking for `undefined` first.
- Writing an implementation signature only (no separate overload signatures) when a function's return type genuinely depends on its input type — callers then get an imprecise union return type instead of the specific one.
- Giving a callback parameter type `Function` (a very loose, mostly-useless type) instead of a specific signature like `(item: string) => void`.

## Best Practices

- Prefer a union parameter type (`value: string | number`) with narrowing inside the function body over overloads, unless you specifically need callers to see a precise, input-dependent return type — overloads add real complexity and should be reserved for when they earn their cost.
- Always give callback parameters a specific function signature type, not `Function` or `any`.
- Use default parameters instead of manually checking for `undefined` and substituting a fallback inside the function body.

## Real-World Usage

Overloads are common in well-typed utility libraries (e.g., a `createElement` function that returns a more specific element subtype depending on the tag name string passed in) and are exactly how TypeScript's own standard library types functions like `document.createElement`, which returns `HTMLDivElement` for `"div"` and `HTMLAnchorElement` for `"a"`, not a generic `HTMLElement` for every call.

## Summary

- Function parameters, return types, optional (`?`) and default parameters, and rest parameters are all typeable directly.
- Callback parameters should be given a specific function signature, not left as `Function`/`any`.
- Overloads let a function's return type depend precisely on its input type, at the cost of extra signature declarations; reserve them for when a union parameter with narrowing genuinely isn't precise enough for callers.

## Key Terms

- **Optional parameter (`?`)** — a parameter that may be omitted, typed as `T | undefined` inside the function.
- **Function overload** — multiple declared call signatures for one function name, letting return type depend on input type.
- **Implementation signature** — the single actual function body backing all of a function's overload signatures, compatible with every one of them but not itself visible to callers.

## Review Questions

1. Why does an optional parameter need an `undefined` check before being used as its base type?
2. Why can't callers see or call a function's implementation signature directly when overloads are used?
3. When would a union parameter with internal narrowing be preferable to writing overloads?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between an overload signature and the implementation signature?**
   Overload signatures are the (possibly several) call signatures callers actually see and get type-checked against — each can specify a precise parameter type and precise matching return type. The implementation signature is the one real function body underneath, which must be able to handle every parameter type any overload promises, and is typically written with a union type and internal narrowing; it's never itself part of the type callers see.

2. **Why might you use overloads instead of a single function with a union parameter type?**
   A single function with a union parameter (`value: string | number`) can only return one type from the caller's perspective, even if you know internally that a `string` input always produces a `string` output and a `number` input always produces a `number` output. Overloads let each specific input type map to its own specific, precise return type, giving callers stronger type information without them needing an extra type guard/assertion afterward.

3. **What type does an optional parameter have inside the function body, and why does that matter?**
   `param?: T` has type `T | undefined` inside the function — not just `T` — so any code using it must handle the `undefined` case (via a check or `??`) before treating it as a plain `T`, exactly the same `strictNullChecks` discipline (Lesson 03) applied specifically to parameters that weren't supplied by the caller.

## Recommended Next Lesson

[07 — Collections](../07-Collections/README.md)
