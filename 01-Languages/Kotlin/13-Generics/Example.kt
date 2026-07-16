// Example.kt - real generics with DECLARATION-SITE variance (`out`/`in`), a genuine
// contrast with Java's USE-SITE wildcards (`? extends`/`? super`) covered in this
// repository's Java course, plus reified type parameters via `inline fun`.

open class Animal(val name: String)
class Dog(name: String) : Animal(name)

// Invariant by default (like Java's generics without wildcards): Box<Dog> is NOT a Box<Animal>.
class InvariantBox<T>(val item: T)

// `out T`: declares Box PRODUCER-ONLY-safe (covariant) -- Box<Dog> then genuinely IS a Box<Animal>.
// This variance is declared ONCE, at the class definition, not re-specified at every call site
// the way Java's `? extends T` wildcard must be repeated everywhere it's needed.
class CovariantBox<out T>(val item: T)

fun printAnimalName(box: CovariantBox<Animal>) = println("box contains: ${box.item.name}")

// Generic function with a type constraint (upper bound)
fun <T : Comparable<T>> maxOf(a: T, b: T): T = if (a > b) a else b

// reified type parameter: ONLY possible on an `inline fun` -- lets the function use T at
// RUNTIME (e.g., with `is`/`as`), something normally erased by the JVM (like Java's erasure).
inline fun <reified T> isInstance(value: Any): Boolean = value is T

fun main() {
    println("--- Invariant generics (the default): Box<Dog> is NOT a Box<Animal> ---")
    val dogBox = InvariantBox(Dog("Rex"))
    // val animalBox: InvariantBox<Animal> = dogBox // COMPILE ERROR, verified separately:
    // "error: initializer type mismatch: expected 'InvariantBox<Animal>', actual 'InvariantBox<Dog>'"
    println("dogBox.item.name: ${dogBox.item.name}")

    println("\n--- Declaration-site variance (`out T`): Box<Dog> genuinely IS a Box<Animal> ---")
    val covariantDogBox = CovariantBox(Dog("Fido"))
    printAnimalName(covariantDogBox) // works! CovariantBox<Dog> is accepted where CovariantBox<Animal> is expected

    println("\n--- Generic function with a type constraint ---")
    println(maxOf(3, 7))
    println(maxOf("apple", "banana"))

    println("\n--- reified type parameter: checking T at RUNTIME, impossible with plain generics ---")
    println(isInstance<String>("hello")) // true
    println(isInstance<Int>("hello"))       // false
    // A NON-inline, non-reified generic function could NOT do `value is T` at all --
    // it would fail to compile with "cannot check for instance of erased type: T",
    // since the JVM erases T at runtime for ordinary generics (matching Java's erasure).
}
