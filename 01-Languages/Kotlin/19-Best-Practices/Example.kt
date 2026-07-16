// Example.kt - Before/after: three genuine Kotlin anti-patterns and their fixes, each
// reproduced live to show the bad version actually misbehaving, not just described.

import kotlinx.coroutines.*

// --- Anti-pattern 1: overusing !! instead of proper null handling ---
fun findUserBad(users: Map<String, Int>, name: String): Int {
    return users[name]!! // throws NPE with a useless, generic message if name isn't found
}
fun findUserGood(users: Map<String, Int>, name: String): Int {
    return users[name] ?: throw NoSuchElementException("no user named '$name' found") // clear, specific
}

// --- Anti-pattern 2: exposing a mutable backing list as if it were safely read-only ---
class TaskListBad {
    val tasks = mutableListOf<String>() // exposed directly -- ANY caller can mutate it!
}
class TaskListGood {
    private val _tasks = mutableListOf<String>()
    val tasks: List<String> get() = _tasks.toList() // returns a genuine DEFENSIVE COPY, not a view
    fun addTask(task: String) { _tasks.add(task) }
}

// --- Anti-pattern 3: Thread.sleep() inside a coroutine instead of delay() ---
suspend fun blockingWaitBad() {
    Thread.sleep(200) // blocks the ENTIRE underlying thread -- other coroutines can't run on it
}
suspend fun nonBlockingWaitGood() {
    delay(200) // suspends only THIS coroutine -- the thread is free for other coroutines
}

fun main() = runBlocking {
    println("--- Anti-pattern 1: !! vs proper null handling ---")
    val users = mapOf("Ada" to 1, "Grace" to 2)
    try {
        findUserBad(users, "Linus")
    } catch (e: NullPointerException) {
        println("bad: threw a generic NPE with no useful message: ${e.message}")
    }
    try {
        findUserGood(users, "Linus")
    } catch (e: NoSuchElementException) {
        println("good: threw a specific, clear exception: ${e.message}")
    }

    println("\n--- Anti-pattern 2: exposed mutable list vs defensive copy ---")
    val badList = TaskListBad()
    badList.tasks.add("sneaky mutation from outside the class") // compiles fine! genuinely mutates internal state
    println("bad: external code mutated internal state directly: ${badList.tasks}")

    val goodList = TaskListGood()
    goodList.addTask("added properly")
    val exposedView = goodList.tasks
    // exposedView.add("...") // COMPILE ERROR: tasks is List<String>, no add() method at all
    println("good: tasks (a real, defensive copy): $exposedView")

    println("\n--- Anti-pattern 3: Thread.sleep() vs delay() inside a coroutine ---")
    val blockingTime = kotlin.system.measureTimeMillis {
        coroutineScope {
            launch { blockingWaitBad() }
            launch { blockingWaitBad() }
        }
    }
    val nonBlockingTime = kotlin.system.measureTimeMillis {
        coroutineScope {
            launch { nonBlockingWaitGood() }
            launch { nonBlockingWaitGood() }
        }
    }
    println("bad (Thread.sleep, blocks shared threads): ${blockingTime}ms")
    println("good (delay, cooperative): ${nonBlockingTime}ms")
    println("(on a limited dispatcher, Thread.sleep can serialize coroutines that delay() would run concurrently)")
}
