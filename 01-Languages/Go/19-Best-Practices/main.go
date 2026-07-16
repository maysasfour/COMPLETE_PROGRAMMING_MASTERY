// main.go - a "before" (ignored error, unsynchronized goroutine) vs "after" (checked error,
// synchronized goroutine) contrast.
package main

import (
	"errors"
	"fmt"
	"sync"
)

func riskyParse(s string) (int, error) {
	if s == "" {
		return 0, errors.New("empty input")
	}
	return len(s), nil
}

func main() {
	fmt.Println("=== BEFORE: ignoring a returned error ===")
	badResult, _ := riskyParse("") // BUG: error silently discarded
	fmt.Println("badResult (should have been checked!):", badResult)

	fmt.Println("\n=== AFTER: always checking the error ===")
	goodResult, err := riskyParse("")
	if err != nil {
		fmt.Println("Correctly caught:", err)
	} else {
		fmt.Println("goodResult:", goodResult)
	}

	fmt.Println("\n=== BEFORE: launching goroutines with no synchronization ===")
	counterBad := 0
	for i := 0; i < 1000; i++ {
		go func() { counterBad++ }() // BUG: data race, and main may exit before goroutines finish
	}
	fmt.Println("counterBad (unreliable, likely wrong):", counterBad, "<- read immediately, goroutines may not have run yet")

	fmt.Println("\n=== AFTER: sync.WaitGroup + sync.Mutex for correct synchronization ===")
	var wg sync.WaitGroup
	var mu sync.Mutex
	counterGood := 0
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
	fmt.Println("counterGood (correct, always 1000):", counterGood)
}
