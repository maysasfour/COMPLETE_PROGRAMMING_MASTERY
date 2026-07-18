// Exercise 04 -- String and Collection Extension Functions

fun String.isPalindrome(): Boolean {
    val cleaned = this.lowercase().filter { it.isLetterOrDigit() }
    return cleaned == cleaned.reversed()
}

fun <T> List<T>.secondOrNull(): T? = if (this.size >= 2) this[1] else null

fun main() {
    println("--- isPalindrome() ---")
    println("\"racecar\".isPalindrome() = ${"racecar".isPalindrome()}")
    println("\"A man, a plan, a canal: Panama\".isPalindrome() = ${"A man, a plan, a canal: Panama".isPalindrome()}")
    println("\"hello\".isPalindrome() = ${"hello".isPalindrome()}")

    println("--- secondOrNull() ---")
    println("listOf(1,2,3).secondOrNull() = ${listOf(1, 2, 3).secondOrNull()}")
    println("listOf(1).secondOrNull() = ${listOf(1).secondOrNull()}")
    println("emptyList<Int>().secondOrNull() = ${emptyList<Int>().secondOrNull()}")

    // Extension functions are resolved STATICALLY, by the declared (compile-time) type of the
    // expression they're called on -- not dynamically, the way a real overridden member method
    // would be. This block proves it: a local extension with the identical name/signature, declared
    // in a narrower scope, wins for any call inside that scope purely due to lexical shadowing,
    // regardless of what the receiver's runtime value actually is.
    println("--- static resolution proof ---")
    println("top-level extension outside the shadowed scope: ${"level".isPalindrome()}")
    run {
        fun String.isPalindrome(): Boolean = false // shadows the top-level version for this block only
        println("locally shadowed extension inside the block: ${"level".isPalindrome()}")
    }
    println("top-level extension again, after the block ends: ${"level".isPalindrome()}")
}
