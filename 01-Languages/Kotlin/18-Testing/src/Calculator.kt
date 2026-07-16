class Calculator {
    fun add(a: Int, b: Int): Int = a + b

    fun divide(a: Double, b: Double): Double {
        if (b == 0.0) throw IllegalArgumentException("division by zero")
        return a / b
    }

    fun isPalindrome(s: String): Boolean {
        val cleaned = s.filter { it.isLetterOrDigit() }.lowercase()
        return cleaned == cleaned.reversed()
    }
}
