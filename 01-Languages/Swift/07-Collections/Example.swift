// Example.swift - Array/Dictionary/Set are VALUE types in Swift (structs internally, with
// copy-on-write optimization) -- a genuine, important contrast with Kotlin/Java, where
// collections are always reference types (objects). Assigning an array to another variable
// or passing it to a function copies it logically -- mutating the copy never affects the
// original, unlike Kotlin's mutable-list-aliasing gotcha covered in this repository's
// Kotlin course (Lesson 07 there).
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// --- Arrays are value types: assignment COPIES, doesn't alias ---
var original = [1, 2, 3]
var copy = original // this is a LOGICAL copy, not a reference to the same array
copy.append(4)
print("original: \(original)") // [1, 2, 3] -- UNCHANGED, unlike Kotlin's MutableList aliasing gotcha
print("copy: \(copy)")            // [1, 2, 3, 4]

// --- Dictionaries ---
let map: [String: Any] = ["name": "Ada", "age": 30]
print(map["name"] ?? "missing")
print(map["missing"] ?? "not found") // nil -- subscript returns an Optional, no exception

// --- Sets: unordered, unique elements ---
var uniqueNumbers: Set<Int> = [1, 2, 2, 3, 3, 3]
print("set: \(uniqueNumbers.sorted())") // [1, 2, 3] -- duplicates removed automatically

// --- map/filter/reduce ---
let nums = [1, 2, 3, 4, 5]
print(nums.map { $0 * 2 })
print(nums.filter { $0 % 2 == 0 })
print(nums.reduce(0, +))

// --- Mutating functions vs. non-mutating: sort() (in place) vs sorted() (new array) ---
var unsorted = [3, 1, 4, 1, 5]
let sortedCopy = unsorted.sorted() // returns a NEW array, unsorted is untouched
unsorted.sort()                      // mutates unsorted IN PLACE
print("sortedCopy: \(sortedCopy), unsorted after .sort(): \(unsorted)")

// --- Passing an array to a function: still copy semantics, verified by not mutating the caller's ---
func appendSilently(_ arr: [Int]) -> [Int] {
    var localCopy = arr
    localCopy.append(99)
    return localCopy // the CALLER's array is never affected, since `arr` was a value-type copy
}
let callerArray = [1, 2, 3]
let result = appendSilently(callerArray)
print("callerArray (unchanged): \(callerArray)")
print("result: \(result)")
