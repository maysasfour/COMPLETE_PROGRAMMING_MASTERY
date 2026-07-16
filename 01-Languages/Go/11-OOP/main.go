// main.go - structs+methods, implicit interface satisfaction, struct embedding.
package main

import "fmt"

type Animal struct {
	Name string
}

func (a Animal) Speak() string {
	return a.Name + " makes a sound"
}

type Speaker interface {
	Speak() string
}

func Announce(s Speaker) {
	fmt.Println(s.Speak())
}

type Dog struct {
	Animal
	Breed string
}

func main() {
	fmt.Println("--- struct with a method ---")
	rex := Animal{Name: "Rex"}
	fmt.Println(rex.Speak())

	fmt.Println("\n--- implicit interface satisfaction (no 'implements' keyword) ---")
	Announce(rex)

	fmt.Println("\n--- struct embedding: composition, not inheritance ---")
	d := Dog{Animal: Animal{Name: "Fido"}, Breed: "Labrador"}
	fmt.Println("d.Speak() (promoted from Animal):", d.Speak())
	fmt.Println("d.Name (promoted field):", d.Name)
	fmt.Println("d.Breed (Dog's own field):", d.Breed)
	Announce(d) // Dog ALSO satisfies Speaker, via the promoted method
}
