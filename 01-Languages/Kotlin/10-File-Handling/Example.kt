// Example.kt - File.writeText/readText (Kotlin's concise extension functions over java.io.File),
// and JSON via Gson (Kotlin's standard library has NO built-in JSON, same gap as Java, since
// Kotlin runs on the JVM and doesn't add its own JSON support beyond what Java provides -- none).

import java.io.File
import com.google.gson.Gson

data class Person(val name: String, val age: Int, val active: Boolean)

fun main() {
    val dir = File("scratch")
    dir.mkdirs()
    val file = File(dir, "notes.txt")

    println("--- File.writeText / readText (Kotlin extension functions over java.io.File) ---")
    file.writeText("line one\nline two\n")
    println(file.readText())

    println("\n--- Appending ---")
    file.appendText("line three\n")
    println(file.readText())

    println("\n--- Reading line by line ---")
    file.forEachLine { line -> println("  $line") } // forEachLine -- a Kotlin extension, not in Java

    println("\n--- Missing file: throws (Kotlin, like Java, IS exception-based for file I/O) ---")
    val missing = File(dir, "does-not-exist.txt")
    try {
        missing.readText()
    } catch (e: java.io.FileNotFoundException) {
        println("caught: ${e.message?.take(40)}...")
    }

    println("\n--- JSON via Gson (Kotlin has NO built-in JSON, same gap as Java) ---")
    val gson = Gson()
    val person = Person("Ada", 30, true)
    val json = gson.toJson(person)
    println(json)
    val decoded = gson.fromJson(json, Person::class.java) // Person::class.java -- Kotlin's reflection syntax
    println("decoded name: ${decoded.name}")

    // clean up -- this course never leaves scratch artifacts behind
    file.delete()
    dir.delete()
}
