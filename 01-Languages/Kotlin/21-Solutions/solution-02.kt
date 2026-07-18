// Exercise 02 -- Data Class Equality and copy()

data class Money(val amount: Long, val currencyCode: String) // amount in integer cents

fun main() {
    val price1 = Money(1999, "USD")
    val price2 = Money(1999, "USD")

    println("--- structural (==) vs referential (===) equality ---")
    println("price1 == price2 : ${price1 == price2}")   // true -- data class generates equals() from every property
    println("price1 === price2 : ${price1 === price2}") // false -- genuinely two different objects on the heap

    println("--- copy() ---")
    val discounted = price1.copy(amount = 1499)
    println("discounted: $discounted")
    println("price1 (unchanged, proving copy() does not mutate the source): $price1")

    println("--- auto-generated toString() ---")
    println(price1) // no manual override anywhere -- this is what the compiler generates by default
}
