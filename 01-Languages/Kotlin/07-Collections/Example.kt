// Example.kt - listOf/mutableListOf (read-only VIEW vs genuinely mutable), Map, and the
// functional trio (map/filter/reduce), plus destructuring.

fun main() {
    println("--- listOf (read-only interface) vs mutableListOf (genuinely mutable) ---")
    val readOnly = listOf(1, 2, 3)          // type: List<Int> -- no add()/remove() available
    val mutable = mutableListOf(1, 2, 3)   // type: MutableList<Int> -- has add()/remove()
    mutable.add(4)
    println("readOnly: $readOnly")
    println("mutable after add: $mutable")
    // readOnly.add(4) // COMPILE ERROR: List<Int> has no add() method at all

    println("\n--- A genuine, verified nuance: listOf() is READ-ONLY, not necessarily IMMUTABLE ---")
    val backing = mutableListOf(1, 2, 3)
    val view: List<Int> = backing // `view`'s STATIC type has no mutating methods...
    backing.add(4)                    // ...but the underlying object can still change via `backing`
    println("view sees the mutation through the backing list: $view") // [1, 2, 3, 4] -- view is NOT a copy!

    println("\n--- Map ---")
    val map = mapOf("name" to "Ada", "role" to "Engineer") // `to` creates a Pair
    println(map["name"])
    println(map["missing"]) // null -- no exception, since Map.get returns V?

    println("\n--- map/filter/reduce ---")
    val nums = listOf(1, 2, 3, 4, 5)
    println(nums.map { it * 2 })
    println(nums.filter { it % 2 == 0 })
    println(nums.reduce { acc, n -> acc + n })
    println(nums.fold(100) { acc, n -> acc + n }) // fold: like reduce but with an explicit initial value

    println("\n--- Destructuring (data classes and Pairs support this natively) ---")
    val (first, second, third) = listOf(1, 2, 3) // destructuring a List (via component1/2/3)
    println("$first, $second, $third")
    for ((key, value) in map) println("  $key = $value") // destructuring Map entries directly

    println("\n--- sortedBy vs sort: NEW list vs in-place mutation ---")
    val unsorted = mutableListOf(3, 1, 4, 1, 5)
    val sortedCopy = unsorted.sorted() // returns a NEW, sorted List -- unsorted is untouched
    unsorted.sort()                      // mutates unsorted IN PLACE
    println("sortedCopy: $sortedCopy, unsorted after .sort(): $unsorted")
}
