# Go

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Go Is

Go (often "Golang") is a statically-typed, compiled, garbage-collected language created at Google, designed explicitly for simplicity, fast compilation, and built-in concurrency. It deliberately omits features common to most other languages in this repository — no classes/inheritance, no exceptions, no generics until 2022 (Go 1.18) — in favor of a small, opinionated language surface: structs + interfaces for composition, explicit `(value, error)` returns instead of exceptions, and goroutines/channels as first-class concurrency primitives.

## Why / Where It's Used

- **Cloud-native infrastructure** — Docker, Kubernetes, Terraform, and most of the modern cloud-native tooling ecosystem are written in Go.
- **Backend microservices** — Go's fast startup, low memory footprint, and built-in concurrency make it a common choice for high-throughput network services.
- **CLI tools** — Go compiles to a single, dependency-free static binary, making it popular for distributing command-line tools.
- **Networking/systems software** — a natural fit given Go's design origins at Google, addressing the pain points of C++ build times and complexity at scale.

## Advantages

- Extremely fast compilation, even for large codebases — a core, deliberate design goal.
- Goroutines and channels make concurrent code easier to write correctly than manual thread/lock management.
- A single static binary output with no runtime dependency to install — simple deployment.
- A deliberately small language surface — famously, the entire Go language spec is short enough to read in an afternoon, and `gofmt` eliminates almost all style debates by auto-formatting code identically everywhere.

## Disadvantages

- No exceptions — explicit `if err != nil` checks after nearly every fallible call are the norm, which some find repetitive compared to `try`/`catch`.
- No classes/inheritance — developers coming from OOP-heavy languages (Java, C#) need to relearn composition-and-interfaces as the primary code-reuse mechanism (Lesson 11).
- Generics only since 2022 (Go 1.18) — many older libraries and idioms predate them and don't use them.
- A deliberately minimal standard library philosophy sometimes means writing more code by hand than an equivalent Python/JavaScript solution would need.

## How to Install

```bash
# Download from https://go.dev/dl/
go version
```

This course was written and verified against **Go 1.23**, but everything in it works on Go 1.21+ unless a lesson says otherwise (generics, Lesson 13, specifically need Go 1.18+).

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `main.go`. From the repository root:

```bash
cd 01-Languages/Go/03-Variables-and-Data-Types
go run main.go
```

`go run` compiles and runs in one step, with no separate build artifact left behind — similar in spirit to the file-based/single-file execution modes used throughout this repository's other language courses.

## Common Beginner Mistakes

- **Ignoring a returned `error`** — Go has no exceptions; forgetting to check `if err != nil` after a fallible call means a failure is silently ignored, often causing a confusing failure much later (Lesson 09).
- **Expecting inheritance** — Go has no `class`/`extends`; struct embedding and interfaces (Lesson 11) are the idiomatic replacements, and require a different design mindset than Java/C#'s class hierarchies.
- **Forgetting goroutine synchronization** — launching a goroutine with `go func(){...}()` and not waiting for it (`sync.WaitGroup`) or communicating its result (a channel) means `main` can exit before the goroutine finishes, silently dropping its work (Lesson 14).
- **Shadowing `:=`** — using `:=` (short variable declaration) inside a new scope (like an `if` block) creates a *new* variable shadowing an outer one of the same name, rather than reassigning it — a subtle, easy-to-miss bug.

## Best Practices

- Always check every returned `error` immediately after the call that might produce it.
- Prefer small, focused interfaces (Go's standard library favors single-method interfaces like `io.Reader`) over large ones.
- Run `gofmt` (or `go fmt`) on every file — it's the near-universal formatting standard, with essentially zero configuration debate in the Go community.
- Prefer composition (embedding a struct/interface) over trying to simulate inheritance.

## Interview Questions

1. **How does Go handle errors, given it has no exceptions?**
   Functions that can fail return an additional `error` value alongside their normal return value(s) — by convention, the last return value. Callers are expected to check `if err != nil` immediately after every such call; there's no automatic propagation the way an uncaught exception unwinds a call stack, so an ignored error is silently dropped rather than causing an obvious crash.

2. **How does Go achieve code reuse without classes or inheritance?**
   Through struct embedding (a struct can embed another struct or interface, promoting its fields/methods) and interfaces (a implicit, structural contract — any type with the right methods automatically satisfies an interface, with no explicit `implements` declaration needed). This is closer to composition and duck typing than classical inheritance.

3. **What are goroutines and channels?**
   A goroutine is an extremely lightweight, Go-runtime-managed concurrent function invocation (`go someFunc()`) — far cheaper than an OS thread, with the Go runtime multiplexing many goroutines onto a small number of OS threads. A channel (`chan T`) is a typed pipe for goroutines to communicate and synchronize, embodying Go's design philosophy: "don't communicate by sharing memory; share memory by communicating."

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Installing Go, `go run`, project structure |
| 02 | [Syntax](02-Syntax/README.md) | Packages, `func main()`, `gofmt`, comments |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | `var`/`:=`, zero values, basic types |
| 04 | [Operators](04-Operators/README.md) | Arithmetic/comparison/logical, no operator overloading |
| 05 | [Control Flow](05-Control-Flow/README.md) | if/switch, Go's single loop keyword (`for`) |
| 06 | [Functions](06-Functions/README.md) | Multiple return values, named returns, variadic parameters |
| 07 | [Collections](07-Collections/README.md) | Arrays, slices, maps |
| 08 | [Strings](08-Strings/README.md) | Strings as immutable byte sequences, runes, `strings`/`strconv` |
| 09 | [Error Handling](09-Error-Handling/README.md) | `(value, error)` returns, `errors.New`, `panic`/`recover` |
| 10 | [File Handling](10-File-Handling/README.md) | `os`/`io`, built-in `encoding/json` |
| 11 | [OOP](11-OOP/README.md) | Structs, methods, interfaces, embedding (no classes/inheritance) |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | First-class functions, closures |
| 13 | [Generics](13-Generics/README.md) | Type parameters (Go 1.18+), constraints |
| 14 | [Async and Concurrency](14-Async-and-Concurrency/README.md) | Goroutines, channels, `select`, `sync.WaitGroup` |
| 15 | [Modules and Packages](15-Modules-and-Packages/README.md) | `go.mod`, packages, `go get` |
| 16 | [Database Access](16-Database-Access/README.md) | `database/sql` with SQLite, parameterized queries |
| 17 | [API Integration](17-API-Integration/README.md) | Built-in `net/http` client |
| 18 | [Testing](18-Testing/README.md) | Built-in `testing` package, table-driven tests |
| 19 | [Best Practices](19-Best-Practices/README.md) | Synthesis checklist across lessons 01–18 |
| 20-22 | Exercises / Solutions / Mini-Projects | *not yet built as standalone folders — see per-lesson Exercises/Solutions on 05-07* |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order. Lessons 05, 06, and 07 have `Exercises/`/`Solutions/` pairs.

**Previous language:** [C++](../Cpp/README.md) | **Next:** [Rust](../Rust/README.md)
