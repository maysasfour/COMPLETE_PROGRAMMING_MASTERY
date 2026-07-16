// Example.kt - try/catch/finally, try as an EXPRESSION (produces a value), custom exceptions,
// and a genuine, verified Kotlin design choice: NO checked exceptions at all (unlike Java).

class InsufficientFundsException(val shortfall: Double) :
    Exception("insufficient funds, short by $shortfall")

fun withdraw(balance: Double, amount: Double): Double {
    if (amount > balance) {
        throw InsufficientFundsException(amount - balance)
    }
    return balance - amount
}

fun divide(a: Double, b: Double): Double {
    if (b == 0.0) throw ArithmeticException("cannot divide $a by zero")
    return a / b
}

fun main() {
    println("--- try/catch/finally ---")
    try {
        println(divide(10.0, 2.0))
        println(divide(5.0, 0.0))
    } catch (e: ArithmeticException) {
        println("caught: ${e.message}")
    } finally {
        println("finally always runs")
    }

    println("\n--- try as an EXPRESSION -- produces a value directly ---")
    val result: Double = try {
        divide(10.0, 0.0)
    } catch (e: ArithmeticException) {
        -1.0 // the value of the whole try/catch expression when an exception is caught
    }
    println("result: $result")

    println("\n--- Custom exception ---")
    try {
        withdraw(100.0, 150.0)
    } catch (e: InsufficientFundsException) {
        println("${e.message} (shortfall property: ${e.shortfall})")
    }

    println("\n--- Kotlin has NO checked exceptions at all (a deliberate design choice) ---")
    // Unlike Java (covered in this repository), Kotlin does not distinguish checked vs.
    // unchecked exceptions -- EVERY exception is effectively unchecked. A function can throw
    // any exception without declaring it (no `throws` clause exists in Kotlin), and calling
    // code is never FORCED by the compiler to catch or declare it, unlike Java's checked
    // exceptions (IOException, etc.). This was a deliberate, documented Kotlin design decision,
    // based on JetBrains' assessment that checked exceptions provided little real benefit
    // in large Java codebases and mostly encouraged either overly broad catch blocks or
    // exception swallowing to satisfy the compiler.
    fun riskyIO() { throw java.io.IOException("simulated IO failure") } // no `throws` needed/possible
    try {
        riskyIO()
    } catch (e: java.io.IOException) {
        println("caught IOException with no throws declaration needed: ${e.message}")
    }
}
