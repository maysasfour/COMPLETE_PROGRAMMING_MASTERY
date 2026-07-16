// mathutils.go - a package in its own directory, imported by main.go via the module path.
package mathutils

// Add is exported (capitalized) -- visible to importers. A lowercase name would be package-private.
func Add(a, b int) int {
	return a + b
}

func Multiply(a, b int) int {
	return a * b
}
