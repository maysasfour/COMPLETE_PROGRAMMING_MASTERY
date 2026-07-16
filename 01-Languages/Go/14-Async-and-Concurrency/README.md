# 14 — Async and Concurrency

[Back to course overview](../README.md) | [Previous: Generics](../13-Generics/README.md)

## Learning Objectives

- Launch goroutines with `go` — Go's signature concurrency feature.
- Use channels (`chan`) for goroutine communication and synchronization.
- Use `sync.WaitGroup` to wait for multiple goroutines, and `select` for multi-channel operations.

## Prerequisites

[13-Generics](../13-Generics/README.md)

## Concept

Concurrency is Go's most distinctive, most heavily marketed feature. A **goroutine** (`go someFunc()`) is an extremely lightweight, Go-runtime-managed concurrent function invocation — far cheaper than an OS thread (you can have hundreds of thousands of goroutines; the runtime multiplexes them onto a small number of OS threads automatically). A **channel** (`chan T`) is a typed pipe goroutines use to communicate, embodying Go's famous design philosophy: **"Don't communicate by sharing memory; share memory by communicating."**

## Goroutines and Channels

```go
func worker(id int, results chan<- string) { // chan<- : send-only channel (as a parameter type)
	results <- fmt.Sprintf("worker %d done", id) // send a value into the channel
}

results := make(chan string) // unbuffered channel
go worker(1, results)          // launches worker(1, results) concurrently
message := <-results            // receive -- BLOCKS until a value is sent
fmt.Println(message)
```

Sending/receiving on an **unbuffered** channel blocks until both sides are ready — this is what makes a plain channel operation act as a synchronization point, not just a data pipe.

## `sync.WaitGroup`: Waiting for Multiple Goroutines

```go
var wg sync.WaitGroup
for i := 1; i <= 3; i++ {
	wg.Add(1)          // increment the counter BEFORE launching the goroutine
	go func(id int) {
		defer wg.Done() // decrement when this goroutine finishes
		fmt.Println("worker", id, "done")
	}(i)
}
wg.Wait() // blocks until the counter reaches zero -- i.e., all goroutines have called Done()
```

## `select`: Waiting on Multiple Channels

```go
select {
case msg1 := <-channel1:
	fmt.Println("from channel1:", msg1)
case msg2 := <-channel2:
	fmt.Println("from channel2:", msg2)
case <-time.After(1 * time.Second):
	fmt.Println("timeout")
}
```

`select` waits on multiple channel operations simultaneously, proceeding with whichever is ready first — Go's mechanism for the "wait for whichever of several things happens first" pattern (conceptually related to `Promise.race`/similar from other language courses, though channels and goroutines are a fundamentally different concurrency model, not just a different syntax for the same one).

## Detailed Example

See [main.go](main.go) — includes real elapsed-time measurement demonstrating goroutines running concurrently.

## Expected Output

Running `go run main.go` prints a basic goroutine-and-channel handoff, `sync.WaitGroup` correctly waiting for three concurrent goroutines, real timing showing concurrent goroutines completing faster than sequential calls, and a `select` picking whichever channel becomes ready first.

## Common Mistakes

- Launching a goroutine and not waiting for it (no channel receive, no `WaitGroup`) — `main` can exit before the goroutine finishes, silently dropping its work with no error or warning.
- Forgetting `wg.Add(1)` must happen **before** launching the goroutine (not inside it) — otherwise there's a race between the `Add` and the main goroutine's `Wait()` call.
- Accessing shared mutable state from multiple goroutines without a `sync.Mutex` or channel-based synchronization — a data race, which Go's built-in race detector (`go run -race`) can catch but the language itself doesn't prevent statically.

## Best Practices

- Always ensure every launched goroutine's completion is observed somehow (a channel receive, a `WaitGroup`), or explicitly document why "fire and forget" is intentional.
- Call `wg.Add(1)` before the `go` statement that launches the corresponding goroutine.
- Prefer channels for communicating results between goroutines; use `sync.Mutex` for simple shared-counter-style state that doesn't naturally fit a channel's message-passing model.

## Real-World Usage

Goroutines and channels are used pervasively in Go's networking/server code — a typical Go HTTP server handles each incoming request in its own goroutine automatically, and channels are commonly used for worker-pool patterns (a fixed number of goroutines pulling work items off a shared channel).

## Summary

- Goroutines (`go func()`) are extremely lightweight, runtime-managed concurrent function calls — much cheaper than OS threads.
- Channels (`chan T`) are typed pipes for goroutine communication and synchronization, embodying "share memory by communicating."
- `sync.WaitGroup` waits for multiple goroutines to finish; `select` waits on multiple channel operations, proceeding with whichever is ready first.

## Key Terms

- **Goroutine** — an extremely lightweight, Go-runtime-managed concurrent function invocation.
- **Channel (`chan T`)** — a typed pipe for goroutines to communicate and synchronize.
- **`sync.WaitGroup`** — a counter-based synchronization primitive for waiting on multiple goroutines to complete.

## Interview Questions

1. **What is a goroutine, and how does it differ from an OS thread?**
   A goroutine is an extremely lightweight, Go-runtime-managed unit of concurrent execution, launched with the `go` keyword. Unlike an OS thread (expensive to create, limited in practical number), a goroutine starts with a very small stack that grows as needed, and the Go runtime multiplexes potentially hundreds of thousands of goroutines onto a much smaller number of actual OS threads automatically — allowing far higher concurrency with far less overhead than a thread-per-task model.

2. **What does "don't communicate by sharing memory; share memory by communicating" mean, and how do channels embody it?**
   Rather than having multiple goroutines directly read/write the same shared variable (requiring careful locking to avoid data races), Go's idiomatic style passes data *between* goroutines via channels — one goroutine sends a value, another receives it, and ownership of that data conceptually transfers with the message. This channel-based message-passing model is Go's preferred alternative to (though not a total replacement for) traditional shared-memory-plus-locks concurrency.

## Recommended Next Lesson

[15 — Modules and Packages](../15-Modules-and-Packages/README.md)
