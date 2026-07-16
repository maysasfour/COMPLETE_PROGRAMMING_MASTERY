# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Type arrays, tuples, and `Map`/`Set` precisely.
- Use `interface`/`type` to describe object shapes, and `Record<K, V>` for uniform key-value maps.
- Use `readonly` to prevent accidental mutation, and distinguish it from `const`.
- Understand why array/object destructuring and spread keep their types automatically.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

Every collection type from [01-Languages/JavaScript/07-Collections](../../JavaScript/07-Collections/README.md) (arrays, objects, `Map`, `Set`) gets a type parameter or shape declaration in TypeScript, closing the gap where plain JavaScript would silently accept a wrong-shaped element. Object shapes are described with `interface` or `type`; TypeScript infers array/object literal types automatically, but named shapes make code far more self-documenting and reusable.

## Typed Arrays, Tuples, `Map`, `Set`

```ts
const scores: number[] = [95, 88, 76];       // array of numbers
const pair: [string, number] = ["Ada", 30];  // tuple: fixed length, fixed per-position types

const ages = new Map<string, number>();       // Map<K, V>
ages.set("Ada", 30);

const uniqueTags = new Set<string>(["js", "ts"]); // Set<T>
```

A tuple (`[string, number]`) is stricter than `(string | number)[]` — the tuple guarantees exactly two elements, in exactly that order and type, while the union-typed array allows any length and any mix of the two types in any order.

## Describing Object Shapes: `interface` and `type`

```ts
interface User {
  id: number;
  name: string;
  email?: string; // optional property
  readonly createdAt: Date; // cannot be reassigned after the object is created
}

type Point = { x: number; y: number }; // `type` can describe the same kind of shape
```

`interface` and `type` overlap significantly for describing plain object shapes; the practical difference that matters most day-to-day: `interface` can be **reopened** (declaration merging — the same interface name declared twice adds to it) and is conventionally preferred for object shapes meant to be extended; `type` is required for unions, tuples, and other non-object-shape constructs (`type Status = "a" | "b"` cannot be written as an `interface`).

## `Record<K, V>` for Uniform Key-Value Maps

```ts
const inventory: Record<string, number> = {
  apples: 10,
  bananas: 5,
};

type Role = "admin" | "editor" | "viewer";
const permissions: Record<Role, string[]> = {
  admin: ["read", "write", "delete"],
  editor: ["read", "write"],
  viewer: ["read"],
};
```

`Record<K, V>` describes a plain object where every key is of type `K` and every value is of type `V` — when `K` is a literal union (like `Role` above), TypeScript **requires** every member of that union to be present as a key, catching a missing role's permissions at compile time rather than a runtime `undefined` lookup.

## `readonly`

```ts
interface Config {
  readonly apiUrl: string;
}

const config: Config = { apiUrl: "https://api.example.com" };
// config.apiUrl = "https://other.com"; // error: Cannot assign to 'apiUrl' because it is a read-only property

const numbers: readonly number[] = [1, 2, 3];
// numbers.push(4); // error: Property 'push' does not exist on type 'readonly number[]'
```

`readonly` on a property (or `readonly T[]`/`ReadonlyArray<T>` for arrays) is a compile-time-only guarantee — it prevents *your code* from compiling if it tries to mutate, but has no runtime enforcement (unlike `Object.freeze()`, which does throw/silently fail at runtime). `const` prevents *reassigning the variable binding*; `readonly` prevents *mutating a property* — they solve different problems and are often used together.

## Detailed Example

See [example.ts](example.ts).

## Expected Output

Compiling and running `example.ts` prints a typed array/tuple, a typed `Map`/`Set`, an interface-shaped object including its `readonly` field, a `Record<Role, string[]>` guaranteeing every role has permissions, and a demonstration that `const` and `readonly` protect against different kinds of mutation.

## Common Mistakes

- Using `(string | number)[]` when a fixed-shape tuple (`[string, number]`) is what's actually meant, losing the guarantee of exact length/order.
- Believing `readonly`/`Readonly<T>` provides runtime protection — it's compile-time only; a value cast with `as` or accessed via plain JavaScript (no type checking) can still be mutated.
- Using a plain `Record<string, V>` when a literal union key type (`Record<Role, V>`) would have forced every case to be handled at compile time.
- Forgetting `interface`/`type` are structural (Lesson 02) — an object satisfies an interface by shape, not by declaring `implements SomeInterface` the way Java/C# require.

## Best Practices

- Use tuples for genuinely fixed-shape, fixed-length data (a coordinate pair, a `[key, value]` entry); use arrays for variable-length homogeneous collections.
- Use `Record<LiteralUnion, V>` instead of `Record<string, V>` whenever the valid keys form a known, closed set — it catches a missing key at compile time.
- Mark properties `readonly` wherever external code shouldn't mutate them after construction, understanding it's a compile-time contract, not runtime enforcement.
- Prefer `interface` for public object shapes meant to be extended/implemented; use `type` for unions, tuples, and mapped/conditional types.

## Real-World Usage

`Record<Role, Permission[]>`-style exhaustive maps are common in access-control code exactly because they force every role to be accounted for at compile time; API response types are almost always modeled with `interface`s so every consumer of that API gets full autocomplete and compile-time checking against the expected shape.

## Summary

- Tuples (`[T1, T2]`) are stricter than arrays — fixed length and per-position types.
- `interface`/`type` describe object shapes structurally; `interface` supports declaration merging, `type` is required for unions/tuples.
- `Record<K, V>` models uniform key-value maps, and forces every member of a literal union key type to be present.
- `readonly` is a compile-time-only mutation guard, distinct from `const`'s "cannot reassign the binding."

## Key Terms

- **Tuple** — a fixed-length array type with a specific type for each position.
- **`Record<K, V>`** — a utility type for an object whose keys are all of type `K` and values all of type `V`.
- **`readonly`** — a compile-time-only modifier preventing reassignment of a property (or, on arrays, mutation methods) after initial assignment.

## Review Questions

1. Why does `Record<Role, string[]>` catch a missing role at compile time when `Record<string, string[]>` wouldn't?
2. Why is `readonly` not equivalent to runtime immutability the way `Object.freeze()` is?
3. When is a tuple type preferable to an array type for the same data?

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between `interface` and `type` in TypeScript?**
   Both can describe an object's shape, and for that specific use case are largely interchangeable. `interface` supports declaration merging (declaring the same interface name more than once adds to a single merged interface) and is conventionally used for object shapes meant to be extended. `type` is required for anything that isn't a plain object shape — unions, tuples, mapped types, conditional types — and cannot be reopened/merged the way `interface` can.

2. **Does `readonly` provide runtime immutability?**
   No — `readonly` is checked and enforced only by the TypeScript compiler at compile time; once compiled to plain JavaScript, there is no runtime protection at all, and the property can be reassigned via plain JavaScript, a type assertion, or any code path the compiler didn't check. Genuine runtime immutability requires `Object.freeze()` (shallow) or a deep-freeze utility.

3. **Why would you use `Record<SomeLiteralUnion, V>` instead of `Record<string, V>`?**
   With a literal union as the key type, TypeScript requires every member of that union to be present as a key in any object typed as that `Record` — omitting one is a compile-time error. With a plain `string` key type, any subset of keys (including none at all) satisfies the type, so a missing key is only discovered as `undefined` at runtime when someone tries to look it up.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
