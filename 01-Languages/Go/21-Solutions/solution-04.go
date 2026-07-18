// solution-04.go - Exercise 04: structs, implicit interfaces, and embedding (not inheritance).
package main

import (
	"fmt"
	"math"
)

type Shape interface {
	Area() float64
	Perimeter() float64
}

// Describer is a second, narrower interface that both Circle and Rectangle also happen to
// satisfy (via the promoted Describe() method) -- Go interfaces are structural, so a type can
// satisfy any number of them without declaring so anywhere.
type Describer interface {
	Describe() string
}

// NamedShape has no idea Shape exists. Embedding it below is what promotes Describe() onto
// Circle/Rectangle -- there's no "extends" keyword, and NamedShape itself satisfies nothing.
type NamedShape struct {
	Name string
}

func (n NamedShape) Describe() string {
	return "This is a " + n.Name
}

type Circle struct {
	NamedShape // embedded, not a named field -- this is what promotes Describe()
	Radius     float64
}

func (c Circle) Area() float64      { return math.Pi * c.Radius * c.Radius }
func (c Circle) Perimeter() float64 { return 2 * math.Pi * c.Radius }

type Rectangle struct {
	NamedShape
	Width, Height float64
}

func (r Rectangle) Area() float64      { return r.Width * r.Height }
func (r Rectangle) Perimeter() float64 { return 2 * (r.Width + r.Height) }

func main() {
	shapes := []Shape{
		Circle{NamedShape: NamedShape{Name: "circle"}, Radius: 3},
		Rectangle{NamedShape: NamedShape{Name: "rectangle"}, Width: 4, Height: 6},
		Rectangle{NamedShape: NamedShape{Name: "rectangle"}, Width: 5, Height: 5}, // square-shaped
	}

	for _, shape := range shapes {
		// A type assertion against the Describer interface recovers Describe() -- promoted
		// straight through from the embedded NamedShape, with zero glue code written for it.
		desc := ""
		if describer, ok := shape.(Describer); ok {
			desc = describer.Describe()
		}
		fmt.Printf("%s | Area=%.2f Perimeter=%.2f\n", desc, shape.Area(), shape.Perimeter())

		// A type assertion recovers the concrete Rectangle from the Shape interface value --
		// this is how Go inspects "what specifically is this" when the interface alone isn't enough.
		if r, isRect := shape.(Rectangle); isRect && r.Width == r.Height {
			fmt.Println("  ...and it's a square")
		}
	}
}
