# 21 — Solutions

[Back to course overview](../README.md) | [Exercises](../20-Exercises/README.md)

Runnable solutions for every problem in [20-Exercises](../20-Exercises/README.md). Each `solution-0N.ts` matches Exercise N. All seven were actually compiled with `tsc --strict --target ES2022 --skipLibCheck` and run with `node` during course construction — the output blocks below are real, captured terminal output, not predicted.

```bash
tsc solution-01.ts --strict --target ES2022 --skipLibCheck
node solution-01.js
```

(Repeat with the matching number for each solution. No extra flags are needed for any of these seven — none of them span multiple files or import `node:test`/`node:sqlite`, unlike Lessons 15/16/18.)

## Solution 01 — Generic `pluck` with a `keyof` Constraint

```
names: [ 'Ada', 'Grace', 'Alan' ] -- typeof first element: string
ages: [ 36, 85, 41 ] -- typeof first element: number
```

`K extends keyof T` is what makes the return type `T[K][]` rather than `unknown[]` — the compiler resolves `T[K]` per call site, so `pluck(people, "name")` and `pluck(people, "age")` return genuinely different, correctly-inferred types from the exact same function definition, no overloads needed.

## Solution 02 — Discriminated `Shape` Union with Exhaustiveness

```
circle: area = 78.54
rectangle: area = 24.00
triangle: area = 12.00
```

Same exhaustiveness technique as Lesson 05's `PaymentMethod` exercise (a `never`-typed variable in `default`), applied to a numeric-computation domain instead of a description-string domain — proof the pattern isn't tied to one particular use case.

## Solution 03 — A `Result<T, E>` Validation Pipeline

```
valid signup: OK -> { username: 'ada', email: 'ada@example.com', password: 'correcthorse' }
bad username (whitespace): FAILED -> Username cannot contain whitespace
bad email (no dot after @): FAILED -> "ada@examplecom" is not a valid email
bad password (too short): FAILED -> Password must be at least 8 characters
```

Each failing case fails at a *different* validator, and in every failing case only the validators up to and including the failing one actually ran — `andThen` short-circuits by simply returning the existing `err` without calling the next function, so no separate "stop on first error" bookkeeping is needed; it falls straight out of `Result`'s shape.

## Solution 04 — Utility Types: `Partial`, `Pick`, and `Omit` for a Patch API

```
created: { id: 1, name: 'Ada Lovelace', email: 'ada@example.com', age: 28 }
after email-only patch: {
  id: 1,
  name: 'Ada Lovelace',
  email: 'ada.lovelace@example.com',
  age: 28
}
original user untouched: { id: 1, name: 'Ada Lovelace', email: 'ada@example.com', age: 28 }
after name+age patch: { id: 1, name: 'Augusta Ada King', email: 'ada@example.com', age: 29 }
original user still untouched: { id: 1, name: 'Ada Lovelace', email: 'ada@example.com', age: 28 }
```

`updateUser` builds a *new* object via `{ ...user, ...patch }` rather than mutating `user`, which is why the "untouched" logs after each patch still show the original values — this is ordinary object-spread behavior, but the exercise's real point is that `patch`'s type (`Partial<Pick<User, "name" | "email" | "age">>`) makes `updateUser(user, { id: 2 })` a compile error, since `id` was never `Pick`ed in the first place.

## Solution 05 — A Generic, Constrained `InMemoryRepository<T>`

```
all tasks: [
  { id: 1, title: 'Write lesson', done: false },
  { id: 2, title: 'Compile examples', done: false },
  { id: 3, title: 'Review PR', done: true }
]
task 1 after update: { id: 1, title: 'Write lesson', done: true }
deleted task 2: true
remaining tasks: [
  { id: 1, title: 'Write lesson', done: true },
  { id: 3, title: 'Review PR', done: true }
]
expected error caught: No entity found with id 999
```

`T extends Entity` is the entire trick: the repository class body only ever touches `.id`, which `Entity` guarantees exists on any `T`, so one class definition works for `Task`, or any other entity shape, without `any` anywhere. `update`'s `Partial<Omit<T, "id">>` patch type mirrors Exercise 04 — a patch can touch any field except `id`.

## Solution 06 — A `Record`-Typed Role/Permission Matrix

```
--- permission grid ---
admin / read: true
admin / write: true
admin / delete: true
editor / read: true
editor / write: true
editor / delete: false
viewer / read: true
viewer / write: false
viewer / delete: false

--- assertPermission ---
expected error caught: Role "viewer" does not have permission "delete"
```

`Record<Role, Permission[]>` forces `rolePermissions` to have an entry for all three roles at the point it's declared — deleting the `viewer:` line from the object literal is a compile error (`Property 'viewer' is missing`), not a `hasPermission("viewer", ...)` call that silently returns `false` due to a bug rather than an intentional restriction.

## Solution 07 — A Generically-Typed Event Bus

```
[listener A] user created: #1 Ada
[listener] user deleted: #2
createdLog after emit: [ 'Ada' ]
```

`bus.on("userCreated", payload => ...)`'s `payload` parameter is inferred as exactly `{ id: number; name: string }`, not a union of every event's payload shape — that precision is what `K extends keyof Events` buys over a single untyped `emit(event: string, payload: unknown)` API.

### A Real Gotcha Found While Verifying This One

The first version of this solution declared the event map as `interface AppEvents { userCreated: ...; userDeleted: ...; }` and used it as `class TypedEventBus<Events extends Record<string, unknown>>`. That failed to compile:

```
solution-07.ts(29,31): error TS2344: Type 'AppEvents' does not satisfy the constraint 'Record<string, unknown>'.
  Index signature for type 'string' is missing in type 'AppEvents'.
```

The fix was changing `interface AppEvents { ... }` to `type AppEvents = { ... }`. The reason: an `interface` is "open" — code elsewhere could declaration-merge more properties onto it later — so TypeScript refuses to treat it as implicitly satisfying an index-signature-shaped constraint like `Record<string, unknown>`, even though its declared properties structurally match one. A `type` alias for an object literal is "closed" (no declaration merging is possible), so it satisfies the same constraint directly. This is a genuine, reproducible `tsc` error worth knowing — it's a common trap when writing a generic class or function constrained to `Record<string, X>` and reaching for `interface` out of habit (most other lessons in this course use `interface` for object shapes, which is why it was the first instinct here too).

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
