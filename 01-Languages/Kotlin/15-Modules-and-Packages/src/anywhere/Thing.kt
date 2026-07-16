// Thing.kt - lives in src/anywhere/, but declares package com.example.mypackage.
// Verified live: Kotlin does NOT enforce package-to-directory matching the way
// Java's javac does (a real, checked contrast with this repository's Java course).

package com.example.mypackage

class Thing {
    fun greet(): String = "hello from a directory that does NOT match my package name"
}
