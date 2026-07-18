// Exercise 05 -- Declaration-Site Variance: a Read-Only Event Stream

interface EventBuffer<out T> { // covariant -- T only ever appears in "out" (return) position below
    fun latest(): T?
    val size: Int
}

class MutableEventBuffer<T>(private val items: MutableList<T> = mutableListOf()) : EventBuffer<T> {
    fun add(item: T) {
        items.add(item)
    }

    override fun latest(): T? = items.lastOrNull()
    override val size: Int get() = items.size

    fun asReadOnly(): EventBuffer<T> = this // upcast to the covariant interface view
}

fun printLatestAnyEvent(buffer: EventBuffer<Any>) {
    println("latest (as Any): ${buffer.latest()}, size=${buffer.size}")
}

fun main() {
    val stringEvents = MutableEventBuffer<String>()
    stringEvents.add("login")
    stringEvents.add("logout")

    // MutableEventBuffer<T> ITSELF is invariant (plain <T>, no `out`) -- matching Lesson 13's
    // InvariantBox finding. Uncommenting the next line reproduces this real compiler error:
    //
    //   solution-05.kt:29:47: error: type mismatch: inferred type is MutableEventBuffer<String> but MutableEventBuffer<Any> was expected
    //   val widened: MutableEventBuffer<Any> = stringEvents
    //                                           ^
    //
    // val widened: MutableEventBuffer<Any> = stringEvents

    println("--- invariant MutableEventBuffer<T> ---")
    println("MutableEventBuffer<String> is NOT assignable to MutableEventBuffer<Any> -- verified above via a real compile error (left commented out so this file still builds).")

    // EventBuffer<out T>, by contrast, IS covariant -- an EventBuffer<String> is genuinely an
    // EventBuffer<Any> once viewed through the `out T`-declared interface, with zero wildcard-like
    // syntax needed at this call site (the function parameter is plainly typed EventBuffer<Any>).
    println("--- covariant EventBuffer<out T> ---")
    printLatestAnyEvent(stringEvents.asReadOnly())

    // Reasoning about why `fun add(item: T)` cannot legally live on EventBuffer<out T> itself:
    // `out T` means T may only appear in OUTPUT (return-type / read-only property) positions on
    // the interface -- adding `fun add(item: T)` would put T in an INPUT (parameter) position,
    // which the compiler forbids specifically because it would let a caller holding an
    // EventBuffer<Any> reference (that's secretly backed by an EventBuffer<String>) call
    // add(42), silently corrupting the real underlying List<String> with a non-String value.
    // The Kotlin compiler reports this class of violation as:
    //   error: type parameter T is declared as 'out' but occurs in 'in' position in type T
    // This specific line is not reproduced live per the exercise's own instructions -- reasoned
    // about directly from Lesson 13's "out means produce-only" rule instead.
    println("--- why 'in'-position T is illegal on an 'out T' interface (reasoned, not reproduced) ---")
    println("Adding it would let an EventBuffer<Any> view silently write a wrong-typed value into what's really an EventBuffer<String>'s backing list.")
}
