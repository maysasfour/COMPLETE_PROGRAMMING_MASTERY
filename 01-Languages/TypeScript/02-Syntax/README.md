# 02 — Syntax

[Back to course overview](../README.md) | [Previous: Setup](../01-Setup/README.md)

## Learning Objectives

- Write basic type annotations for variables, function parameters, and return types.
- Understand type inference and when to rely on it versus writing an explicit annotation.
- Understand structural typing ("duck typing with a paper trail"), TypeScript's core typing philosophy.

## Prerequisites

[01-Setup](../01-Setup/README.md)

## Concept

TypeScript's syntax is JavaScript's syntax plus **type annotations**, written as `: Type` after a variable, parameter, or function signature. TypeScript uses **structural typing** (also called "duck typing" in its static form): two types are compatible if they have the same *shape*, regardless of their names or where they were declared — this is fundamentally different from nominal typing (Java/C#), where two classes with identical fields are still incompatible unless one explicitly extends/implements the other.

## Syntax: Basic Annotations

```ts
let username: string = "ada";
let age: number = 30;
let isAdmin: boolean = false;

function greet(name: string): string {
  return `Hello, ${name}`;
}
```

## Type Inference

```ts
let city = "Berlin"; // inferred as `string` -- no annotation needed
// city = 42;         // error: Type 'number' is not assignable to type 'string'
```

TypeScript infers a type from the initial value whenever possible. Writing `let city: string = "Berlin"` is not wrong, just redundant — the annotation adds no information the compiler didn't already determine on its own. The convention this course follows: **omit the annotation when inference already gives the right type**; add an explicit annotation for function parameters (which have no initial value to infer from) and whenever the inferred type would be wider than intended.

## Structural Typing

```ts
interface Point {
  x: number;
  y: number;
}

function printPoint(p: Point) {
  console.log(`(${p.x}, ${p.y})`);
}

const coordinate = { x: 1, y: 2, label: "origin" }; // has MORE than Point requires
printPoint(coordinate); // still works -- it has everything Point needs, extra fields are fine
```

`coordinate` was never declared as a `Point` — TypeScript accepts it anyway because it structurally has everything `Point` requires (an object with numeric `x` and `y`), plus something extra, which doesn't disqualify it. This is the core of "structural typing": shape matters, name and declared origin don't.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints an inferred-vs-annotated variable comparison, a `greet()` call, and a structural-typing demonstration passing an object with extra fields to a function expecting a narrower shape, succeeding because TypeScript checks shape, not declared type name.

## Common Mistakes

- Over-annotating every single variable, even where inference already gives the exact right type — adds visual noise without adding safety.
- Assuming TypeScript checks *names* of types, not structure — leading to confusion about why an "unrelated" object type satisfies an interface it never explicitly implements.
- Not annotating function parameters, then being surprised when TypeScript infers them as `any` (see Lesson 03) in non-strict configurations, silently disabling type checking for that parameter.

## Best Practices

- Let inference handle variables with an obvious initial value; annotate function parameters and public function return types explicitly.
- Prefer `interface`/type shapes over requiring explicit class inheritance when structural compatibility is all that's actually needed.
- Keep `"strict": true` on (Lesson 01) so an unannotated function parameter is flagged as an implicit `any` error rather than silently accepted.

## Real-World Usage

Structural typing is why TypeScript integrates so smoothly with plain JavaScript objects and JSON API responses — a function expecting `{ id: number; name: string }` accepts any object with at least those fields, without requiring the caller to have explicitly constructed an instance of a named class first.

## Summary

- TypeScript syntax is JavaScript syntax plus `: Type` annotations.
- Type inference fills in types automatically from context; explicit annotations are needed mainly for function parameters and to widen/narrow beyond what inference alone would produce.
- TypeScript's type system is structural: shape determines compatibility, not declared type names.

## Key Terms

- **Type annotation** — explicit `: Type` syntax declaring a variable/parameter/return type.
- **Type inference** — TypeScript automatically determining a type from context without an explicit annotation.
- **Structural typing** — a type-compatibility model based on an object's actual shape, not its declared name or inheritance chain.

## Interview Questions

1. **What's the difference between structural and nominal typing, and which does TypeScript use?**
   Structural typing (TypeScript's model) considers two types compatible if they have the same shape — the same required properties/methods — regardless of name or declared relationship. Nominal typing (Java, C#) requires an explicit declared relationship (implementing an interface, extending a class) even if the shapes are identical.

2. **When should you write an explicit type annotation versus relying on inference?**
   Rely on inference for local variables with an obvious initializer (`let x = 5`). Write explicit annotations for function parameters (which have no initializer for the compiler to infer from) and for return types on public/exported functions, where an explicit contract helps both readability and catches a mismatched `return` statement.

## Recommended Next Lesson

[03 — Variables and Data Types](../03-Variables-and-Data-Types/README.md)
