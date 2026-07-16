# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Use JavaScript's operators, now with compile-time type checking of their operands.
- Use the non-null assertion operator (`!`) and understand why it's dangerous.
- Use `as` type assertions correctly, and know how they differ from a real runtime check.
- Use type guards to narrow a union type safely, as an alternative to assertions.

## Prerequisites

[03-Variables-and-Data-Types](../03-Variables-and-Data-Types/README.md)

## Concept

Every operator from [01-Languages/JavaScript/04-Operators](../../JavaScript/04-Operators/README.md) works identically in TypeScript — `===`/`!==`, `??`, `?.`, arithmetic and logical operators are unchanged. What TypeScript adds are **compiler-only** operators and constructs for working with its type system: type assertions (`as`), the non-null assertion (`!`), and type guards.

## Operators Recap (Type-Checked)

```ts
function add(a: number, b: number): number {
  return a + b; // TypeScript verifies both operands are numbers before allowing +
}

const config: { timeout?: number } = {};
const timeout = config.timeout ?? 5000; // ?? still works exactly as in plain JS
```

Because operands now have known types, TypeScript catches operator misuse at compile time that plain JavaScript would only discover at runtime — e.g., `add("2", 3)` fails to compile, whereas the equivalent plain-JS call would silently coerce and produce `"23"`.

## Type Assertions (`as`)

```ts
const input: unknown = "42";
const asNumber = input as string; // "trust me, compiler" -- no runtime check happens
console.log(asNumber.length); // works, because it genuinely IS a string here

const wrong = input as number; // COMPILES (no error!) but is a lie
// console.log(wrong.toFixed(2)); // runtime crash: "42".toFixed is not a function
```

`as` tells the compiler "treat this value as this type," but performs **no runtime check whatsoever** — an incorrect assertion compiles cleanly and can crash at runtime exactly like an unchecked `any`. Assertions are appropriate only when you have external knowledge the compiler can't infer (e.g., you know a DOM query will find a specific element type); they are not a substitute for genuine validation of untrusted data.

## The Non-Null Assertion Operator (`!`)

```ts
function getElementById(id: string): HTMLElement | null {
  return document.getElementById(id);
}

// const el = getElementById("app")!; // asserts "this is definitely not null" -- no runtime check
```

`value!` tells the compiler to treat a possibly-`null`/`undefined` value as definitely present, again with **no runtime check** — if you're wrong, the resulting crash happens at the first place that value is actually used, often far from where the `!` was written, making it harder to trace than a proper `if` check.

## Type Guards: The Safer Alternative to Assertions

```ts
function isString(value: unknown): value is string {
  return typeof value === "string";
}

function processValue(value: unknown) {
  if (isString(value)) {
    console.log(value.toUpperCase()); // TypeScript knows value is `string` here -- genuinely checked
  } else {
    console.log("Not a string:", value);
  }
}
```

A **type guard** (a function returning `value is SomeType`) performs a real runtime check (here, `typeof value === "string"`) and tells the compiler the result of that specific check narrows the type — this is the safe alternative to `as`/`!` whenever you actually have a way to verify the type at runtime, rather than merely asserting it.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints a type-checked arithmetic operation, a demonstration of a correct vs. incorrect `as` assertion (with the incorrect one caught and its would-be crash avoided by checking first, since actually crashing would end the demo), and a custom type guard correctly narrowing a union type in both branches of an `if`/`else`.

## Common Mistakes

- Using `as` to silence a compiler error without checking the assertion is actually true — this recreates `any`'s unsafety for that one value while looking safer.
- Using `!` (non-null assertion) as a default habit whenever `strictNullChecks` complains, instead of writing an actual `if (value !== null)` check.
- Assuming a type guard function's `value is Type` annotation alone provides safety — the safety comes entirely from the *actual runtime check* inside the function; a type guard with a wrong/incomplete check lies to the compiler just as effectively as a bad `as`.

## Best Practices

- Prefer type guards (real runtime checks) over `as`/`!` assertions whenever you can actually verify the type.
- Reserve `as` for cases with genuine external knowledge the compiler cannot derive (e.g., a library's loosely-typed return value that you know more about than its types express).
- Avoid `!` in new code; an explicit `if (value)` check is barely more verbose and is genuinely safe.

## Real-World Usage

Type guards are the standard tool for narrowing `unknown` API response data (Lesson 03) into a specific expected shape before using it, and for distinguishing between members of a union type representing different states (e.g., a `Loading | Success | Error` result type in a frontend data-fetching hook).

## Security Considerations

An `as` assertion or `!` on genuinely untrusted external data (a network response, user input) provides *no* actual safety — it only silences the compiler while the real runtime risk (accessing a property that doesn't exist, calling a method that isn't there) remains exactly as present as it would be in plain JavaScript with `any`.

## Summary

- All of JavaScript's runtime operators work unchanged in TypeScript, now with compile-time operand type checking.
- `as` and `!` are compiler-only assertions with **zero** runtime check — an incorrect one compiles fine and crashes later.
- Type guards (`value is Type` functions) perform a genuine runtime check and safely narrow a type, and are the preferred alternative to assertions wherever verification is possible.

## Key Terms

- **Type assertion (`as`)** — telling the compiler to treat a value as a specific type, without any runtime verification.
- **Non-null assertion (`!`)** — asserting a possibly-`null`/`undefined` value is definitely present, without any runtime check.
- **Type guard** — a function (`value is Type`) that performs a real runtime check and narrows a type based on its result.

## Interview Questions

1. **Does `as SomeType` perform any runtime validation?**
   No — `as` is purely a compile-time instruction telling TypeScript to treat a value as a given type; it performs zero runtime checking or conversion. If the assertion is wrong, the code compiles without error and can crash later at the point where the mismatched value is actually used in a way that type doesn't support.

2. **What's the difference between a type assertion and a type guard?**
   A type assertion (`as`/`!`) is an unchecked claim to the compiler with no runtime verification. A type guard is a function that performs an actual runtime check (e.g., `typeof value === "string"`) and is annotated to tell the compiler that a `true` result narrows the value's type — the safety comes from the real check the guard performs, not from the annotation alone.

3. **Why is the non-null assertion operator (`!`) considered risky?**
   It suppresses `strictNullChecks`' compile-time protection for a specific value with zero runtime verification that the value is actually non-null. If the assumption is wrong, the resulting error surfaces later, at whatever line actually uses the value, which can be far from the `!` itself and harder to trace back to the real cause.

## Recommended Next Lesson

[05 — Control Flow](../05-Control-Flow/README.md)
