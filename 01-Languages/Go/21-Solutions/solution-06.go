// solution-06.go - Exercise 06: concurrent "fetches" using goroutines, a buffered channel,
// and a WaitGroup -- Go's alternative to threads or async/await.
package main

import (
	"fmt"
	"sync"
	"time"
)

// fetch runs inside its own goroutine. results is a send-only channel type (chan<- string)
// from fetch's point of view -- the compiler stops it from ever reading its own results channel.
func fetch(url string, delay time.Duration, shouldFail bool, results chan<- string, wg *sync.WaitGroup) {
	defer wg.Done() // guarantees Done() fires even if this goroutine were to panic
	time.Sleep(delay)
	if shouldFail {
		results <- fmt.Sprintf("%s -> FAILED: simulated error", url)
		return
	}
	results <- fmt.Sprintf("%s -> 200 OK", url)
}

func main() {
	type job struct {
		url        string
		delay      time.Duration
		shouldFail bool
	}
	jobs := []job{
		{"https://api.example.com/users", 300 * time.Millisecond, false},
		{"https://api.example.com/orders", 500 * time.Millisecond, false},
		{"https://api.example.com/broken", 200 * time.Millisecond, true},
		{"https://api.example.com/products", 400 * time.Millisecond, false},
	}

	var wg sync.WaitGroup
	// Buffered to the exact number of sends expected -- a send never blocks waiting for a
	// receiver, which matters here because nothing reads from results until after wg.Wait().
	results := make(chan string, len(jobs))

	start := time.Now()
	for _, j := range jobs {
		wg.Add(1)
		go fetch(j.url, j.delay, j.shouldFail, results, &wg)
	}

	// Closing must happen only after every goroutine has called Done() -- closing early would
	// risk a "send on closed channel" panic from a goroutine still in flight. Doing the Wait()
	// in its own goroutine lets main start ranging over results immediately instead of blocking
	// twice in sequence.
	go func() {
		wg.Wait()
		close(results)
	}()

	for r := range results { // ranging over a channel stops automatically once it's closed and drained
		fmt.Println(r)
	}

	elapsed := time.Since(start)
	fmt.Printf("\ntotal elapsed: %s (close to the slowest single delay of 500ms, not the ~1400ms sum of all four)\n", elapsed.Round(time.Millisecond))
}
