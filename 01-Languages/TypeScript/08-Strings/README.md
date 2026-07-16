# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Use all of JavaScript's string methods, now type-checked.
- Write and use template literal types — TypeScript's compile-time string-pattern types.
- Combine template literal types with unions to model a closed set of string patterns.

## Prerequisites

[07-Collections](../07-Collections/README.md)

## Concept

Runtime string behavior is identical to [01-Languages/JavaScript/08-Strings](../../JavaScript/08-Strings/README.md) — same methods, same immutability. TypeScript's genuinely new addition here is **template literal types**: a way to build string *types* (not values) out of literal unions, at compile time, letting the type system describe patterns like `"click:${string}"` or `"#${string}"` for a hex color.

## Basic Typed String Operations

```ts
function shout(text: string): string {
  return text.toUpperCase();
}

const userName: string = "Ada";
const greeting: string = `Hello, ${userName}`; // template literal VALUE -- unchanged from JS
```

## Template Literal Types

```ts
type EventName = "click" | "hover" | "focus";
type HandlerName = `on${Capitalize<EventName>}`; // "onClick" | "onHover" | "onFocus"

function registerHandler(name: HandlerName) {
  console.log(`Registered handler: ${name}`);
}

registerHandler("onClick"); // fine
// registerHandler("onScroll"); // error: not assignable to type HandlerName
```

A **template literal type** looks exactly like a template literal *value* but appears in type position, and TypeScript computes the full set of concrete string literal types it describes — here, exactly `"onClick" | "onHover" | "onFocus"`, no more and no less. `Capitalize<T>` is one of TypeScript's built-in string-manipulation utility types (others include `Uppercase<T>`, `Lowercase<T>`, `Uncapitalize<T>`), operating purely on types, at compile time — they have no runtime equivalent or cost.

## Modeling String Patterns

```ts
type HexColor = `#${string}`;

function setColor(color: HexColor) {
  console.log("Setting color to", color);
}

setColor("#ff0000"); // fine -- matches the pattern
// setColor("red");   // error: 'red' is not assignable to type `#${string}`
```

This lets the type system reject a plainly wrong string shape (missing the `#` prefix) at compile time, something a plain `string` parameter could never catch.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints typed string method usage, a template-literal-type-derived union of handler names being used correctly, and a hex-color pattern type accepting a correctly-shaped string.

## Common Mistakes

- Confusing template literal *types* (compile-time, describe a set of string shapes) with template literal *values* (runtime, produce an actual string) — they look identical but exist in entirely different worlds (type-checking vs. execution).
- Using a plain `string` parameter where a template literal type or literal union would have caught an invalid format at compile time (e.g., a malformed event name, a color missing its `#`).
- Forgetting utility types (`Capitalize`, `Uppercase`, etc.) only operate on **types**, not on runtime string values — `Capitalize<"hello">` is a type-level operation; `"hello".charAt(0).toUpperCase() + "hello".slice(1)` is what you'd write to capitalize an actual runtime string value.

## Best Practices

- Use template literal types for parameters that must follow a specific string pattern (event names, CSS units, route paths) instead of a bare `string`.
- Combine template literal types with literal unions to auto-derive a related set of string literals (like the `on${Capitalize<EventName>}` handler-name pattern) instead of manually writing out and maintaining a second parallel union.

## Real-World Usage

Template literal types are used in typed CSS-in-JS libraries (to type-check units like `"10px" | "2rem"`), typed routing libraries (to validate route path patterns at compile time), and typed event-emitter APIs (mapping `"click"` to a required `"onClick"` handler name), all without any runtime cost since the checking happens entirely at compile time.

## Summary

- Runtime string behavior is unchanged from JavaScript; TypeScript adds compile-time typing on top.
- Template literal types build string *types* from literal unions, letting the type system reject malformed string shapes before runtime.
- Built-in utility types (`Capitalize`, `Uppercase`, `Lowercase`, `Uncapitalize`) operate purely at the type level, with zero runtime cost or equivalent.

## Key Terms

- **Template literal type** — a type-level construct describing a set of string literal types, built using the same `` `${}` `` syntax as runtime template literals.
- **Utility type** — a built-in generic type (like `Capitalize<T>`) that transforms another type, evaluated entirely at compile time.

## Interview Questions

1. **What's the difference between a template literal value and a template literal type?**
   A template literal value (`` `Hello, ${name}` ``) is ordinary JavaScript, evaluated at runtime to produce an actual string. A template literal type (`` `on${Capitalize<EventName>}` ``) exists purely in TypeScript's type system, evaluated by the compiler to describe a set of possible string literal types — it has no runtime representation or cost and vanishes entirely after compilation (Lesson 01's type erasure).

2. **What problem do template literal types solve that a plain `string` parameter type can't?**
   A plain `string` accepts any string value at all, so a malformed pattern (a color missing its `#`, a mistyped event handler name) is only caught, if ever, at runtime. A template literal type (`` `#${string}` ``) restricts the parameter to only strings matching that literal pattern, catching a malformed value at compile time instead.

## Recommended Next Lesson

Lessons 09 onward (Error Handling, File Handling, OOP, Generics, Async/Concurrency, and beyond) are not yet built for TypeScript — see [BUILD_STATUS.md](../../../BUILD_STATUS.md). Note that Generics — a much bigger topic in TypeScript than plain JavaScript, given [01-Languages/JavaScript/13-Generics](../../JavaScript/13-Generics/README.md)'s honest explanation of why JS has none — deserves its own dedicated lesson here rather than the brief informal use seen in this course's Lesson 06/07 exercises. Until further lessons are built, continue applying TypeScript directly in [03-Frontend-Development](../../../03-Frontend-Development/) or [04-Backend-Development](../../../04-Backend-Development/), both of which have first-class TypeScript support.
