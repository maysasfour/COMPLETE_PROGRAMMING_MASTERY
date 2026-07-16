// Example.swift - Optionals: Swift's null-safety mechanism, directly comparable to Kotlin's
// String? (just covered) but with its own distinct syntax (Optional<T>/T?, if let, guard let,
// nil-coalescing ??, force unwrap !).
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// Basic types -- Int, Double, String, Bool, all value types (structs under the hood, Lesson 11)
let age: Int = 30
let price: Double = 19.99
let name: String = "Ada"
let active: Bool = true
print("age=\(age), price=\(price), name=\(name), active=\(active)")

// Type inference: Swift infers types, but remains statically typed
let inferred = 42 // inferred as Int at compile time
print("inferred is an Int: \(inferred)")

// --- Optionals: T? means "either a T, or nil" -- Swift's equivalent of Kotlin's T? ---
let nonOptional: String = "always has a value"
let optional: String? = nil // the ? makes this type EXPLICITLY optional
print("nonOptional: \(nonOptional)")
print("optional: \(optional ?? "no value")") // ?? -- nil-coalescing operator, like Kotlin's ?:

// let nonOptional2: String = nil // COMPILE ERROR: 'nil' cannot be used with non-optional type 'String'

// --- Optional binding: if let / guard let -- safely unwrap an optional ---
var maybeName: String? = "Grace"
if let unwrapped = maybeName {
    print("if let unwrapped: \(unwrapped)")
} else {
    print("maybeName was nil")
}

func greet(_ maybe: String?) -> String {
    guard let value = maybe else {
        return "no name provided" // guard let: early-exit if nil, `value` usable AFTER the guard
    }
    return "Hello, \(value)!" // value is a non-optional String here, safely unwrapped
}
print(greet("Linus"))
print(greet(nil))

// --- Optional chaining (?.) -- like Kotlin's ?. ---
struct Address { var city: String? }
struct UserRecord { var address: Address? }
let user = UserRecord(address: nil)
print("city: \(user.address?.city ?? "no city on file")")

// --- Force unwrap (!) -- like Kotlin's !!, throws a runtime crash if actually nil ---
let definitelyNotNil: String? = "trust me"
print(definitelyNotNil!.uppercased()) // crashes with a fatal error if actually nil

// --- Optional chaining with a genuinely nil value, using ?? for a safe default ---
var emptyOptional: Int? = nil
let safeValue = emptyOptional ?? -1
print("safe default: \(safeValue)")
