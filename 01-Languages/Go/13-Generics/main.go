// main.go - generic functions, type constraints, generic types.
package main

import "fmt"

func First[T any](items []T) T {
	return items[0]
}

type Number interface {
	int | int64 | float64
}

func Sum[T Number](items []T) T {
	var total T
	for _, item := range items {
		total += item
	}
	return total
}

type Stack[T any] struct {
	items []T
}

func (s *Stack[T]) Push(item T) {
	s.items = append(s.items, item)
}

func (s *Stack[T]) Pop() T {
	n := len(s.items)
	item := s.items[n-1]
	s.items = s.items[:n-1]
	return item
}

func (s *Stack[T]) Len() int {
	return len(s.items)
}

func main() {
	fmt.Println("--- generic function with inference ---")
	fmt.Println(First([]int{1, 2, 3}))
	fmt.Println(First([]string{"a", "b"}))

	fmt.Println("\n--- constrained generic (Number) ---")
	fmt.Println("Sum of ints:", Sum([]int{1, 2, 3, 4}))
	fmt.Println("Sum of floats:", Sum([]float64{1.5, 2.5}))

	fmt.Println("\n--- generic type Stack[T] ---")
	numberStack := &Stack[int]{}
	numberStack.Push(1)
	numberStack.Push(2)
	numberStack.Push(3)
	fmt.Println("numberStack.Len():", numberStack.Len())
	fmt.Println("numberStack.Pop():", numberStack.Pop())

	stringStack := &Stack[string]{}
	stringStack.Push("a")
	stringStack.Push("b")
	fmt.Println("stringStack.Pop():", stringStack.Pop())
}
