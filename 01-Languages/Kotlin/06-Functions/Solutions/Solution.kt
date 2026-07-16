fun Int.isPrime(): Boolean {
    if (this < 2) return false
    for (i in 2..Math.sqrt(this.toDouble()).toInt()) {
        if (this % i == 0) return false
    }
    return true
}

fun average(vararg numbers: Double): Double = numbers.sum() / numbers.size

fun main() {
    val primes = (2..30).filter { it.isPrime() }
    println("primes up to 30: $primes")
    println("average: ${average(1.0, 2.0, 3.0, 4.0)}")
}
