// Example.swift - struct (value type, the idiomatic DEFAULT) vs class (reference type,
// used only when reference semantics/inheritance are genuinely needed) -- a fundamental,
// deliberate Swift design choice, unlike Kotlin/Java where EVERY user-defined type is a
// reference type (a class). Also: protocol-oriented programming (protocols + extensions
// providing default implementations -- Swift's alternative to traditional inheritance),
// and enums with associated values.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// --- struct: VALUE type -- copied on assignment, no inheritance possible ---
struct PointStruct {
    var x: Int
    var y: Int
}
var s1 = PointStruct(x: 1, y: 2)
var s2 = s1 // COPIES s1 -- s2 is now an independent value
s2.x = 99
print("s1.x: \(s1.x), s2.x: \(s2.x)") // s1.x: 1, s2.x: 99 -- s1 was NEVER affected

// --- class: REFERENCE type -- assignment shares the SAME instance ---
class PointClass {
    var x: Int
    var y: Int
    init(x: Int, y: Int) { self.x = x; self.y = y }
}
let c1 = PointClass(x: 1, y: 2)
let c2 = c1 // c2 refers to the SAME instance as c1 -- no copy at all
c2.x = 99
print("c1.x: \(c1.x), c2.x: \(c2.x)") // c1.x: 99, c2.x: 99 -- BOTH changed, since they're the same object

// --- Protocol-oriented programming: protocols + extensions with default implementations ---
protocol Speaker {
    func speak() -> String
}
extension Speaker { // extension on the PROTOCOL itself -- provides a DEFAULT implementation
    func announce() -> String {
        return "Announcement: \(speak())" // any conforming type gets this method for FREE
    }
}
struct Dog: Speaker {
    func speak() -> String { return "Woof!" }
    // announce() is NOT written here -- it comes from the protocol extension automatically
}
let dog = Dog()
print(dog.speak())
print(dog.announce()) // uses the DEFAULT implementation from the protocol extension

// --- Classes support inheritance; structs do NOT ---
class Animal {
    let name: String
    init(name: String) { self.name = name }
    func makeSound() -> String { return "..." }
}
class Cat: Animal {
    override func makeSound() -> String { return "Meow!" } // `override` mandatory, like Kotlin
}
let animals: [Animal] = [Animal(name: "Generic"), Cat(name: "Whiskers")]
for a in animals { print("\(a.name) says \(a.makeSound())") }

// --- Enums with associated values -- richer than a plain C-style enum ---
enum NetworkResult {
    case success(data: String)
    case failure(code: Int, message: String)
}
func handle(_ result: NetworkResult) -> String {
    switch result {
    case .success(let data):
        return "Success: \(data)"
    case .failure(let code, let message):
        return "Failed [\(code)]: \(message)"
    }
}
print(handle(.success(data: "user data")))
print(handle(.failure(code: 404, message: "not found")))
