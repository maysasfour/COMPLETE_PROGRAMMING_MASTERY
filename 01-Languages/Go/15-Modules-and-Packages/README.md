# 15 — Modules and Packages

[Back to course overview](../README.md) | [Previous: Async and Concurrency](../14-Async-and-Concurrency/README.md)

## Learning Objectives

- Understand Go packages (directory-based, like Java, unlike C#) and modules (`go.mod`).
- Use exported (capitalized) vs. unexported (lowercase) names for visibility control.
- Use `go get` to add a dependency.

## Prerequisites

[14-Async-and-Concurrency](../14-Async-and-Concurrency/README.md)

## Concept

Like Java's packages (and unlike C#'s location-independent namespaces), a Go **package** corresponds to a directory — every `.go` file in a directory belongs to the same package, declared via `package name` at the top. A Go **module** (`go.mod`) is the unit of dependency versioning and distribution — one module can contain many packages (subdirectories), and `go.mod` declares the module's own import path plus its dependencies' versions, directly analogous to `package.json` (npm) or a `.csproj` (NuGet).

## Packages and Visibility

```go
// mathutils/mathutils.go
package mathutils

func Add(a, b int) int { return a + b } // EXPORTED (capitalized) -- visible outside this package
func helper() int { return 42 }            // unexported (lowercase) -- package-private
```

```go
// main.go, in a different directory, same module
import "example.com/modulesdemo/mathutils"

mathutils.Add(2, 3) // works -- Add is exported
// mathutils.helper() // compile error -- helper is unexported, invisible outside its package
```

Go's visibility rule is refreshingly simple compared to Java/C#'s `public`/`private`/`protected`/package-private matrix: **capitalization is the only visibility mechanism** — a capitalized identifier (function, type, struct field, constant) is exported (visible to importers); a lowercase one is package-private. No keywords needed.

## `go.mod` and Modules

```bash
go mod init example.com/myproject  # creates go.mod, declaring the module's import path
go get github.com/some/dependency   # adds a dependency, recorded in go.mod and go.sum
go mod tidy                          # cleans up go.mod/go.sum to match actual imports
```

```
module example.com/modulesdemo

go 1.23.4
```

Unlike `node_modules`/a JAR/a NuGet package (all typically excluded from version control), **`go.mod`/`go.sum` themselves are small text files meant to be committed** — they declare dependency versions, not the dependencies' actual code (which lives in a shared module cache, downloaded on demand, analogous to how npm/NuGet/Maven caches work).

## Detailed Example

See [main.go](main.go), [mathutils/mathutils.go](mathutils/mathutils.go), and [go.mod](go.mod) — a genuine two-package module, with `main` importing `mathutils` by its full module-relative import path.

## Run It

```bash
cd 01-Languages/Go/15-Modules-and-Packages
go run main.go
```

## Expected Output

Running `go run main.go` prints results from `mathutils.Add`/`mathutils.Multiply`, functions defined in a separate package/directory, imported via the module's declared path.

## Common Mistakes

- Forgetting a name must be **capitalized** to be visible outside its package — a very common early mistake for developers used to explicit `public`/`private` keywords.
- Assuming Go packages are location-independent like C# namespaces — they're not; a package's files must all live in the same directory, and the import path is derived from the module path plus the directory structure.
- Committing `go.sum` inconsistently, or not at all — unlike a JAR/exe, it's meant to be version-controlled for reproducible builds.

## Best Practices

- Export only what genuinely needs to be part of a package's public API; keep implementation details unexported (lowercase).
- Commit both `go.mod` and `go.sum` to version control.
- Use `go mod tidy` regularly to keep dependency declarations accurate and minimal.

## Real-World Usage

Every real Go project uses `go.mod`; the module system (introduced in Go 1.11) replaced an earlier, more ad hoc `GOPATH`-based dependency approach and is now the universal standard, much more so than C++'s fragmented CMake/vcpkg/Conan situation.

## Summary

- A Go package corresponds to a directory (like Java, unlike C#); capitalization (not keywords) controls visibility.
- A Go module (`go.mod`) is the unit of dependency versioning, potentially containing many packages.
- `go.mod`/`go.sum` are small text files meant to be committed, unlike the actual downloaded dependency code.

## Key Terms

- **Package** — Go's directory-based unit of code organization.
- **Module** — Go's unit of dependency versioning and distribution, declared in `go.mod`, potentially containing multiple packages.
- **Exported identifier** — a capitalized name, visible outside its declaring package; lowercase names are package-private.

## Interview Questions

1. **How does Go control visibility (public vs. private), compared to Java/C#'s access modifier keywords?**
   Purely through capitalization — no keywords at all. A capitalized function/type/field/constant name is exported (visible to any package that imports it); a lowercase name is package-private, visible only within its own package. This is simpler than Java's `public`/`private`/`protected`/package-private four-way distinction or C#'s similar modifier set.

2. **What's the difference between a Go package and a Go module?**
   A package is Go's basic code-organization unit, corresponding to a single directory of `.go` files sharing a `package` declaration. A module is a versioned collection of packages, declared by a `go.mod` file at the module's root, which also declares the module's own import path and its external dependencies' versions — one module commonly contains many packages (subdirectories), similar to how one Maven/npm package can export multiple internal modules/namespaces.

## Recommended Next Lesson

[16 — Database Access](../16-Database-Access/README.md)
