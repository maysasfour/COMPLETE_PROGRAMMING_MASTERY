// main.go - goroutines, channels, sync.WaitGroup (with real timing), select.
package main

import (
	"fmt"
	"sync"
	"time"
)

func worker(id int, results chan<- string) {
	results <- fmt.Sprintf("worker %d done", id)
}

func slowCompute(ms int, value int, results chan<- int) {
	time.Sleep(time.Duration(ms) * time.Millisecond)
	results <- value
}

func main() {
	fmt.Println("--- basic goroutine and channel ---")
	results := make(chan string)
	go worker(1, results)
	message := <-results
	fmt.Println(message)

	fmt.Println("\n--- sync.WaitGroup waiting for multiple goroutines ---")
	var wg sync.WaitGroup
	for i := 1; i <= 3; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			fmt.Println("worker", id, "done (WaitGroup)")
		}(i)
	}
	wg.Wait()
	fmt.Println("All goroutines finished.")

	fmt.Println("\n--- sequential vs concurrent goroutines (real timing) ---")
	start1 := time.Now()
	seqResults := make(chan int, 3)
	slowCompute(80, 1, seqResults)
	slowCompute(80, 2, seqResults)
	slowCompute(80, 3, seqResults)
	fmt.Println("Sequential 3x80ms calls took ~", time.Since(start1).Milliseconds(), "ms")

	start2 := time.Now()
	concResults := make(chan int, 3)
	go slowCompute(80, 1, concResults)
	go slowCompute(80, 2, concResults)
	go slowCompute(80, 3, concResults)
	total := 0
	for i := 0; i < 3; i++ {
		total += <-concResults
	}
	fmt.Println("Concurrent goroutines of the same 3x80ms tasks took ~", time.Since(start2).Milliseconds(), "ms, total=", total)

	fmt.Println("\n--- select: whichever channel is ready first ---")
	channelA := make(chan string)
	channelB := make(chan string)
	go func() {
		time.Sleep(30 * time.Millisecond)
		channelA <- "from A"
	}()
	go func() {
		time.Sleep(60 * time.Millisecond)
		channelB <- "from B"
	}()
	select {
	case msg := <-channelA:
		fmt.Println("select got:", msg)
	case msg := <-channelB:
		fmt.Println("select got:", msg)
	}
}
