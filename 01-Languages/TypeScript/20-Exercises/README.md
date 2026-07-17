# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. These are deliberately **not** the same problems as the per-lesson `Exercises/` folders already inside Lessons 05, 06, and 07 (discriminated payment methods, an overloaded `wrapInArray`, and a `Record`-typed inventory, respectively) — each problem below picks a different domain so solving it actually exercises new judgment rather than repeating a lesson you've already done. The throughline across all seven is TypeScript's type system specifically: generic constraints, discriminated unions, utility types (`Partial`/`Pick`/`Omit`/`Record`), and the `Result<T, E>` pattern from Lesson 09 — none of this would be enforced by plain JavaScript.

Attempt each problem yourself in a scratch `.ts` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`exercise-01` ↔ `solution-01.ts`).

## Exercise 01 — Generic `pluck` with a `keyof` Constraint (Beginner/Intermediate)

**Lessons used:** Generics (13), Collections (07)

Write a generic function:

```ts
function pluck<T, K extends keyof T>(items: T[], key: K): T[K][]
```

that extracts one property from every object in an array, with the return element type inferred correctly from `K` (not widened to `any` or `unknown`). Demonstrate it against an array of at least three `{ id: number; name: string; age: number }` objects — pluck the `name`s into a `string[]` and the `age`s into a `number[]` from the *same* array, using the *same* function, and log both results plus their `typeof` to show the return type genuinely tracked which key was requested.

**Constraint:** `pluck(users, "nonexistentField")` must fail to *compile* — don't demonstrate this failing call in your solution file (it wouldn't compile), just make sure your signature would actually reject it.

## Exercise 02 — Discriminated `Shape` Union with Exhaustiveness (Intermediate)

**Lessons used:** Control Flow (05), Generics/type modeling (13)

Model three shapes as a discriminated union on a `kind` field:

- `Circle`: `{ kind: "circle"; radius: number }`
- `Rectangle`: `{ kind: "rectangle"; width: number; height: number }`
- `Triangle`: `{ kind: "triangle"; base: number; height: number }`

Write `area(shape: Shape): number` using a `switch` on `kind`, with a `never`-typed exhaustiveness check in the `default` branch (same technique as Lesson 05, applied to a new domain). Also write `describe(shape: Shape): string` returning e.g. `"circle: area = 78.54"` (round to 2 decimal places). Demonstrate all three shapes.

## Exercise 03 — A `Result<T, E>` Validation Pipeline (Intermediate/Advanced)

**Lessons used:** Error Handling (09), Functional Concepts (12)

Using the `Result<T, E>` type from Lesson 09 (`{ ok: true; value: T } | { ok: false; error: E }`), write:

- `ok<T>(value: T): Result<T, never>` and `err<E>(error: E): Result<never, E>` helper constructors.
- A generic `andThen<T, U, E>(result: Result<T, E>, fn: (value: T) => Result<U, E>): Result<U, E>` that only calls `fn` when `result` is `ok`, otherwise passes the existing error through unchanged (this is what lets you *chain* validators without nested `if`s).
- Three validators for signing up a user — `validateUsername(input: string): Result<string, string>` (non-empty, no whitespace), `validateEmail(input: string): Result<string, string>` (must contain `@` and a `.` after it), `validatePassword(input: string): Result<string, string>` (at least 8 characters) — each returning a specific error message on failure.
- A `signup(username: string, email: string, password: string): Result<{ username: string; email: string; password: string }, string>` that chains all three validators with `andThen`, short-circuiting on the first failure.

Demonstrate: one fully valid signup, and at least two invalid ones that fail at *different* validators (show the pipeline stops at the first failure rather than running all three every time).

## Exercise 04 — Utility Types: `Partial`, `Pick`, and `Omit` for a Patch API (Intermediate)

**Lessons used:** Collections (07), Generics (13)

Given:

```ts
interface User {
  id: number;
  name: string;
  email: string;
  age: number;
}
```

Write:

- `type CreateUserInput = Omit<User, "id">` — the shape needed to create a user before an `id` is assigned.
- `function updateUser(user: User, patch: Partial<Pick<User, "name" | "email" | "age">>): User` — returns a new `User` with only the provided fields overwritten (the original `user` is not mutated; `id` can never be changed through `patch`, enforced by the type, not by a runtime check).

Demonstrate: create a user from a `CreateUserInput` plus an assigned `id`, then apply two different partial patches (one changing only `email`, one changing `name` and `age` together) and show the original object is untouched after each call.

## Exercise 05 — A Generic, Constrained `InMemoryRepository<T>` (Advanced)

**Lessons used:** Generics (13), OOP (11), Error Handling (09)

Write:

```ts
interface Entity {
  id: number;
}

class InMemoryRepository<T extends Entity> {
  add(item: T): void
  getById(id: number): T | undefined
  update(id: number, patch: Partial<Omit<T, "id">>): T   // throws a custom NotFoundError if id doesn't exist
  delete(id: number): boolean
  all(): T[]
}
```

The `T extends Entity` constraint is what lets the repository index by `.id` generically, for *any* entity shape, without knowing what T is in advance. Demonstrate the repository working against a `Task` entity (`{ id: number; title: string; done: boolean }`): add three tasks, update one, delete one, list what remains, and show `update` on a nonexistent id throwing your custom error.

## Exercise 06 — A `Record`-Typed Role/Permission Matrix (Intermediate)

**Lessons used:** Collections (07), Generics (13)

Model a small access-control system:

- `type Role = "admin" | "editor" | "viewer"`
- `type Permission = "read" | "write" | "delete"`
- `const rolePermissions: Record<Role, Permission[]>` — every role must be present (a missing role is a compile error; you don't need to demonstrate the failing case).
- `function hasPermission(role: Role, permission: Permission): boolean`
- `function assertPermission(role: Role, permission: Permission): void` — throws a descriptive `Error` if `hasPermission` is `false`.

Demonstrate every role against every permission (a 3×3 grid of results), plus one call to `assertPermission` that throws, caught and logged rather than crashing the program.

## Exercise 07 — A Generically-Typed Event Bus (Advanced)

**Lessons used:** Generics (13), Functional Concepts (12), Collections (07)

Design a typed publish/subscribe event bus where the set of valid event names *and* each event's payload shape are both defined once, in a single interface, and enforced everywhere else:

```ts
interface AppEvents {
  userCreated: { id: number; name: string };
  userDeleted: { id: number };
}

class TypedEventBus<Events extends Record<string, unknown>> {
  on<K extends keyof Events>(event: K, listener: (payload: Events[K]) => void): void
  emit<K extends keyof Events>(event: K, payload: Events[K]): void
}
```

The key property to preserve: `bus.on("userCreated", (payload) => ...)` must give `payload` the *exact* `{ id: number; name: string }` type, not a union of every event's payload shapes. Demonstrate: register two listeners on `userCreated` (one logs, one collects into an array) and one on `userDeleted`, emit one of each event, and show both `userCreated` listeners fired with a correctly-typed payload.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
