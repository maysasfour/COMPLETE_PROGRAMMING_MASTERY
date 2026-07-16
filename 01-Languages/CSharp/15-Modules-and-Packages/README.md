# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Organize code with `namespace`.
- Understand assemblies (`.dll`) as .NET's unit of deployment/versioning.
- Use NuGet (`dotnet add package`) and a `.csproj` project file.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

C# organizes code into **namespaces** (a purely logical grouping, like JavaScript modules but without one-namespace-per-file being required) compiled into **assemblies** (`.dll`/`.exe` files — .NET's actual unit of deployment, versioning, and loading). **NuGet** is .NET's package manager, analogous to npm, distributing packages that get referenced in a `.csproj` project file — analogous to `package.json`.

## Namespaces

```csharp
namespace MyApp.Utilities;  // file-scoped namespace declaration (C# 10+)

public class MathHelpers {
    public static int Add(int a, int b) => a + b;
}
```

```csharp
using MyApp.Utilities;
Console.WriteLine(MathHelpers.Add(2, 3));
```

Namespaces are purely organizational — unlike JavaScript's file-based module system, a C# namespace has no direct one-to-one relationship with files; multiple files can contribute to the same namespace, and files aren't required to match their namespace's name.

## A Real Project with NuGet

```bash
dotnet new console -o MyApp
cd MyApp
dotnet add package Newtonsoft.Json  # analogous to `npm install`
dotnet build
dotnet run
```

```xml
<!-- MyApp.csproj -- analogous to package.json -->
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0</TargetFramework>
    <Nullable>enable</Nullable>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Newtonsoft.Json" Version="13.0.3" />
  </ItemGroup>
</Project>
```

## Detailed Example

This lesson uses a real project (not a file-based app) specifically to demonstrate multiple files: [Program.cs](Program.cs) (the entry point) and [Utilities.cs](Utilities.cs) (a second file), both contributing to the `MyApp.Utilities` namespace — proving namespaces aren't tied to individual files. See [ModulesDemo.csproj](ModulesDemo.csproj) for the project file itself.

## Run It

```bash
cd 01-Languages/CSharp/15-Modules-and-Packages
dotnet run
```

(Unlike every other lesson in this course, this one is a real project, not a single file-based app — `dotnet run` with no filename argument builds and runs the whole project, discovering both `.cs` files automatically.)

## Expected Output

Running `dotnet run` prints results from `MathHelpers` (defined in `Utilities.cs`) called via `using MyApp.Utilities;` from `Program.cs` — a different file, same namespace.

## Common Mistakes

- Assuming a namespace must match its file's name or path — unlike Java's package-directory convention, C# namespaces are independent of file location (though IDEs conventionally suggest matching them for navigability).
- Confusing a NuGet package (a distributable unit, like an npm package) with a namespace (a logical code-organization construct) — one NuGet package can expose many namespaces, and namespaces from different packages can even share a name.

## Best Practices

- Follow the file-location-matches-namespace convention even though it isn't enforced — it's what every IDE and most C# developers expect for easy navigation.
- Pin NuGet package versions explicitly in `.csproj` (as shown above) rather than using floating version ranges, for reproducible builds.

## Real-World Usage

Every real C# project (beyond this course's single-file lessons) uses a `.csproj`-based structure with namespaces organizing feature areas (`MyApp.Controllers`, `MyApp.Services`, `MyApp.Data`) and NuGet references for dependencies (`Microsoft.EntityFrameworkCore`, `Serilog`, etc.).

## Summary

- Namespaces organize code logically, independent of file structure.
- Assemblies (`.dll`/`.exe`) are .NET's actual deployable/versioned unit.
- NuGet (`dotnet add package`) is .NET's package manager, with `.csproj` playing the role `package.json` plays for npm.

## Key Terms

- **Namespace** — a logical grouping of types, independent of file location.
- **Assembly** — a compiled `.dll`/`.exe`, .NET's unit of deployment and versioning.
- **NuGet** — .NET's package manager and public package registry.

## Interview Questions

1. **Is a C# namespace tied to a specific file, the way a JavaScript module is?**
   No — a namespace is a purely logical organizational construct; any number of files can contribute types to the same namespace, and a file's location has no enforced relationship to its namespace's name (though convention and IDE tooling strongly encourage matching them for discoverability).

2. **What's the difference between a namespace and an assembly?**
   A namespace is a compile-time, logical grouping of type names (preventing naming collisions and organizing code). An assembly is the actual compiled, deployable unit (a `.dll` or `.exe`) that the .NET runtime loads and versions — one assembly commonly contains types from several namespaces, and conversely, types from the same namespace can theoretically live in different assemblies.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
