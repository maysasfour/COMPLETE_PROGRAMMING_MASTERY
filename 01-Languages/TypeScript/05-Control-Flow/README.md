# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`switch`/loops exactly as in JavaScript, now with type narrowing across branches.
- Narrow a union type inside `if`/`switch` branches using `typeof`, `in`, and discriminated unions.
- Write an exhaustiveness check so the compiler catches an unhandled case if a union type grows later.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Control flow syntax is identical to [01-Languages/JavaScript/05-Control-Flow](../../JavaScript/05-Control-Flow/README.md) — `if`, `switch`, `for`, `while`, truthy/falsy rules, all unchanged. What TypeScript adds is **control flow analysis**: the compiler tracks how a variable's type narrows as you move through `if`/`switch` branches, and can prove — at compile time — that a `switch` over a union type handles every possible case.

## Narrowing with `typeof` and `in`

```ts
function formatValue(value: string | number) {
  if (typeof value === "string") {
    return value.toUpperCase(); // narrowed to `string` in this branch
  }
  return value.toFixed(2); // narrowed to `number` in this branch -- the `else` implicitly
}

interface Circle { kind: "circle"; radius: number }
interface Square { kind: "square"; side: number }
type Shape = Circle | Square;

function area(shape: Shape): number {
  if ("radius" in shape) {
    return Math.PI * shape.radius ** 2; // narrowed to Circle
  }
  return shape.side ** 2; // narrowed to Square
}
```

## Discriminated Unions and Exhaustive `switch`

```ts
function areaBySwitch(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "square":
      return shape.side ** 2;
    default:
      // If a new shape variant is ever added to `Shape` and this switch isn't updated,
      // `shape` here would no longer be `never`, and this line fails to COMPILE --
      // catching a missed case before the code ever ships.
      const _exhaustive: never = shape;
      return _exhaustive;
  }
}
```

A **discriminated union** is a union of object types sharing a common literal-typed field (here, `kind`) that identifies which variant you have. Combined with a `switch` on that field and a `default` branch assigning to a `never`-typed variable, the compiler performs an **exhaustiveness check**: if someone adds a `Triangle` to `Shape` later and forgets to add a `case "triangle":`, the `default` branch's `shape` would no longer be assignable to `never`, and the whole file fails to compile until the new case is handled. This is one of TypeScript's most valuable real-world patterns — it converts "forgot to handle a new case" from a silent runtime bug into a build failure.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints results from `typeof`-based narrowing, `in`-based narrowing on a discriminated union, and an exhaustive `switch` correctly computing the area for both shape variants — plus a comment demonstrating (not literally compiled, since it would break the build) what happens if a new variant were added without updating the switch.

## Common Mistakes

- Writing a `switch` over a union type without a `default: const _exhaustive: never = ...` guard, silently allowing a future missed case to compile without any warning.
- Narrowing with `in` or `typeof` but then still explicitly casting with `as` afterward "just in case" — if you've already narrowed correctly, the assertion is redundant and reintroduces the exact unsafety narrowing was meant to avoid.
- Forgetting that narrowing is branch-local — a variable narrowed to `string` inside an `if` block reverts to its wider declared type once you're back outside that block (or after any intervening reassignment the compiler can't track).

## Best Practices

- Use discriminated unions (a shared literal `kind`/`type` field) for any "one of several distinct shapes" domain model, rather than a single type with many optional fields.
- Always add an exhaustiveness check (`default: const _exhaustive: never = value;`) to a `switch` over a union type, so growing the union later is a compile error until every switch handling it is updated.
- Prefer narrowing (`typeof`, `in`, discriminated unions) over assertions (Lesson 04) wherever the information needed to narrow is actually available.

## Real-World Usage

Discriminated unions with exhaustive switches are the standard way to model API response states (`{status: "loading"} | {status: "success", data: T} | {status: "error", message: string}`) in frontend data-fetching code, and Redux-style action types, specifically because the exhaustiveness check prevents a newly added state/action from being silently unhandled somewhere in the codebase.

## Summary

- Control flow syntax is unchanged from JavaScript; TypeScript adds compile-time narrowing across `if`/`switch` branches.
- `typeof`, `in`, and discriminated unions (a shared literal field) are the standard narrowing tools.
- An exhaustive `switch` (with a `never`-typed `default` guard) turns "forgot to handle a new union case" into a compile error instead of a silent runtime gap.

## Key Terms

- **Narrowing** — refining a broader type to a more specific one within a conditional branch, based on a runtime check the compiler recognizes.
- **Discriminated union** — a union of object types sharing a common literal-typed field used to distinguish which variant is present.
- **Exhaustiveness check** — using a `never`-typed variable in a `switch`'s `default` case to force a compile error if a union type gains an unhandled member.

## Review Questions

1. Why does narrowing a variable inside an `if` block not persist once execution exits that block?
2. What makes a union "discriminated," and why does that make exhaustive switches possible?
3. What would happen to the exhaustiveness-check example if a `Triangle` variant were added to `Shape` without updating the `switch`?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What is a discriminated union, and why is it useful?**
   A union of object types that all share one common property with distinct literal values (e.g., `kind: "circle"` vs. `kind: "square"`), letting the compiler narrow which specific variant is present just by checking that one field — in a `switch` or `if` on the discriminant, TypeScript automatically knows the rest of that branch's shape, without needing a manual type assertion.

2. **How does an exhaustiveness check work, concretely?**
   In a `switch`'s `default` case, you assign the (theoretically unreachable) value to a variable explicitly typed `never`. If every member of the union has already been handled by an earlier `case`, TypeScript has narrowed the value down to nothing left, which is compatible with `never`. If a new union member is added later and no `case` handles it, that member remains a possibility in the `default` branch, is no longer assignable to `never`, and the file fails to compile — flagging the gap immediately.

3. **Does type narrowing persist after the `if` block that performed the check?**
   No — narrowing is scoped to the branch where the check held true (and control-flow analysis can extend it a bit further via early returns, but not past a point where the compiler can no longer prove the condition still holds). Once execution rejoins code after the conditional, the variable reverts to its original wider declared type, unless the type has been reassigned to a specific narrower value in a way the compiler can still track.

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
