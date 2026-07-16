# 05 — Control Flow

[Back to course overview](../README.md) | [Previous: Operators](../04-Operators/README.md)

## Learning Objectives

- Use `if`/`else` and `switch`.
- Use Go's **single loop keyword**, `for` — there is no separate `while`/`do-while`.
- Use `range` for iterating collections.

## Prerequisites

[04-Operators](../04-Operators/README.md)

## Concept

Go has exactly **one** loop keyword, `for`, used in several forms covering everything C-family languages split across `for`/`while`/`do-while` — another deliberate "one obvious way" simplicity choice. `switch` in Go does **not** fall through by default (the opposite of C/JavaScript/C++) — each case automatically breaks, and explicit `fallthrough` is needed to opt into the C-style behavior.

## `if`/`else` and `switch`

```go
temperature := 20
if temperature > 30 {
	fmt.Println("hot")
} else if temperature > 15 {
	fmt.Println("warm")
} else {
	fmt.Println("cool")
}

switch temperature {
case 30:
	fmt.Println("exactly 30")
default:
	fmt.Println("not exactly 30")
	// no break needed -- Go's switch does NOT fall through by default
}
```

## `for`: Go's Only Loop Keyword

```go
for i := 0; i < 3; i++ { // classic three-part form
	fmt.Println(i)
}

count := 0
for count < 3 { // "while" form -- same `for` keyword, just the condition
	fmt.Println(count)
	count++
}

for { // "infinite loop" form -- equivalent to C's while(true)
	break // must break explicitly to exit
}
```

## `range` for Iteration

```go
numbers := []int{1, 2, 3}
for index, value := range numbers { // like enumerate() -- index AND value
	fmt.Println(index, value)
}

for _, value := range numbers { // `_` discards the index when only the value is needed
	fmt.Println(value)
}
```

## Detailed Example

See [main.go](main.go).

## Expected Output

Running `go run main.go` prints `if`/`switch` results (confirming no fall-through), all three `for` forms, and `range`-based iteration with and without the index.

## Common Mistakes

- Expecting `switch` to fall through by default (as in C/JavaScript) — Go's `switch` breaks automatically after each case; use the explicit `fallthrough` keyword if C-style behavior is genuinely needed.
- Looking for a `while` or `do-while` keyword — Go has neither; both are expressed with `for` in different forms.
- Using `range` without `_` for an unused index, triggering an "unused variable" compile error.

## Best Practices

- Use `for range` for iterating slices/maps/strings/channels rather than manual indexing.
- Use `_` to explicitly discard a `range` value you don't need, rather than declaring an unused variable.

## Real-World Usage

Go's single unified `for` keyword and non-fall-through `switch` are frequently cited examples of the language's "there should be exactly one way to do it" design philosophy, reducing the number of loop/branch constructs a Go developer needs to learn compared to most other languages.

## Summary

- `for` is Go's only loop keyword, covering the classic three-part form, the "while" form, and the infinite-loop form.
- `switch` does not fall through by default — the opposite of C/JavaScript/C++'s convention.
- `range` iterates slices/maps/strings/channels, yielding index+value (or key+value) pairs.

## Key Terms

- **`range`** — Go's keyword for iterating over a slice, map, string, or channel, yielding index/key and value.
- **`fallthrough`** — the explicit keyword needed to opt into C-style switch fall-through, since Go's default is to break automatically.

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **How many loop keywords does Go have, and how does it cover `while`/`do-while`-style loops?**
   Exactly one: `for`. A `while`-style loop is just `for condition { ... }` (omitting the init/post clauses); an infinite loop is `for { ... }` with an explicit `break` inside. There is no separate `while` or `do-while` keyword — this is a deliberate simplicity choice.

2. **Does Go's `switch` fall through to the next case by default?**
   No — this is the opposite of C, C++, and JavaScript. Each Go `switch` case automatically breaks after its body runs; explicit fall-through into the next case requires the `fallthrough` keyword, making Go's default behavior the safer, less error-prone one (accidental fall-through is a classic C-family bug Go's default avoids).

## Recommended Next Lesson

[06 — Functions](../06-Functions/README.md)
