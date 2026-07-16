// Example.kt - closures that CAN mutate captured local variables (unlike Java's
// effectively-final lambda captures), higher-order functions, function composition,
// and function references (::).

fun makeCounter(): () -> Int {
    var count = 0 // a local `var`, captured by the returned lambda
    return { count++ } // the lambda MUTATES the captured variable directly -- genuinely allowed
}

fun compose(f: (Int) -> Int, g: (Int) -> Int): (Int) -> Int = { x -> f(g(x)) }

fun isEven(n: Int): Boolean = n % 2 == 0

fun main() {
    println("--- Closures CAN mutate captured local variables (unlike Java's lambdas) ---")
    val counter = makeCounter()
    println(counter()) // 0
    println(counter()) // 1
    println(counter()) // 2 -- genuinely incrementing the SAME captured `count` across calls

    println("\n--- A second, independent closure has its OWN captured state ---")
    val counter2 = makeCounter()
    println(counter2()) // 0 -- independent from `counter`'s state

    println("\n--- Function composition ---")
    val addOne: (Int) -> Int = { it + 1 }
    val square: (Int) -> Int = { it * it }
    val addThenSquare = compose(square, addOne)
    println(addThenSquare(4)) // (4+1)^2 = 25

    println("\n--- Function references (::) -- pass an existing function as a value ---")
    val nums = listOf(1, 2, 3, 4, 5, 6)
    println(nums.filter(::isEven)) // ::isEven -- a function reference, equivalent to { isEven(it) }

    println("\n--- Standard higher-order functions: let, apply, run, also ---")
    val result = "hello".let { it.uppercase() } // let: transforms a value, returns the lambda's result
    println(result)

    data class Builder(var name: String = "", var age: Int = 0)
    val built = Builder().apply { // apply: configures `this`, returns the receiver itself
        name = "Ada"
        age = 30
    }
    println(built)
}
