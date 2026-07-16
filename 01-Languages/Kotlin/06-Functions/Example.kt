// Example.kt - default/named parameters, single-expression functions, vararg, extension
// functions (a genuinely distinctive Kotlin feature), and higher-order functions/lambdas.

fun greet(name: String, greeting: String = "Hello"): String = "$greeting, $name!" // single-expression fn

fun sum(vararg numbers: Int): Int = numbers.sum() // vararg -- like Java's/PHP's variadic parameters

// Extension function: adds a method to an EXISTING type (String) without modifying its source
// or using inheritance -- resolved statically at compile time, not true runtime dispatch.
fun String.shout(): String = this.uppercase() + "!"

fun main() {
    println(greet("Ada"))
    println(greet("Grace", "Hi"))
    println(greet(name = "Linus", greeting = "Hey")) // named arguments, order-independent

    println("\n--- vararg ---")
    println(sum(1, 2, 3, 4)) // 10

    println("\n--- Extension function: called AS IF it were a method on String ---")
    println("hello".shout()) // HELLO!

    println("\n--- Higher-order functions and lambdas ---")
    val multiplier: (Int) -> Int = { x -> x * 3 } // lambda stored in a typed variable
    println(multiplier(5)) // 15

    fun applyTwice(x: Int, f: (Int) -> Int): Int = f(f(x)) // function taking a function parameter
    println(applyTwice(2) { it * 2 }) // trailing lambda syntax: 2 -> 4 -> 8

    println("\n--- it: implicit single-parameter name in a lambda ---")
    val doubled = listOf(1, 2, 3).map { it * 2 } // `it` refers to each element implicitly
    println(doubled)

    println("\n--- Local functions (nested inside another function) ---")
    fun localHelper(n: Int): Int = n * n
    println("local helper: ${localHelper(4)}")
}
