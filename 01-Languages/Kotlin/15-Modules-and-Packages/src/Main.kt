// Main.kt - imports Thing from com.example.mypackage, even though Thing.kt physically
// lives in src/anywhere/ -- proving Kotlin's package system is independent of file layout.

import com.example.mypackage.Thing

fun main() {
    println(Thing().greet())
    println("This compiled successfully despite Thing.kt living in src/anywhere/,")
    println("not src/com/example/mypackage/ -- Kotlin does not enforce path/package matching.")
}
