# 01 — Setup

[Back to course overview](../README.md)

## Learning Objectives

- Install Go and verify it.
- Run a single Go file with `go run`.
- Understand Go compiles to a single static binary, no runtime/VM required.

## Prerequisites

None — entry point of the Go course.

## Concept

Go compiles directly to native machine code, statically linked into a single self-contained executable with no external runtime dependency (unlike the JVM/CLR courses, and unlike Python/JavaScript needing an interpreter installed on the target machine) — you can copy the compiled binary to another machine of the same OS/architecture and run it with nothing else installed. `go run file.go` compiles and runs in one step for quick iteration, without leaving a persistent binary behind; `go build` produces the actual distributable executable.

## Syntax

```go
// main.go
package main

import "fmt"

func main() {
	fmt.Println("Hello, Go")
}
```

```bash
go run main.go
```

Every executable Go program has a `package main` with a `func main()` — the mandatory entry point, directly analogous to Java/C#'s `Main`, but Go has no surrounding class requirement.

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints a greeting and the Go runtime version.

## Common Mistakes

- Forgetting `package main` — a file without it can't be `go run`/`go build` as an executable, only imported as a library package.
- Assuming Go needs a separately-installed runtime on the deployment machine — it doesn't; the compiled binary is fully self-contained.

## Best Practices

- Use `go run` for quick iteration during development; use `go build` to produce the actual binary you'd deploy.
- Run `gofmt`/`go fmt` on every file — nearly the entire Go community uses the same auto-formatting, eliminating style debates.

## Real-World Usage

Go's single-static-binary output is a major reason for its popularity in cloud-native tooling (Docker, Kubernetes) and CLI tools — distributing a Go program is as simple as copying one file, with no dependency installation step on the target machine.

## Summary

- Go compiles to a single, dependency-free static binary — no runtime/VM needed on the deployment machine.
- `func main()` inside `package main` is the mandatory entry point for an executable program.
- `go run` compiles and runs in one step; `go build` produces a persistent binary.

## Key Terms

- **Static binary** — a compiled executable with no external runtime dependency, directly runnable on a compatible OS/architecture.
- **`package main`** — the special package name marking a Go program as an executable (rather than an importable library).

## Interview Questions

1. **Does a compiled Go program need a separate runtime installed to run, like Java's JVM or .NET's CLR?**
   No — Go compiles directly to a native, statically-linked executable with no external runtime dependency. The compiled binary can be copied to and run on any compatible machine (same OS/architecture) with nothing else installed, unlike Java (needs a JVM) or .NET (needs the .NET runtime, unless self-contained-published).

2. **What's the difference between `go run` and `go build`?**
   `go run` compiles and immediately executes a program in one step, without leaving a persistent binary behind — convenient for quick iteration. `go build` compiles the program into a standalone executable file in the current directory, which is what you'd actually distribute/deploy.

## Recommended Next Lesson

[02 — Syntax](../02-Syntax/README.md)
