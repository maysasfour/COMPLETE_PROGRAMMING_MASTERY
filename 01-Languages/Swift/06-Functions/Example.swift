// Example.swift - argument labels (external name) vs parameter names (internal name) --
// a genuinely distinctive Swift feature not present in this repository's other languages --
// default values, variadic parameters, inout parameters, and closures.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// --- Argument labels: the EXTERNAL name (used at the call site) vs the INTERNAL name
// (used inside the function body) can be DIFFERENT -- unique among this repository's languages.
func greet(person name: String, greeting: String = "Hello") -> String {
    // "person" is the external label (used by callers); "name" is the internal parameter name
    return "\(greeting), \(name)!"
}
print(greet(person: "Ada"))                     // call site uses "person:", the external label
print(greet(person: "Grace", greeting: "Hi"))

// --- Omitting the external label entirely with _ ---
func multiply(_ a: Int, by b: Int) -> Int {
    return a * b // call site: multiply(3, by: 4) -- no label needed for `a`, "by" labels `b`
}
print(multiply(3, by: 4))

// --- Variadic parameters ---
func sum(_ numbers: Int...) -> Int {
    return numbers.reduce(0, +)
}
print(sum(1, 2, 3, 4))

// --- inout parameters: explicit, visible mutation of the caller's variable ---
func increment(_ n: inout Int) {
    n += 1
}
var counter = 5
increment(&counter) // the & sigil is REQUIRED at the call site, making mutation visible there too
print("counter after increment: \(counter)")

// --- Closures: full syntax, shorthand, and trailing closure syntax ---
let multiplier: (Int) -> Int = { x in x * 3 } // full closure syntax
print(multiplier(5))

func applyTwice(_ x: Int, _ f: (Int) -> Int) -> Int {
    return f(f(x))
}
print(applyTwice(2) { $0 * 2 }) // trailing closure syntax + $0 shorthand argument name

// --- map/filter/reduce with closures ---
let doubled = [1, 2, 3].map { $0 * 2 }
print(doubled)
