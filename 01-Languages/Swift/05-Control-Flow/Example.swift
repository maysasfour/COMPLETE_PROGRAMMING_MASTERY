// Example.swift - if/else, switch (NO fall-through by default -- opposite of C/Java/JS,
// matching Go's design choice covered earlier in this repository), pattern matching with
// ranges/tuples/where clauses, and loops.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

let score = 85
let grade: String
if score >= 90 {
    grade = "A"
} else if score >= 80 {
    grade = "B"
} else {
    grade = "C or below"
}
print("grade: \(grade)")

// --- switch: NO fall-through by default (like Go, unlike C/Java/JS) ---
let day = 3
switch day {
case 1, 2, 3, 4, 5: // comma-separated values in one case, no fall-through to the next case
    print("Weekday")
case 6, 7:
    print("Weekend")
default: // `default` is REQUIRED unless the compiler can prove exhaustiveness (e.g. an enum)
    print("Invalid day")
}

// --- switch with ranges and `where` clauses -- much more powerful than C-style switch ---
let temp = 75
switch temp {
case ..<32:
    print("freezing")
case 32...60:
    print("cold")
case 61...80 where temp % 2 == 0: // `where` adds an extra condition to a case
    print("mild and even")
case 61...80:
    print("mild")
default:
    print("hot")
}

// --- switch on a tuple, with pattern matching ---
let point = (2, 0)
switch point {
case (0, 0):
    print("origin")
case (_, 0):
    print("on the x-axis") // _ matches any value in that position
case (0, _):
    print("on the y-axis")
default:
    print("elsewhere")
}

// --- Explicit fallthrough IS available, but must be requested explicitly ---
switch 1 {
case 1:
    print("one")
    fallthrough // explicitly opts INTO fall-through -- the opposite of C's default behavior
case 2:
    print("also prints because of fallthrough")
default:
    break
}

// --- Loops ---
for i in 0..<3 { print("for: \(i)") }
var i = 0
while i < 3 { print("while: \(i)"); i += 1 }
let letters = ["a", "b", "c"]
for (index, letter) in letters.enumerated() { print("indexed: \(index) -> \(letter)") }
