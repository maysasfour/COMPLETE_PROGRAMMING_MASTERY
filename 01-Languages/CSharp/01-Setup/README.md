# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Install the .NET SDK and verify it.
- Run a single `.cs` file directly with .NET 10's file-based apps feature.
- Understand the difference between a file-based app and a full project (`.csproj`).

## Prerequisites

None — entry point of the C# course.

## Concept

C# compiles to Intermediate Language (IL), which the .NET runtime JIT-compiles to native code at execution time — similar in spirit to how the JVM runs Java bytecode. Traditionally, running any C# code required a full project with a `.csproj` file. **.NET 10 introduced file-based apps**: `dotnet run app.cs` compiles and runs a single file directly, no project scaffolding needed, finally giving C# the same "just run the file" ergonomics Python/JavaScript have always had.

## Syntax

```bash
dotnet --version
dotnet run hello.cs
```

```csharp
// hello.cs
Console.WriteLine("Hello, C#");
```

**Top-level statements** (no `class Program { static void Main() { ... } }` boilerplate required) have been standard since C# 9 — the file above is a complete, runnable program exactly as written.

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints a greeting and the running .NET version.

## Common Mistakes

- Assuming every `.cs` file needs a `.csproj` — true historically, no longer true for single-file scripts on .NET 10+.
- Forgetting semicolons — C# requires them, unlike Python.

## Best Practices

- Use file-based apps (`dotnet run file.cs`) for lessons/scripts/prototypes; use a full project (`dotnet new console`) once a program grows past one file or needs NuGet packages.

## Real-World Usage

Full ASP.NET Core/production projects always use `.csproj`-based projects (Lesson 15); file-based apps are primarily for scripts, prototypes, and — as in this course — self-contained lessons.

## Summary

- .NET 10's file-based apps let a single `.cs` file run directly via `dotnet run file.cs`.
- Top-level statements remove `Main`-method boilerplate for simple programs.

## Key Terms

- **IL (Intermediate Language)** — the compiled form of C# code, JIT-compiled to native code at runtime.
- **File-based app** — a single `.cs` file runnable directly, without a `.csproj` project file.

## Interview Questions

1. **What does the .NET runtime do with compiled C# code?**
   The C# compiler produces Intermediate Language (IL), a platform-independent bytecode. The .NET runtime's JIT (Just-In-Time) compiler translates IL to native machine code at execution time, similar to how the JVM executes Java bytecode.

2. **What are top-level statements?**
   A C# 9+ feature allowing a program's entry point to be written as plain statements at the top of a file, without the traditional `class Program { static void Main(string[] args) { ... } }` wrapper — the compiler generates that boilerplate implicitly.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
