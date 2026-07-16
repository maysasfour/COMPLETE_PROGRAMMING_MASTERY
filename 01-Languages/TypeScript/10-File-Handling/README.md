# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Use `node:fs/promises` with full type checking on file contents and paths.
- Type a JSON file's shape with an `interface` and safely validate it after `JSON.parse` (which returns `any`).
- Write a small generic `readJsonFile<T>` helper.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

File I/O itself is identical to [01-Languages/JavaScript/10-File-Handling](../../JavaScript/10-File-Handling/README.md) — Node's `fs`/`path` modules have no TypeScript-specific behavior. What TypeScript adds is the ability to type the *shape* of file contents (especially JSON) and catch a mismatch between what a file actually contains and what your code assumes, though only as far as you help it — `JSON.parse` itself returns `any`, so there's a real gap to be aware of.

## The `JSON.parse` Gap

```ts
const raw = '{"theme": "dark", "fontSize": 14}';
const parsed = JSON.parse(raw); // typed `any` -- TypeScript does NOT verify this against anything
console.log(parsed.theme.toUpperCase()); // compiles fine, even if this were wrong
```

`JSON.parse` always returns `any`, because a compiler has no way to know a JSON string's actual structure at compile time. This means simply annotating a variable's type after parsing (`const config: Config = JSON.parse(raw)`) provides **zero real safety** — TypeScript trusts the annotation, but nothing was actually checked against the real data at runtime.

## A Typed, Validated `readJsonFile<T>` Helper

```ts
import { readFile } from "node:fs/promises";

interface Config {
  theme: string;
  fontSize: number;
}

function isConfig(value: unknown): value is Config {
  return (
    typeof value === "object" &&
    value !== null &&
    typeof (value as Config).theme === "string" &&
    typeof (value as Config).fontSize === "number"
  );
}

async function readJsonFile<T>(path: string, validate: (value: unknown) => value is T): Promise<T> {
  const raw = await readFile(path, "utf8");
  const parsed: unknown = JSON.parse(raw); // treat the parse result as unknown, not any
  if (!validate(parsed)) {
    throw new Error(`File at ${path} does not match the expected shape`);
  }
  return parsed;
}
```

Declaring `const parsed: unknown = JSON.parse(raw)` deliberately widens the otherwise-`any` result back to `unknown`, forcing the same narrow-before-use discipline from Lesson 03 — the `validate` type guard is what actually earns the right to treat `parsed` as `Config`, rather than a bare, unchecked annotation.

## Detailed Example

See [example.ts](example.ts) — writes a JSON config file, reads it back through the validated `readJsonFile<Config>` helper, and demonstrates the helper correctly rejecting a malformed file instead of silently returning a wrong-shaped object.

## Expected Output

Compiling and running `example.ts` prints a successfully round-tripped, validated config object, followed by a demonstration that a deliberately malformed JSON file is correctly rejected by the type guard with a thrown error, rather than silently accepted the way a bare `JSON.parse(...) as Config` would have been.

## Common Mistakes

- Writing `const config: Config = JSON.parse(raw)` and believing this validates the file's actual contents — it does not; TypeScript trusts the annotation with zero real verification.
- Assuming a `.json` file will always match your `interface` just because you wrote the interface — file contents come from outside the compiler's control (a config file edited by hand, an external API) and must be validated at runtime like any other untrusted input.
- Not handling the case where the file doesn't exist (the same `ENOENT` pattern from the JS course's Lesson 10 still applies identically here).

## Best Practices

- Always route `JSON.parse` results through a real runtime validator (a hand-written type guard, or a schema library like Zod in a real project) before trusting them as a specific `interface`.
- Treat any file's contents as untrusted input, exactly like a network response — the type system alone cannot verify what's actually on disk.
- Prefer a small generic helper (`readJsonFile<T>`) parameterized by a validator function over duplicating the same read-parse-validate logic per file type.

## Real-World Usage

Config-loading code in real TypeScript projects almost always pairs `JSON.parse` with either hand-written type guards (as shown here) or a runtime schema-validation library, specifically because a config file can be hand-edited incorrectly and the type system alone provides no protection against that.

## Summary

- File I/O mechanics are unchanged from the JavaScript course; TypeScript adds the ability to type file contents.
- `JSON.parse` always returns `any` — annotating its result with a specific type provides no actual verification.
- A generic `readJsonFile<T>` helper combined with a real type guard closes that gap by validating parsed JSON at runtime before trusting its shape.

## Key Terms

- **The `JSON.parse` gap** — the fact that `JSON.parse` returns `any`, meaning a type annotation on its result is trusted, not verified.
- **Runtime validation** — actually checking a value's shape at runtime (a type guard, a schema library) rather than merely asserting its type.

## Interview Questions

1. **Does typing a variable as `Config` after calling `JSON.parse` actually verify the JSON matches that shape?**
   No — `JSON.parse` returns `any`, and assigning it to a `Config`-typed variable is trusted by the compiler with zero runtime verification. If the actual JSON doesn't match `Config`'s shape, the mismatch surfaces later as a runtime error (or worse, a silently wrong value), not a compile-time one.

2. **How would you safely read and validate a JSON config file in TypeScript?**
   Parse it into an `unknown`-typed variable (not directly into the target interface type), then pass it through a real runtime type guard (a hand-written `value is Config` function, or a schema-validation library) that actually checks the required fields and their types exist before the code is allowed to treat it as `Config`.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
