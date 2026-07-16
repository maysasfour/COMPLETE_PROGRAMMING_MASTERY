// Example.kt - data classes, sealed classes, `object` (singleton), companion objects,
// primary/secondary constructors, and a genuine, verified Kotlin design choice: classes
// are FINAL by default (opposite of Java) -- `open` is required to allow subclassing/overriding.

// `open` is REQUIRED here -- without it, this class could not be extended at all
// (verified separately: omitting `open` produces "error: this type is final, so it cannot be extended").
open class Animal(val name: String) {
    open fun speak(): String = "..." // `open` also required on the METHOD to allow overriding
}

class Dog(name: String) : Animal(name) {
    override fun speak(): String = "Woof!" // `override` is MANDATORY, unlike Java's optional @Override
}

// data class: auto-generates equals()/hashCode()/toString()/copy()/componentN() (Lesson 04, 07)
data class Point(val x: Int, val y: Int)

// sealed class (from Lesson 05): fixed, compiler-known set of subtypes
sealed class Result
data class Success(val value: Int) : Result()
data class Failure(val error: String) : Result()

// object: a SINGLETON declaration -- exactly one instance ever exists, created lazily on first use
object Config {
    val maxRetries = 3
    fun describe() = "Config(maxRetries=$maxRetries)"
}

class Counter private constructor(val id: Int) { // private primary constructor
    companion object { // companion object: Kotlin's replacement for Java's `static` members
        private var nextId = 1
        fun create(): Counter = Counter(nextId++) // factory function, since the constructor is private
    }

    // Secondary constructor: must delegate to the primary constructor via `this(...)`
    constructor() : this(nextId++)
}

fun main() {
    println("--- Inheritance: `open` and `override` are both MANDATORY, verified separately ---")
    val animals: List<Animal> = listOf(Animal("Generic"), Dog("Rex"))
    for (a in animals) println("${a.name} says ${a.speak()}")

    println("\n--- data class: equals/hashCode/toString/copy generated automatically ---")
    val p1 = Point(1, 2)
    val p2 = p1.copy(y = 99) // copy() -- creates a new instance with one field changed
    println("p1=$p1, p2=$p2, p1==p1.copy()=${p1 == p1.copy()}")

    println("\n--- sealed class + when (Lesson 05) ---")
    fun describe(r: Result): String = when (r) {
        is Success -> "Success: ${r.value}"
        is Failure -> "Failure: ${r.error}"
    }
    println(describe(Success(42)))
    println(describe(Failure("not found")))

    println("\n--- object: singleton, exactly one instance ---")
    println(Config.describe())
    println("same instance: ${Config === Config}") // trivially true -- there's only ever one

    println("\n--- companion object: Kotlin's static-member replacement ---")
    val c1 = Counter.create()
    val c2 = Counter.create()
    println("c1.id=${c1.id}, c2.id=${c2.id}")
}
