// Example.kt - string templates, multiline raw strings (triple-quoted), and core string
// functions -- all built on java.lang.String underneath (Kotlin's String IS Java's String,
// since Kotlin runs on the JVM and interoperates directly).

fun main() {
    val name = "Ada"
    val age = 30

    println("--- String templates (seen since Lesson 02) ---")
    println("$name is $age years old, and next year will be ${age + 1}")

    println("\n--- Triple-quoted raw strings: no escaping needed, preserves formatting ---")
    val raw = """
        Line one
        Line two with a literal backslash: \n (not a newline escape here!)
        Line three with "quotes" needing no escaping at all
    """.trimIndent() // trimIndent() removes the common leading whitespace from each line
    println(raw)

    println("\n--- Core string functions (Kotlin's String IS java.lang.String) ---")
    val s = "Hello, World!"
    println(s.uppercase())
    println(s.lowercase())
    println(s.length)
    println(s.replace("World", "Kotlin"))
    println(s.substring(7, 12))

    println("\n--- Kotlin-specific convenience functions ---")
    println(s.startsWith("Hello"))
    println(s.contains("World"))
    println(s.split(", "))

    println("\n--- String comparison: == is content-based (Lesson 04's structural equality) ---")
    val a = "test"
    val b = String(charArrayOf('t', 'e', 's', 't')) // built via a char array -- genuinely different object
    println(a == b)   // true -- structural equality, NOT affected by how the object was constructed
    println(a === b) // false -- different object instances, unlike the interned-literal case in Lesson 04
}
