# C#

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What C# Is

C# is a statically-typed, multi-paradigm language created by Microsoft, running on **.NET** — a managed runtime with automatic garbage collection, JIT compilation, and (since .NET Core) full cross-platform support (Windows, Linux, macOS). It is the primary language of the .NET ecosystem: ASP.NET Core (web APIs), Entity Framework Core (ORM), Blazor (web UI), MAUI (mobile/desktop), and Unity (game development) are all C#-first.

## Why / Where It's Used

- **Enterprise backends** — ASP.NET Core is a dominant choice for large-scale, high-performance web APIs, especially in .NET-invested organizations.
- **Game development** — Unity, one of the two dominant game engines, is scripted entirely in C#.
- **Windows desktop software** — WPF, WinForms, and .NET MAUI (also cross-platform) are C#-based.
- **Cloud-native services** — Azure has first-class, deeply integrated C#/.NET tooling.

## Advantages

- Strong static typing with modern ergonomics (type inference via `var`, nullable reference types, pattern matching, records).
- A single, unified runtime and standard library (the BCL) shared across web, desktop, mobile, and cloud.
- Excellent tooling — the C# compiler, debugger, and IDE support (Visual Studio, Rider, VS Code) are mature and fast.
- Since .NET Core, genuinely cross-platform and open source, closing the historical "Windows-only" gap.

## Disadvantages

- Historically perceived as a "Microsoft/Windows" language, even though this hasn't been true since .NET Core (2016) — some hiring/community perception lags the technical reality.
- More ceremony than a scripting language for small one-off scripts, though .NET 10's file-based apps (`dotnet run file.cs`, used throughout this course) substantially close that gap.
- The BCL and language surface area is large; there is more to learn before feeling fully fluent compared to a minimal language like Go.

## How to Install

```bash
# Windows/macOS/Linux -- download from https://dotnet.microsoft.com/download
dotnet --version
```

This course was written and verified against **.NET 10**, which introduced **file-based apps** — running a single `.cs` file directly with `dotnet run file.cs`, no `.csproj`/project scaffolding needed, exactly like `python file.py` or `node file.js`. On earlier .NET versions, wrap the same code in a console project (`dotnet new console`) instead.

## How to Run the Examples

```bash
cd 01-Languages/CSharp/03-Variables-and-Data-Types
dotnet run example.cs
```

Lessons 16 (Database Access) and 18 (Testing) use small dedicated project folders (with a `.csproj` and NuGet packages) instead of a single file-based app, since they need external packages (`Microsoft.Data.Sqlite`, `xunit`) that file-based apps don't support the same way — see those lessons' READMEs for their specific run commands.

## Common Beginner Mistakes

- **Confusing value types and reference types** — `struct`s (like `int`, `bool`, and custom `struct`s) are copied by value; `class`es are reference types, copied by reference (Lesson 03).
- **Forgetting `override` is required** to override a `virtual` method — C# requires it explicitly at both the base (`virtual`) and derived (`override`) sides, unlike some languages where overriding is implicit (Lesson 11).
- **Using `==` on reference types expecting value comparison** — by default, `==` on a `class` compares references, not contents, unless the class overrides equality (records, covered in Lesson 11, do this automatically).
- **Not handling `null` under nullable reference types** — enabled by default in modern C# project templates, `string?` vs. `string` distinguishes nullable from non-nullable references at compile time, similar in spirit to TypeScript's `strictNullChecks`.

## Best Practices

- Enable nullable reference types (`<Nullable>enable</Nullable>` in a `.csproj`, or via a directive) and treat compiler nullability warnings seriously.
- Prefer `record` types for immutable data-carrying types; prefer `class` for objects with identity and mutable behavior.
- Use LINQ (`.Where`, `.Select`, `.OrderBy`) for collection transformations instead of manual loops, mirroring the `map`/`filter`/`reduce` idiom from the JavaScript/TypeScript courses.
- Use `async`/`await` for I/O-bound work; avoid `.Result`/`.Wait()` on a `Task`, which can deadlock in certain synchronization contexts.

## Interview Questions

1. **What's the difference between a value type and a reference type in C#?**
   Value types (`struct`s, including all the built-in numeric types and `bool`) are copied by value — assigning one variable to another copies the entire value, and each copy is independent. Reference types (`class`es, `string` is a special case) are copied by reference — assigning one variable to another makes both point to the same underlying object, so mutating it through either variable is visible through both.

2. **What is the difference between `override` and `new` when hiding a base class member?**
   `override` participates in polymorphism — calling the method through a base-typed reference still invokes the derived class's version (dynamic dispatch). `new` merely hides the base member with an unrelated one of the same name — calling it through a base-typed reference invokes the *base* version, not the derived one, which is almost always not what's intended and is a common source of subtle bugs.

3. **What are nullable reference types, and what problem do they solve?**
   A compile-time-only annotation system (`string` vs. `string?`) that lets the compiler warn about a possible `null` dereference before it happens at runtime — directly analogous to TypeScript's `strictNullChecks`. It doesn't change runtime behavior (a `NullReferenceException` can still occur), but it catches the majority of accidental null-handling mistakes during development instead of in production.

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | .NET SDK, `dotnet run`, file-based apps, project structure |
| 02 | [Syntax](02-Syntax/README.md) | Statements, top-level statements, comments, semicolons |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Value vs. reference types, `var`, nullable reference types |
| 04 | [Operators](04-Operators/README.md) | Arithmetic/comparison/logical, `??`, `?.`, `is`/`as` |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/switch expressions, pattern matching, loops |
| 06 | [Functions](06-Functions/README.md) | Methods, optional/`params`/`out`/`ref` parameters, local functions |
| 07 | [Collections](07-Collections/README.md) | Arrays, `List<T>`, `Dictionary<K,V>`, LINQ |
| 08 | [Strings](08-Strings/README.md) | Interpolation, `StringBuilder`, immutability |
| 09 | [Error Handling](09-Error-Handling/README.md) | try/catch/finally, custom exceptions, exception filters |
| 10 | [File Handling](10-File-Handling/README.md) | `System.IO`, `System.Text.Json` |
| 11 | [OOP](11-OOP/README.md) | Classes, records, interfaces, inheritance, properties |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Delegates, `Func`/`Action`, lambdas, LINQ |
| 13 | [Generics](13-Generics/README.md) | Generic methods/classes, `where` constraints |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | `async`/`await`, `Task`, `Task.WhenAll` |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | Namespaces, assemblies, NuGet, `.csproj` |
| 16 | [Database Access](16-Database-Access/README.md) | `Microsoft.Data.Sqlite` CRUD, parameterized queries |
| 17 | [API Integration](17-API-Integration/README.md) | `HttpClient`, JSON deserialization |
| 18 | [Testing](18-Testing/README.md) | xUnit basics |
| 19 | [Best Practices](19-Best-Practices/README.md) | Synthesis checklist across lessons 01–18 |
| 20 | [Exercises](20-Exercises/README.md) | 7 standalone practice problems spanning the whole course |
| 21 | [Solutions](21-Solutions/README.md) | Verified, runnable solutions for every Lesson 20 exercise |
| 22 | [Mini Projects](22-Mini-Projects/README.md) | CLI Task Tracker — SQLite persistence, multi-project solution, xUnit tests |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 22 in order. Lessons 05, 06, and 07 have `Exercises/`/`Solutions/` pairs; Lessons 20-22 are standalone, course-wide capstone material.

**Previous language:** [TypeScript](../TypeScript/README.md) | **Next:** [Java](../Java/README.md)
