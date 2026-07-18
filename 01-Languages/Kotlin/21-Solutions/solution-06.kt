// Exercise 06 -- Concurrent Price Checks
import kotlinx.coroutines.*

suspend fun checkPrice(store: String, delayMs: Long): Pair<String, Double> {
    delay(delayMs) // suspends only the coroutine, freeing the underlying thread -- the whole point of the comparison below
    val price = 10.0 + delayMs / 10.0 // arbitrary but deterministic stand-in price, tied to the simulated latency
    return store to price
}

// Deliberately reproduces Lesson 19's "wrong tool inside a coroutine" finding on a fresh
// scenario, rather than trusting the earlier lesson's numbers without re-checking here.
suspend fun checkPriceBlocking(store: String, delayMs: Long): Pair<String, Double> {
    Thread.sleep(delayMs) // BLOCKS the real OS thread -- defeats cooperative coroutine scheduling
    val price = 10.0 + delayMs / 10.0
    return store to price
}

fun main() = runBlocking {
    val delays = listOf("StoreA" to 150L, "StoreB" to 300L, "StoreC" to 100L, "StoreD" to 250L)

    println("--- concurrent (delay + async/await) ---")
    val concurrentStart = System.currentTimeMillis()
    val deferredResults = delays.map { (store, ms) -> async { checkPrice(store, ms) } }
    val results = deferredResults.map { it.await() }
    val concurrentElapsed = System.currentTimeMillis() - concurrentStart
    for ((store, price) in results) println("$store: $%.2f".format(price))
    val cheapest = results.minByOrNull { it.second }
    println("Cheapest: ${cheapest?.first} at $%.2f".format(cheapest?.second))
    println("Elapsed (concurrent): ${concurrentElapsed}ms (slowest single delay was 300ms)")

    println("--- sequential-by-blocking (Thread.sleep inside a coroutine, async/await used the same way) ---")
    val blockingStart = System.currentTimeMillis()
    val blockingDeferred = delays.map { (store, ms) -> async { checkPriceBlocking(store, ms) } }
    blockingDeferred.map { it.await() }
    val blockingElapsed = System.currentTimeMillis() - blockingStart
    println("Elapsed (Thread.sleep version): ${blockingElapsed}ms (sum of all four delays is 800ms)")
}
