// Example.kt - Kotlin coroutines (kotlinx.coroutines): suspend functions, structured
// concurrency (runBlocking/coroutineScope), async/await, and launch -- a genuinely different
// concurrency model from Java's raw threads, Go's goroutines/channels, or Rust's async/await
// (which needs a separate runtime crate like tokio, mirrored here by needing kotlinx.coroutines
// as a separate LIBRARY, since suspend functions are a LANGUAGE feature but the coroutine
// DISPATCHER/scheduler is a library, not built into Kotlin itself).

import kotlinx.coroutines.*
import kotlin.system.measureTimeMillis

suspend fun fetchValue(id: Int, delayMs: Long): Int {
    delay(delayMs) // suspends the coroutine WITHOUT blocking the underlying thread
    return id * 10
}

fun main() = runBlocking { // runBlocking: bridges regular blocking code into the coroutine world
    println("--- Sequential suspend calls ---")
    val sequentialTime = measureTimeMillis {
        val a = fetchValue(1, 200)
        val b = fetchValue(2, 200)
        println("a=$a, b=$b")
    }
    println("sequential took ${sequentialTime}ms")

    println("\n--- Concurrent with async/await -- REAL timing improvement, measured directly ---")
    val concurrentTime = measureTimeMillis {
        val deferredA = async { fetchValue(1, 200) } // starts immediately, doesn't block
        val deferredB = async { fetchValue(2, 200) } // starts immediately too, runs alongside A
        val a = deferredA.await() // suspends until deferredA completes
        val b = deferredB.await()
        println("a=$a, b=$b")
    }
    println("concurrent took ${concurrentTime}ms")
    if (concurrentTime < sequentialTime) {
        println("confirmed: async/await's concurrent execution beat sequential suspend calls")
    }

    println("\n--- Structured concurrency: coroutineScope waits for ALL children to finish ---")
    coroutineScope {
        launch { // launch: fire-and-forget within this scope -- but the scope WAITS for it
            delay(100)
            println("child coroutine finished")
        }
        println("parent coroutine continues immediately (launch doesn't block)")
    }
    println("coroutineScope only returns after its child coroutine completes -- printed AFTER \"child coroutine finished\"")
}
