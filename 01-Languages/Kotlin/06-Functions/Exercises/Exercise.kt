// Exercise: write an extension function `Int.isPrime(): Boolean`, then use it with
// a higher-order function (filter) to find all primes in a range, and a vararg function
// `average(vararg numbers: Double): Double`.

fun Int.isPrime(): Boolean {
    // TODO: implement -- return false for n < 2, then check divisibility up to sqrt(n)
    return false
}

fun average(vararg numbers: Double): Double {
    // TODO: implement using numbers.sum() / numbers.size
    return 0.0
}

fun main() {
    val primes = (2..30).filter { it.isPrime() }
    println("primes up to 30: $primes") // expected: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
    println("average: ${average(1.0, 2.0, 3.0, 4.0)}") // expected: 2.5
}
