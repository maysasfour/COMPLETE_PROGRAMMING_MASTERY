// Example.kt - arithmetic, ==/=== (structural vs referential equality -- the OPPOSITE
// convention from Java!), range operators, and operator overloading via `operator fun`.

import kotlin.math.pow

data class Point(val x: Int, val y: Int) {
    operator fun plus(other: Point): Point = Point(x + other.x, y + other.y) // operator overloading
}

fun main() {
    println("--- Arithmetic ---")
    println(2.0.pow(10.0)) // no ** operator -- a stdlib function (kotlin.math.pow) instead

    println("\n--- == is STRUCTURAL equality by default (opposite of Java's == !) ---")
    val a = "hello"
    val b = "hel" + "lo"
    println(a == b)   // true -- Kotlin's == calls .equals() automatically, like content comparison
    println(a === b) // referential equality (like Java's ==) -- may be true or false depending on interning

    data class Person(val name: String)
    val p1 = Person("Ada")
    val p2 = Person("Ada")
    println(p1 == p2)  // true -- data class auto-generates a structural equals()
    println(p1 === p2) // false -- two genuinely different object instances

    println("\n--- Ranges ---")
    for (i in 1..5) print("$i ")           // inclusive range
    println()
    for (i in 1 until 5) print("$i ")       // exclusive of the upper bound
    println()
    for (i in 5 downTo 1) print("$i ")       // descending
    println()
    for (i in 1..10 step 3) print("$i ")      // step
    println()

    println("\n--- Operator overloading via `operator fun` ---")
    val sum = Point(1, 2) + Point(3, 4) // calls Point.plus() -- overloaded +
    println("sum: $sum")

    println("\n--- Elvis + safe call combo (from Lesson 03) used as an operator-like idiom ---")
    val nullable: Int? = null
    println("default: ${nullable ?: 0}")
}
