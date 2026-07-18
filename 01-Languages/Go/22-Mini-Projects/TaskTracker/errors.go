// errors.go - a custom error type, following Lesson 09's pattern: struct types implementing
// the error interface carry structured data a caller can act on, not just a formatted string.
package main

import "fmt"

type TaskNotFoundError struct {
	ID int64
}

func (e *TaskNotFoundError) Error() string {
	return fmt.Sprintf("no task found with id %d", e.ID)
}
