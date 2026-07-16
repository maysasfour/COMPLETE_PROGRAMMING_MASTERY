# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Type database rows with an `interface`, and validate them at the boundary where they enter your typed code.
- Understand that a database driver's `.get()`/`.all()` return `unknown`/`any`-ish values that need the same validation discipline as `JSON.parse` (Lesson 10).

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

Database access mechanics are identical to [01-Languages/JavaScript/16-Database-Access](../../JavaScript/16-Database-Access/README.md) — `node:sqlite`'s `DatabaseSync`, prepared statements, `.run()`/`.get()`/`.all()`. The gap TypeScript exposes here is the same one from Lesson 10: a database row, like parsed JSON, comes from outside the type system entirely. Declaring `const task: Task = db.prepare(...).get(id)` would compile, but provides **no actual verification** that the real row matches `Task`'s shape — the same validate-before-trust discipline applies.

## Typing and Validating a Row

```ts
interface Task {
  id: number;
  title: string;
  done: number; // SQLite has no boolean type -- 0/1 as stored
}

function isTask(value: unknown): value is Task {
  return (
    typeof value === "object" &&
    value !== null &&
    typeof (value as Task).id === "number" &&
    typeof (value as Task).title === "string" &&
    typeof (value as Task).done === "number"
  );
}

function getTaskById(id: number): Task {
  const row: unknown = db.prepare("SELECT * FROM tasks WHERE id = ?").get(id);
  if (!isTask(row)) {
    throw new Error(`No task found with id ${id}, or row shape did not match Task`);
  }
  return row;
}
```

Note the row is fetched into an `unknown`-typed variable, exactly as with `JSON.parse` in Lesson 10 — this forces the type guard to actually run before any code can treat the result as a genuine `Task`, rather than silently trusting an unchecked annotation.

## Detailed Example

See [example.ts](example.ts) — full CRUD against an in-memory SQLite database with a validated `Task` interface, plus the same SQL-injection-safety demonstration from the JavaScript course's equivalent lesson.

## Expected Output

Compiling and running `example.ts` prints inserted rows, a validated `Task` fetched and used with a type-specific string method (proving it's genuinely typed, not just annotated), and confirmation that a SQL-injection-shaped string is safely treated as inert data via parameterized queries — the table survives with all rows intact.

## Common Mistakes

- Casting a raw database row directly to an interface (`db.prepare(...).get(id) as Task`) instead of validating it — this reintroduces exactly the unverified-annotation gap this lesson demonstrates a safer alternative to.
- Forgetting that SQLite has no native boolean type — a `boolean`-typed TypeScript field mapped to a SQLite `INTEGER` column needs an explicit `=== 1` (or similar) conversion at the boundary, not a bare type annotation pretending the stored `0`/`1` is already a `boolean`.

## Best Practices

- Validate database rows at the boundary (a type guard, same pattern as Lesson 10's JSON validation) before trusting them as a specific interface, rather than relying on an unchecked type annotation or `as` assertion.
- Keep parameterized queries as the absolute rule for any dynamic value in SQL, regardless of how "safe" a given input source seems.

## Real-World Usage

Every typed ORM ([07-Databases](../../../07-Databases/) — Prisma, TypeORM, Drizzle) exists largely to solve exactly this problem at scale: generating fully-validated, precisely-typed query results automatically instead of requiring a hand-written type guard per table, while still enforcing parameterized queries under the hood.

## Summary

- Database row shapes are typed with `interface`s, but — like `JSON.parse` results — must be validated at runtime before being trusted as that interface; an annotation alone verifies nothing.
- SQL injection prevention (parameterized `?` queries) is identical to the JavaScript course and remains non-negotiable regardless of the type system layered on top.

## Key Terms

- **Row validation** — checking a database row's actual shape against an expected interface at runtime, the same discipline as validating parsed JSON.

## Interview Questions

1. **Does typing a database query's result as an `interface` verify the actual row data matches that shape?**
   No — exactly like `JSON.parse`, a database driver's `.get()`/`.all()` methods return values TypeScript cannot verify against your application's types at compile time. An annotation or `as` assertion is trusted, not checked; a genuine runtime validator (a type guard) is needed to actually confirm the row matches before code relies on that shape.

2. **Why does SQLite storing booleans as `0`/`1` integers matter for TypeScript typing?**
   A TypeScript field typed `boolean` would be a lie if mapped directly to a raw `0`/`1` integer column value — the actual runtime value is a `number`, not a `boolean`. The interface should type that field as `number` (matching reality) and conversion to an actual `boolean` (`done === 1`) should happen explicitly at the point of use, not be silently assumed by the type annotation.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
