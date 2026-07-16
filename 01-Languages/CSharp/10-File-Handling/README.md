# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read and write text files with `System.IO.File`.
- Read and write JSON with `System.Text.Json`.
- Handle a missing file with a specific caught exception type.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

`System.IO.File` provides simple static methods (`ReadAllText`, `WriteAllText`, and their `Async` counterparts) for whole-file operations — the BCL equivalent of Node's `fs/promises`. `System.Text.Json` (built into the BCL since .NET Core 3, no NuGet package needed) handles JSON serialization/deserialization directly into/from C# objects.

## Reading and Writing Text and JSON

```csharp
using System.Text.Json;

File.WriteAllText("notes.txt", "Hello, file system!\n");
string contents = File.ReadAllText("notes.txt");

record Config(string Theme, int FontSize);

var config = new Config("dark", 14);
string json = JsonSerializer.Serialize(config);
File.WriteAllText("config.json", json);

string rawConfig = File.ReadAllText("config.json");
Config? loaded = JsonSerializer.Deserialize<Config>(rawConfig);
```

`JsonSerializer.Deserialize<T>()` is generic (Lesson 13) — unlike JavaScript's `JSON.parse` (always `any`) or even a hand-validated TypeScript approach, C#'s deserializer uses reflection to populate a real, strongly-typed object directly, throwing `JsonException` if the JSON structurally can't be mapped onto `T`. This is a genuine, automatic form of the "validate at the boundary" principle from the TypeScript course, though it validates *shape/type compatibility*, not arbitrary business rules (a `FontSize` of `-999` deserializes successfully; validating that it's a *sensible* value is still the caller's job).

## Handling a Missing File

```csharp
try {
    string contents = File.ReadAllText("does-not-exist.json");
} catch (FileNotFoundException) {
    Console.WriteLine("File doesn't exist -- using defaults");
}
```

## Detailed Example

See [example.cs](example.cs) — writes and reads a text file and a JSON config, and handles a genuinely missing file.

## Expected Output

Running `dotnet run example.cs` prints round-tripped text and JSON content, and confirms reading a missing file throws `FileNotFoundException`, caught and handled gracefully.

## A Real .NET 10 File-Based App Gotcha

Running `JsonSerializer.Serialize`/`Deserialize` directly in a file-based app (`dotnet run file.cs`, no `.csproj`) throws `InvalidOperationException: Reflection-based serialization has been disabled for this application` — file-based apps default to settings optimized for trimming/AOT publishing, which disable reflection-based JSON by default. The fix, needed once per file that uses `System.Text.Json` this way:

```csharp
AppContext.SetSwitch("System.Text.Json.JsonSerializer.IsReflectionEnabledByDefault", true);
```

This is **not** an issue in a normal `.csproj`-based console/web project (Lesson 15) — reflection-based serialization is enabled by default there. It's specific to file-based apps' AOT-friendly defaults, and worth knowing exactly because it's the kind of environment-specific surprise that costs real debugging time the first time you hit it.

## Common Mistakes

- Catching the general `Exception` instead of the specific `FileNotFoundException`/`DirectoryNotFoundException`, masking other genuine I/O errors (permissions, disk issues) under the same handling.
- Assuming `JsonSerializer.Deserialize<T>()` validates business rules — it only validates that the JSON's shape is structurally compatible with `T`'s properties/types, not that the values themselves are sensible.
- Hitting the reflection-disabled error above in a file-based app and not realizing it's an app-model default, not a bug in the JSON itself.

## Best Practices

- Catch the most specific exception type that represents the failure you're actually prepared to handle (`FileNotFoundException`, not a bare `Exception`).
- Clean up any files a lesson/test creates, exactly as the Node-based courses do, to keep the repository tidy.

## Real-World Usage

`System.Text.Json`'s generic deserialization is the standard way ASP.NET Core reads configuration and request bodies into strongly-typed C# objects automatically, without hand-written parsing code.

## Summary

- `System.IO.File` provides simple static methods for whole-file text I/O.
- `System.Text.Json`'s `JsonSerializer.Deserialize<T>()` maps JSON directly onto a strongly-typed object via reflection, throwing on structural mismatch.
- Catch specific exception types (`FileNotFoundException`) rather than a general `Exception` for expected, recoverable file-I/O failures.

## Key Terms

- **`System.Text.Json`** — the BCL's built-in JSON serialization library, no NuGet package required.

## Interview Questions

1. **How does `JsonSerializer.Deserialize<T>()` compare to JavaScript's `JSON.parse`?**
   `JSON.parse` always returns `any` (or, in TypeScript, still untyped without a manual cast) — no verification against any expected shape happens. `JsonSerializer.Deserialize<T>()` uses reflection to populate an actual instance of `T`, throwing `JsonException` if the JSON's structure is incompatible with `T`'s properties — a genuine, automatic form of the validate-at-the-boundary principle, though it checks structural/type compatibility, not arbitrary business-rule validity.

2. **Why catch `FileNotFoundException` specifically instead of a general `Exception` when reading a possibly-missing file?**
   Catching the specific type means only the exact failure you intended to handle ("the file isn't there") is caught; other failures (permission denied, disk error, a genuinely unexpected bug) still propagate and aren't silently swallowed under the same handling path.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
