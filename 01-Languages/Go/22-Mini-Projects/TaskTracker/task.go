// task.go - the domain types. Plain structs and small enum-like types, not classes -- Go has
// no enum keyword, so Priority/Status are typed integers with a String() method, the idiomatic
// substitute (this also makes them satisfy fmt.Stringer for free in every Printf %v/%s call).
package main

import "fmt"

type Priority int

const (
	PriorityLow Priority = iota
	PriorityMedium
	PriorityHigh
)

func (p Priority) String() string {
	switch p {
	case PriorityLow:
		return "Low"
	case PriorityMedium:
		return "Medium"
	case PriorityHigh:
		return "High"
	default:
		return "Unknown"
	}
}

// ParsePriority turns user-facing CLI text into a Priority, following the same
// (value, error) pattern as everything else in this course rather than panicking on bad input.
func ParsePriority(s string) (Priority, error) {
	switch s {
	case "low":
		return PriorityLow, nil
	case "medium":
		return PriorityMedium, nil
	case "high":
		return PriorityHigh, nil
	default:
		return 0, fmt.Errorf("unknown priority %q (want low, medium, or high)", s)
	}
}

type Status int

const (
	StatusPending Status = iota
	StatusDone
)

func (s Status) String() string {
	if s == StatusDone {
		return "done"
	}
	return "pending"
}

func ParseStatus(s string) (Status, error) {
	switch s {
	case "pending":
		return StatusPending, nil
	case "done":
		return StatusDone, nil
	default:
		return 0, fmt.Errorf("unknown status %q (want pending or done)", s)
	}
}

// TaskItem is a plain data struct -- Go has no "record" keyword, but a struct with only
// exported fields and no mutating methods serves the same role here.
type TaskItem struct {
	ID        int64
	Title     string
	Priority  Priority
	Status    Status
	CreatedAt string
}

// TaskStats is a second, purpose-built struct rather than a generic map -- the compiler
// enforces exactly two named fields, unlike a map[string]int that would accept typos silently.
type TaskStats struct {
	Pending int
	Done    int
	Total   int
}
