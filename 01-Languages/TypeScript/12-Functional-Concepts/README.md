# 12 — Functional Concepts

[Back to course overview](../README.md) | [Previous: OOP](../11-OOP/README.md)

## Learning Objectives

- Write typed higher-order functions, including a generic `pipe`/`compose`.
- Type a decorator-style wrapper function so it works for any compatible function signature.
- Understand TypeScript's experimental class/method decorators versus the plain higher-order-function pattern.

## Prerequisites

[11-OOP](../11-OOP/README.md)

## Concept

Functional patterns work exactly as in [01-Languages/JavaScript/12-Functional-Concepts](../../JavaScript/12-Functional-Concepts/README.md). TypeScript's contribution is being able to type a higher-order function generically enough that it works correctly — with full type inference — across many different underlying function signatures, rather than losing type information the moment a function is wrapped.

## A Generically-Typed `withLogging`

```ts
function withLogging<Args extends unknown[], Return>(
  fn: (...args: Args) => Return
): (...args: Args) => Return {
  return (...args: Args): Return => {
    console.log(`Calling ${fn.name} with`, args);
    const result = fn(...args);
    console.log(`${fn.name} returned`, result);
    return result;
  };
}

function add(a: number, b: number): number {
  return a + b;
}

const loggedAdd = withLogging(add); // inferred as (a: number, b: number) => number -- NOT lost
loggedAdd(2, 3);
```

Without the generic `<Args extends unknown[], Return>`, a naively-typed `withLogging(fn: Function)` would lose all parameter and return type information — callers of `loggedAdd` would get no autocomplete or type checking at all. The generic version preserves the *exact* original signature through the wrapping, which is the entire practical value of typing a higher-order function this way.

## Typed `pipe`

```ts
function pipe<A, B, C>(fn1: (a: A) => B, fn2: (b: B) => C): (a: A) => C {
  return (a: A) => fn2(fn1(a));
}

const double = (n: number): number => n * 2;
const toCurrency = (n: number): string => `$${n.toFixed(2)}`;

const doubleAndFormat = pipe(double, toCurrency); // inferred: (a: number) => string
console.log(doubleAndFormat(21.5)); // "$43.00"
```

This two-function `pipe` demonstrates the principle at a manageable scale — a fully generic, variadic `pipe` accepting any number of functions requires more advanced tuple/conditional types (beyond this lesson's scope) to preserve full type safety across an arbitrary chain length.

## Decorators (Brief Note)

TypeScript also has an experimental/stabilizing **decorator** syntax (`@decoratorName` above a class or method), directly inspired by Python's `@decorator` and matching a TC39 proposal for JavaScript itself. It's more specialized (class/method-focused) and has had a genuinely unstable history across TypeScript versions (legacy experimental decorators vs. the newer TC39-aligned ones behave differently) — the plain higher-order-function pattern shown above works identically regardless of TypeScript version and decorator settings, which is why this course uses it as the primary technique rather than `@decorator` syntax.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints a logged function call via the generically-typed `withLogging` wrapper (with the wrapped function's original signature fully preserved and checkable), and a typed two-step `pipe` pipeline transforming a number into a formatted currency string.

## Common Mistakes

- Typing a higher-order function's inner function parameter as plain `Function` or `any`, discarding all type information for anything wrapped with it.
- Assuming TypeScript's decorator syntax is stable/uniform across versions and `tsconfig` settings — historically it has changed meaningfully (`"experimentalDecorators"` legacy behavior vs. the newer standardized proposal), unlike the plain function-wrapping approach.

## Best Practices

- Type higher-order function wrappers generically (`<Args extends unknown[], Return>`) so wrapped functions retain their exact original signature for callers.
- Default to plain higher-order functions for "add behavior around a function" patterns; reach for class/method decorators only when a framework specifically expects them (e.g., some dependency-injection or ORM libraries).

## Real-World Usage

Generically-typed `withLogging`/`withRetry`/`memoize`-style wrappers are common in production TypeScript for consistently adding cross-cutting behavior (logging, retries, caching) to API client functions or service methods without losing type safety for callers.

## Summary

- Functional patterns are unchanged from JavaScript; TypeScript's value-add is preserving exact function signatures through generic higher-order function types.
- A naively-typed wrapper (using `Function`/`any`) silently discards type information for anything it wraps.
- TypeScript's `@decorator` syntax exists but has an unstable history across versions; plain generic higher-order functions are the more portable default.

## Key Terms

- **Generic higher-order function** — a higher-order function typed with generic parameters so it preserves the exact signature of whatever function it wraps or composes.

## Interview Questions

1. **Why does a naively-typed `withLogging(fn: Function)` lose type safety for anything it wraps?**
   `Function` is an extremely loose type carrying no information about specific parameter types or return type — wrapping a function with it discards all of that information, so the wrapped function's callers get no compile-time checking or autocomplete at all, even though the underlying runtime behavior is identical to a properly generic version.

2. **How do you type a higher-order function so it preserves the exact signature of whatever function is passed in?**
   Use generic type parameters for both the argument list and return type, typically `<Args extends unknown[], Return>(fn: (...args: Args) => Return): (...args: Args) => Return`. TypeScript infers `Args` and `Return` from whatever specific function is passed in, so the wrapped result has exactly that same specific signature rather than a generic, information-losing one.

## Recommended Next Lesson

[13 — Generics](../13-Generics/README.md)
