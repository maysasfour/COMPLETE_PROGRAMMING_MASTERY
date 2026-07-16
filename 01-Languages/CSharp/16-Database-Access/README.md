# 16 — Database Access

[Back to course overview](../README.md) | [Previous: Modules and Packages](../15-Modules-and-Packages/README.md)

## Learning Objectives

- Perform CRUD operations against SQLite using `Microsoft.Data.Sqlite` (ADO.NET-style raw access, no ORM).
- Use parameterized queries (`@paramName`) to prevent SQL injection.
- Use .NET 10 file-based apps' `#:package` directive to reference a NuGet package without a `.csproj`.

## Prerequisites

[15-Modules-and-Packages](../15-Modules-and-Packages/README.md)

## Concept

`Microsoft.Data.Sqlite` is the standard low-level (ADO.NET) SQLite driver for .NET — the BCL itself has no built-in database access, unlike Node's `node:sqlite` or Python's `sqlite3`, so a NuGet package is required. .NET 10's file-based apps support a `#:package` directive letting a single `.cs` file reference a NuGet package directly, restored automatically on `dotnet run` — keeping this lesson a single file despite needing an external dependency, consistent with the rest of this course.

## The `#:package` Directive

```csharp
#:package Microsoft.Data.Sqlite@10.0.10
using Microsoft.Data.Sqlite;

using var connection = new SqliteConnection("Data Source=:memory:");
connection.Open();
```

`#:package Name@Version` must be the very first line(s) of the file. `using var connection = ...` uses C#'s `using` **statement** (distinct from the `using` **directive** for namespaces) — it guarantees `connection.Dispose()` is called automatically when the enclosing scope ends, even if an exception occurs, exactly like Python's `with` statement.

## Parameterized Queries

```csharp
var cmd = connection.CreateCommand();
cmd.CommandText = "INSERT INTO tasks (title) VALUES (@title)";
cmd.Parameters.AddWithValue("@title", title);
cmd.ExecuteNonQuery();
```

`@title` is a named parameter placeholder; `.Parameters.AddWithValue(...)` binds the actual value separately from the SQL text — the ADO.NET equivalent of the `?`-placeholder pattern from the Python/JavaScript/TypeScript courses, and just as essential for preventing SQL injection.

## Detailed Example

See [example.cs](example.cs) — full CRUD against an in-memory SQLite database, plus the same SQL-injection-safety demonstration used in the JavaScript/TypeScript courses' equivalent lessons.

## Expected Output

Running `dotnet run example.cs` prints inserted rows (read back via `ExecuteReader`), an update reflected via `ExecuteScalar`, a delete reflected in the remaining row count, and confirmation that a malicious-looking string is safely stored and retrieved as plain data via a parameterized query, with the table surviving intact.

## Common Mistakes

- Concatenating user input directly into `CommandText` instead of using `@parameter` placeholders — the exact SQL-injection vulnerability this lesson demonstrates a safe alternative to.
- Forgetting `using var connection = ...` (or an explicit `try`/`finally` with `.Dispose()`), leaking the underlying native SQLite connection handle.
- Confusing `ExecuteNonQuery()` (for INSERT/UPDATE/DELETE, returns affected row count), `ExecuteScalar()` (for a query returning a single value), and `ExecuteReader()` (for a query returning multiple rows/columns) — using the wrong one for a given query shape is a common beginner mistake.

## Best Practices

- Always use `@parameter` placeholders for any dynamic value in SQL — never string-interpolate/concatenate.
- Use `using var connection = ...`/`using var reader = ...` for anything implementing `IDisposable`, ensuring cleanup even on an exception path.
- Choose the correct `ExecuteX` method for the query's shape (`NonQuery`/`Scalar`/`Reader`) rather than defaulting to `ExecuteReader()` for everything.

## Real-World Usage

Production ASP.NET Core applications typically use Entity Framework Core (an ORM, covered in [07-Databases](../../../07-Databases/)) rather than raw `Microsoft.Data.Sqlite`/ADO.NET directly, but EF Core's parameterized-query safety guarantee rests on exactly this same underlying mechanism — understanding the raw ADO.NET layer explains what an ORM is actually doing under the hood.

## Summary

- `Microsoft.Data.Sqlite` provides ADO.NET-style CRUD against SQLite; the BCL itself has no built-in database access.
- `#:package` lets a .NET 10 file-based app reference a NuGet package with no `.csproj`.
- `@parameter` placeholders with `.Parameters.AddWithValue(...)` are what actually prevent SQL injection — verified directly, not just claimed.

## Key Terms

- **ADO.NET** — .NET's low-level, provider-agnostic database access API (`Connection`, `Command`, `Reader`).
- **`#:package`** — a .NET 10 file-based app directive referencing a NuGet package without a `.csproj`.

## Interview Questions

1. **How do parameterized queries in ADO.NET prevent SQL injection?**
   `.Parameters.AddWithValue("@title", value)` sends the parameter value to the database separately from the SQL command text — the database driver binds it as pure data, never re-parsing it as SQL syntax, regardless of what characters the value contains. This is the same underlying principle as `?`-placeholders in SQLite/Python/Node drivers, just expressed through ADO.NET's named-parameter API.

2. **What's the difference between `ExecuteNonQuery`, `ExecuteScalar`, and `ExecuteReader`?**
   `ExecuteNonQuery()` runs a command that doesn't return rows (INSERT/UPDATE/DELETE/DDL) and returns the number of affected rows. `ExecuteScalar()` runs a query and returns just its first column of its first row, ideal for aggregate queries like `COUNT(*)`. `ExecuteReader()` runs a query expected to return multiple rows/columns, returned as a forward-only `SqliteDataReader` you iterate with `.Read()`.

## Recommended Next Lesson

[17 — API Integration](../17-API-Integration/README.md)
