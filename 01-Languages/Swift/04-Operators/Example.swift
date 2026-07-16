// Example.swift - arithmetic, no implicit numeric conversion, ranges, == is structural for
// value types automatically (via Equatable), custom operator overloading.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// --- Arithmetic: no implicit numeric conversion, like Rust and Kotlin ---
let intValue: Int = 5
let doubleValue: Double = 2.5
// let sum = intValue + doubleValue // COMPILE ERROR: binary operator '+' cannot be applied
let sum = Double(intValue) + doubleValue // explicit conversion required
print("sum: \(sum)")

print(2 * 10) // 20
print(10 / 3)   // 3 -- integer division truncates, like most languages
print(10.0 / 3.0) // 3.3333333333333335
print(10 % 3)      // 1

// --- Ranges ---
for i in 1...5 { print("closed range: \(i)", terminator: " ") } // 1...5 -- INCLUDES 5
print()
for i in 1..<5 { print("half-open range: \(i)", terminator: " ") } // 1..<5 -- EXCLUDES 5
print()
for i in stride(from: 1, through: 10, by: 3) { print("stride: \(i)", terminator: " ") }
print()

// --- Structs get == for FREE if they declare Equatable conformance (structural equality) ---
struct Point: Equatable {
    let x: Int
    let y: Int
}
let p1 = Point(x: 1, y: 2)
let p2 = Point(x: 1, y: 2)
print("p1 == p2: \(p1 == p2)") // true -- Equatable auto-synthesizes memberwise structural equality

// --- Custom operator overloading ---
struct Vector2D {
    let x: Double
    let y: Double
    static func + (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
let v = Vector2D(x: 1, y: 2) + Vector2D(x: 3, y: 4)
print("v: (\(v.x), \(v.y))")

// --- Logical operators ---
print(true && false)
print(true || false)
print(!true)
