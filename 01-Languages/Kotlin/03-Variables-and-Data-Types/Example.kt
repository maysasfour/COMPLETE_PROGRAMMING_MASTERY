// Example.kt - null safety baked into the type system itself: String vs String?,
// safe calls (?.), the Elvis operator (?:), and non-null assertion (!!).

fun main() {
    println("--- Basic types (all objects, no primitive/object split like Java) ---\n")
    val age: Int = 30
    val price: Double = 19.99
    val name: String = "Ada"
    val active: Boolean = true
    println("age=$age, price=$price, name=$name, active=$active")

    println("\n--- Type inference: Kotlin infers types, but is still statically typed ---")
    val inferred = 42 // inferred as Int at COMPILE time, not dynamically typed
    println("inferred is an Int: $inferred")

    println("\n--- Null safety: String vs String? ---")
    val nonNullable: String = "always has a value"
    val nullable: String? = null // the ? makes this type EXPLICITLY nullable
    println("nonNullable: $nonNullable")
    println("nullable: $nullable")
    // nonNullable = null            // would be a COMPILE ERROR -- verified separately:
    // "error: null cannot be a value of a non-null type 'String'"

    println("\n--- Safe call operator (?.) ---")
    val length: Int? = nullable?.length // ?. returns null instead of throwing if nullable IS null
    println("length of a null string: $length")
    val nonNullLength: Int? = nonNullable.length // no ?. needed -- nonNullable can't be null
    println("length of a non-null string: $nonNullLength")

    println("\n--- Elvis operator (?:) -- a default value if the left side is null ---")
    val safeLength = nullable?.length ?: -1
    println("safe length with default: $safeLength")

    println("\n--- Non-null assertion (!!) -- throws NPE if actually null, use sparingly ---")
    val definitelyNotNull: String? = "trust me"
    println(definitelyNotNull!!.uppercase()) // asserts non-null; a genuine NullPointerException
                                                // would be thrown here if this were actually null

    println("\n--- const vs val ---")
    println("MAX_SIZE: $MAX_SIZE") // top-level const, compile-time constant
}

const val MAX_SIZE = 100 // const val: compile-time constant, must be top-level or in a companion object
