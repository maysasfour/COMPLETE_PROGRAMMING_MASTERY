// Example.kt - top-level functions (no class wrapper needed, unlike Java), semicolons
// optional, string templates, and val/var.

// Single-line comment.
/* Multi-line
   comment. */

fun main() { // top-level function -- Kotlin has NO Java-style "everything must be in a class" rule
    val name = "World"       // val = read-only reference (like Java's `final`, but the DEFAULT idiom)
    var count = 0               // var = reassignable

    println("Hello, $name!")   // string template: $var interpolates directly, no concatenation needed
    println("count + 1 = ${count + 1}") // ${...} for expressions inside a string template

    count = 1 // semicolons are optional at the end of a line -- Kotlin infers statement boundaries
    println("count is now $count")

    // Kotlin distinguishes val (cannot be reassigned) from var (can be) at the language level --
    // there's no separate `const` keyword needed for this distinction the way some languages have.
    // val name = "reassigned" // would be a COMPILE ERROR: val cannot be reassigned
}
