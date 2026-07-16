# 10 — File Handling

[Back to course overview](../README.md) | [Previous: Error Handling](../09-Error-Handling/README.md)

## Learning Objectives

- Read and write text files with the `os` package.
- Use the built-in `encoding/json` package — unlike Java/C++, Go has genuine built-in JSON support.
- Handle a missing file with the `(value, error)` pattern from Lesson 09.

## Prerequisites

[09-Error-Handling](../09-Error-Handling/README.md)

## Concept

`os.ReadFile`/`os.WriteFile` provide simple whole-file operations. Unlike Java and C++ (both of which have zero built-in JSON support), Go's standard library includes `encoding/json` — a genuine, first-class built-in JSON encoder/decoder, closer to Python/Node/C#'s built-in JSON handling than to Java/C++'s "bring your own library" gap.

## Reading and Writing Text Files

```go
import "os"

err := os.WriteFile("notes.txt", []byte("Hello, file system!\n"), 0644)
contents, err := os.ReadFile("notes.txt") // returns []byte, error -- the Lesson 09 pattern
fmt.Println(string(contents))
```

## `encoding/json`: Built-In, Unlike Java/C++

```go
import "encoding/json"

type Config struct {
	Theme    string `json:"theme"`    // struct tags map field names to JSON keys
	FontSize int    `json:"fontSize"`
}

config := Config{Theme: "dark", FontSize: 14}
data, err := json.Marshal(config) // struct -> JSON bytes

var loaded Config
err = json.Unmarshal(data, &loaded) // JSON bytes -> struct, note the pointer
```

Struct tags (`` `json:"theme"` ``) map Go's `PascalCase` field naming convention onto whatever JSON key naming the data actually uses (commonly `camelCase`) — `json.Unmarshal` requires a **pointer** to the destination so it can actually populate it, following the same "must pass something mutable" logic as any function meant to fill in a caller's variable.

## Handling a Missing File

```go
_, err := os.ReadFile("does-not-exist.txt")
if os.IsNotExist(err) {
	fmt.Println("File doesn't exist -- using defaults")
}
```

## Detailed Example

See [main.go](main.go) — writes and reads a text file, marshals/unmarshals a struct to/from JSON, and handles a genuinely missing file.

## Expected Output

Running `go run main.go` prints round-tripped text content, a struct correctly round-tripped through `json.Marshal`/`Unmarshal`, and confirmation that a missing file is detected via `os.IsNotExist(err)`.

## Common Mistakes

- Forgetting `json.Unmarshal` needs a **pointer** to the destination (`&loaded`, not `loaded`) — without it, there's nothing for the function to actually populate.
- Forgetting struct tags when the JSON's key naming doesn't match Go's exported-field `PascalCase` convention — without a matching tag, `json.Unmarshal` silently leaves that field at its zero value instead of erroring.
- Not checking the `error` from `os.ReadFile`/`os.WriteFile`/`json.Unmarshal` — same Lesson 09 discipline applies to every fallible call here too.

## Best Practices

- Always use struct tags to make JSON field mapping explicit and independent of Go's own naming convention.
- Check `os.IsNotExist(err)` specifically when a missing file is an expected, recoverable case, rather than treating every `os.ReadFile` error identically.

## Real-World Usage

`encoding/json` is used pervasively throughout Go web services (encoding/decoding HTTP request/response bodies, Lesson 17) precisely because it's built into the standard library with zero external dependency, unlike Java's Jackson or C++'s nlohmann/json.

## Summary

- `os.ReadFile`/`os.WriteFile` provide simple whole-file text I/O, following the `(value, error)` pattern.
- `encoding/json` is genuinely built into Go's standard library — a real advantage over Java/C++'s "bring your own JSON library" gap.
- Struct tags map Go's `PascalCase` fields onto arbitrary JSON key naming; `json.Unmarshal` requires a pointer to its destination.

## Key Terms

- **Struct tag** — metadata attached to a struct field (like `` `json:"theme"` ``) controlling how packages like `encoding/json` treat it.
- **`encoding/json`** — Go's built-in JSON encoding/decoding package.

## Interview Questions

1. **Does Go's standard library include JSON support, unlike Java and C++?**
   Yes — `encoding/json` is a genuine, built-in package providing `Marshal`/`Unmarshal` for converting between Go structs and JSON, with no external dependency needed, closer to Python/Node/C#'s built-in JSON handling than to Java's (needs Jackson) or C++'s (needs nlohmann/json or similar) standard-library gap.

2. **Why does `json.Unmarshal` take a pointer to its destination, rather than returning the decoded value directly?**
   Because it needs to actually populate an existing variable's memory in place — passing a pointer (`&loaded`) gives `Unmarshal` a way to write into the caller's variable directly, exactly the same reasoning as any Go function meant to modify a caller's value (Lesson 04's `*ptr = value` pattern). Returning the decoded value directly would also be technically possible via an `interface{}`/`any` return, but would lose the caller's specific target type.

## Recommended Next Lesson

[11 — OOP](../11-OOP/README.md)
