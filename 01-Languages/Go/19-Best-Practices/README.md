# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Apply a consistent, defensible Go style across error handling and concurrency.
- Recognize and avoid the specific footguns covered throughout lessons 01–18, collected here as one reference.

## Prerequisites

All of lessons 01–18 — this lesson is a synthesis, not new material.

## The Central Recurring Theme: Never Ignore an `error`

```go
badResult, _ := riskyParse("") // BUG: the error is silently discarded with `_`
```

Go allows this syntactically — there's no compiler enforcement requiring you to check a returned `error`, unlike Java's checked exceptions. This is the single most consequential Go-specific discipline: **always check every returned error immediately**, and use a linter (like `errcheck`) in CI to catch the ones a reviewer might miss.

## The Second Recurring Theme: Goroutines Need Explicit Synchronization

```go
// BUG: no synchronization at all
for i := 0; i < 1000; i++ {
	go func() { counterBad++ }() // a genuine data race, AND main might read counterBad before they finish
}
fmt.Println(counterBad) // unreliable -- often NOT 1000, since goroutines may still be running
```

```go
// CORRECT: sync.WaitGroup ensures completion, sync.Mutex protects the shared counter
var wg sync.WaitGroup
var mu sync.Mutex
for i := 0; i < 1000; i++ {
	wg.Add(1)
	go func() {
		defer wg.Done()
		mu.Lock()
		counterGood++
		mu.Unlock()
	}()
}
wg.Wait()
fmt.Println(counterGood) // reliably 1000
```

Go makes launching concurrent work trivially easy (`go func(){}()`) — this is both the language's greatest strength and its most common source of subtle bugs when the corresponding synchronization (a channel, a `WaitGroup`, a `Mutex`) is forgotten.

## Detailed Example

See [main.go](main.go) — a direct "before" (ignored error, unsynchronized goroutines) versus "after" (checked error, `WaitGroup`+`Mutex`) contrast, both run so the difference is demonstrated concretely: the "before" goroutine example genuinely reproduces the race/timing bug (reading the counter before all goroutines finish), not just a description of what could theoretically go wrong.

## Expected Output

Running the example prints the "before" version silently discarding an error and reading an unsynchronized counter far too early (often under 1000, confirming the real race), then the "after" version correctly catching the error and reliably printing exactly 1000 after properly waiting for all goroutines via `sync.WaitGroup`.

## Common Mistakes

All of Lessons 01–18's "Common Mistakes" apply collectively, with two Go-specific themes standing out above the rest: silently ignored `error` returns, and goroutines launched without corresponding synchronization (a channel handoff, a `WaitGroup`, or protection via `sync.Mutex` for shared state).

## Best Practices (Meta)

- Check every returned `error` immediately; consider `errcheck` (a linter) in CI to catch ones a reviewer might miss, since the compiler itself won't.
- Always pair a launched goroutine with a way to observe its completion (a channel receive, `WaitGroup.Wait()`), or explicitly document an intentional fire-and-forget.
- Run `go vet` and `go run -race` (the built-in race detector) regularly — the race detector specifically catches unsynchronized concurrent access to shared state that this lesson's "before" example demonstrates.
- Write table-driven tests (Lesson 18) for behavior that matters — the compiler cannot catch a wrong formula, only a test can.

## Real-World Usage

`go vet`, `golangci-lint` (bundling `errcheck` and many other checks), and `go test -race` are standard parts of any serious Go project's CI pipeline, specifically because the language's permissiveness around ignored errors and its ease of launching unsynchronized goroutines are its two most common real-world bug sources.

## Summary

- This lesson has no new syntax — it's a checklist synthesizing lessons 01–18's individual practices, centered on Go's two most distinctive recurring themes: the discipline of never ignoring an `error`, and always pairing a launched goroutine with proper synchronization.
- Both were demonstrated as genuinely reproduced bugs (a silently-lost error, a real race condition's timing failure), not just described in the abstract.

## Key Terms

- **`errcheck`** — a popular Go linter specifically checking for ignored error return values.
- **Race detector (`go test -race`, `go run -race`)** — Go's built-in tool for detecting unsynchronized concurrent access to shared memory at runtime.

## Interview Questions

1. **Why is ignoring a Go error return considered a serious problem, given the language allows it syntactically?**
   Since Go has no exceptions and no compiler-enforced "must handle" requirement (unlike Java's checked exceptions), an ignored error is simply and silently dropped — the failure it represents vanishes with no trace, often causing a confusing downstream symptom far from the actual root cause. This is why linters like `errcheck` exist: to catch, at review/CI time, what the compiler itself deliberately doesn't enforce.

2. **What real bug does launching goroutines without synchronization risk, and how do you fix it?**
   Two distinct risks: a data race (multiple goroutines mutating shared state concurrently with no protection, given undefined/incorrect results) and main exiting before spawned goroutines finish their work (silently dropping it). The fix is to always pair goroutines with explicit synchronization: a `sync.WaitGroup` to wait for completion, and a `sync.Mutex` (or channel-based communication instead of shared memory) to protect any concurrently-accessed shared state.

## Recommended Next Lesson

This completes the core Go course (lessons 01–19), matching the depth of Python, JavaScript, TypeScript, C#, Java, and C++. Lessons 20–22 (Exercises, Solutions, Mini-Projects as standalone folders) are not yet built — see [BUILD_STATUS.md](../../../BUILD_STATUS.md). From here, continue to [Rust](../../Rust/README.md) (per this repository's specified language order).
