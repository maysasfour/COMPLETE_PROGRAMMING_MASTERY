// Example.kt - if/else as an EXPRESSION (not just a statement), when (Kotlin's switch --
// exhaustive, no fall-through, an expression too), and loops.

sealed class Shape
data class Circle(val radius: Double) : Shape()
data class Rectangle(val width: Double, val height: Double) : Shape()

fun main() {
    println("--- if/else as an EXPRESSION -- produces a value directly ---")
    val score = 85
    val grade = if (score >= 90) "A" else if (score >= 80) "B" else "C or below"
    println("grade: $grade")

    println("\n--- when: Kotlin's switch, but exhaustive, no fall-through, and an expression ---")
    val day = 3
    val dayType = when (day) {
        1, 2, 3, 4, 5 -> "Weekday" // no break needed -- no fall-through at all, unlike Java's switch
        6, 7 -> "Weekend"
        else -> "Invalid day" // else required for exhaustiveness UNLESS the compiler can prove otherwise
    }
    println("dayType: $dayType")

    println("\n--- when with ranges and arbitrary conditions (not just equality) ---")
    val temp = 75
    val description = when {
        temp < 32 -> "freezing"
        temp in 32..60 -> "cold"
        temp in 61..80 -> "mild"
        else -> "hot"
    }
    println("description: $description")

    println("\n--- when with sealed classes: EXHAUSTIVE, compiler-verified (like Rust's match) ---")
    fun area(shape: Shape): Double = when (shape) {
        is Circle -> Math.PI * shape.radius * shape.radius // smart-cast: shape is treated as Circle here
        is Rectangle -> shape.width * shape.height
        // no `else` needed -- the compiler KNOWS these are the only two Shape subtypes,
        // since Shape is `sealed`, and would ERROR if a new subtype were added without updating this `when`
    }
    println("circle area: ${area(Circle(2.0))}")
    println("rectangle area: ${area(Rectangle(3.0, 4.0))}")

    println("\n--- Loops ---")
    for (i in 0..2) println("for: $i")
    var i = 0
    while (i < 3) { println("while: $i"); i++ }
    val letters = listOf("a", "b", "c")
    for ((index, letter) in letters.withIndex()) println("indexed: $index -> $letter")
}
