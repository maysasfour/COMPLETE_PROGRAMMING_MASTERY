# Kotlin Cheat Sheet

[Back to course overview](README.md)

## Variables and Null Safety

```kotlin
val age: Int = 30          // read-only (like Java's final, but the default idiom)
var count = 0                 // reassignable, type inferred
const val MAX = 100            // compile-time constant

val name: String = "Ada"       // can NEVER be null -- compiler enforced
val nickname: String? = null     // explicitly nullable

nickname?.length                 // safe call -- null if nickname is null
nickname?.length ?: -1           // Elvis operator -- default if null
nickname!!.length                 // non-null assertion -- throws NPE if actually null
```

## Operators (== is STRUCTURAL, opposite of Java!)

```kotlin
a == b     // calls .equals() -- content comparison (Kotlin's default)
a === b   // referential -- same object instance (Java's == equivalent)

2.0.pow(10.0)      // no ** operator -- kotlin.math.pow
1 <=> 2               // NOT valid Kotlin -- no spaceship operator

for (i in 1..5) { }        // inclusive
for (i in 1 until 5) { }     // exclusive of upper bound
for (i in 5 downTo 1) { }     // descending
for (i in 1..10 step 3) { }    // step

class Point(val x: Int, val y: Int) {
    operator fun plus(o: Point) = Point(x + o.x, y + o.y) // operator overloading
}
```

## Control Flow

```kotlin
val grade = if (score >= 90) "A" else "B"  // if AS AN EXPRESSION

val result = when (x) {
    1, 2 -> "one or two"      // no break, no fall-through
    in 3..10 -> "three to ten"
    else -> "other"             // required unless exhaustive (sealed class)
}

sealed class Shape
data class Circle(val r: Double) : Shape()
when (shape) {
    is Circle -> ...   // smart-cast: shape treated as Circle here
    // no else needed if ALL sealed subtypes covered -- compiler-enforced exhaustiveness
}
```

## Functions

```kotlin
fun greet(name: String, greeting: String = "Hi"): String = "$greeting, $name!"
greet(name = "Ada", greeting = "Hello")   // named args

fun sum(vararg nums: Int): Int = nums.sum()

fun String.shout() = uppercase() + "!"     // EXTENSION function -- adds a "method" to String
"hi".shout()

val double: (Int) -> Int = { it * 2 }        // typed lambda, `it` = implicit param
listOf(1,2,3).map { it * 2 }                    // trailing lambda syntax
```

## Collections (read-only interface vs mutable)

```kotlin
val readOnly = listOf(1, 2, 3)          // List<Int> -- no add()
val mutable = mutableListOf(1, 2, 3)   // MutableList<Int> -- has add()
// WARNING: read-only != immutable! A List view of a MutableList still
// reflects mutations made through the mutable reference to the SAME object.

val map = mapOf("a" to 1, "b" to 2)
map["a"]           // 1
map["missing"]    // null, no exception

nums.map { it * 2 }; nums.filter { it > 0 }; nums.reduce { a, b -> a + b }
val (a, b, c) = listOf(1, 2, 3)   // destructuring
```

## Strings

```kotlin
"Hello, $name! Next year: ${age + 1}"   // string template

val raw = """
    multi-line, no escaping needed
""".trimIndent()

s.uppercase(); s.length; s.replace("a","b"); s.split(",")
```

## Error Handling (NO checked exceptions at all!)

```kotlin
try {
    risky()
} catch (e: SomeException) {
    // handle
} finally { }

val result = try { risky() } catch (e: Exception) { fallback }  // try AS AN EXPRESSION

class MyException(val extra: Int) : Exception("custom message")

// No `throws` keyword exists -- every exception is effectively unchecked
```

## OOP (classes FINAL by default -- opposite of Java!)

```kotlin
open class Animal(val name: String) {         // `open` REQUIRED to allow subclassing
    open fun speak() = "..."                     // `open` REQUIRED to allow overriding
}
class Dog(name: String) : Animal(name) {
    override fun speak() = "Woof!"                // `override` MANDATORY, not optional
}

data class Point(val x: Int, val y: Int)  // auto equals/hashCode/toString/copy/destructuring
val p2 = p1.copy(y = 99)

object Config { val maxRetries = 3 }       // SINGLETON -- exactly one instance, ever

class Counter private constructor(val id: Int) {
    companion object {                          // replaces `static` -- a real singleton object
        fun create(): Counter = Counter(1)
    }
}
```

## Generics (declaration-site variance!)

```kotlin
class Box<T>(val item: T)              // invariant by default -- Box<Dog> is NOT Box<Animal>
class CovariantBox<out T>(val item: T)  // Box<Dog> genuinely IS CovariantBox<Animal>

fun <T : Comparable<T>> maxOf(a: T, b: T): T = if (a > b) a else b

inline fun <reified T> isInstance(v: Any): Boolean = v is T  // only works with inline + reified!
```

## Coroutines (kotlinx.coroutines -- a SEPARATE library, not built in)

```kotlin
suspend fun fetch(): Int { delay(100); return 42 } // delay() suspends, does NOT block the thread

fun main() = runBlocking {           // bridges blocking code into the coroutine world
    val a = async { fetch() }          // starts immediately
    val b = async { fetch() }          // runs alongside a
    println(a.await() + b.await())      // suspends until both finish

    coroutineScope {                     // structured concurrency: waits for ALL children
        launch { delay(100); println("child done") }
    } // only returns after the child completes
}
```

## Modules (packages independent of directory structure!)

```kotlin
package com.example.mypackage   // does NOT need to match the file's directory path in Kotlin
import com.example.mypackage.Thing
```

## Database (JDBC, same as Java)

```kotlin
val conn = DriverManager.getConnection("jdbc:sqlite::memory:")
conn.prepareStatement("SELECT * FROM users WHERE id = ?").use { stmt ->  // .use{} = try-with-resources
    stmt.setInt(1, id)
    val rs = stmt.executeQuery()
}
```

## HTTP / JSON

```kotlin
val client = HttpClient.newHttpClient()
val request = HttpRequest.newBuilder().uri(URI.create(url)).GET().build()
val response = client.send(request, HttpResponse.BodyHandlers.ofString())
response.statusCode()  // NO exception on 404 -- check this explicitly!

Gson().toJson(obj); Gson().fromJson(json, MyClass::class.java)  // no built-in JSON, same as Java
```

## Testing (kotlin.test + a binding like JUnit 5)

```kotlin
class MyTest {
    @BeforeTest fun setUp() { }

    @Test fun itWorks() { assertEquals(4, 2 + 2) }

    @Test fun throwsProperly() {
        assertFailsWith<IllegalArgumentException> { riskyCall() }
    }
}
```

## Running Code

```bash
kotlinc file.kt -include-runtime -d file.jar   # compile to a standalone runnable JAR
java -jar file.jar
```
