// Example.swift - closures capturing by reference (like Kotlin, can mutate captured
// variables -- unlike Java's effectively-final restriction), capture lists ([weak self],
// a preview of ARC/retain-cycle concerns covered in Lesson 13), function composition,
// and higher-order functions.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// --- Closures capture variables by REFERENCE, and CAN mutate them -- like Kotlin, unlike Java ---
func makeCounter() -> () -> Int {
    var count = 0 // captured by reference
    return {
        count += 1 // genuinely mutates the captured variable
        return count
    }
}
let counter = makeCounter()
print(counter()) // 1
print(counter()) // 2
print(counter()) // 3 -- state persists across calls, since the closure holds a live reference

let counter2 = makeCounter() // a SEPARATE closure has its OWN captured state
print(counter2()) // 1 -- independent from `counter`

// --- Function composition ---
func compose(_ f: @escaping (Int) -> Int, _ g: @escaping (Int) -> Int) -> (Int) -> Int {
    return { x in f(g(x)) }
}
let addOne: (Int) -> Int = { $0 + 1 }
let square: (Int) -> Int = { $0 * $0 }
let addThenSquare = compose(square, addOne)
print(addThenSquare(4)) // (4+1)^2 = 25

// --- Capture lists: [weak self] -- a preview of Lesson 13's ARC/retain-cycle discussion ---
class Logger {
    var prefix: String
    init(prefix: String) { self.prefix = prefix }

    // Without [weak self], a closure stored on self (or passed somewhere long-lived) that
    // captures `self` strongly can create a RETAIN CYCLE under ARC -- self and the closure
    // keep each other alive forever, leaking memory. [weak self] breaks the cycle.
    func makeLogFunction() -> () -> Void {
        return { [weak self] in
            guard let self = self else { return } // self may have been deallocated
            print("\(self.prefix): logging")
        }
    }
}
let logger = Logger(prefix: "APP")
let logFn = logger.makeLogFunction()
logFn()

// --- Higher-order functions with map/filter/reduce (recap, using functions not just closures) ---
func isEven(_ n: Int) -> Bool { return n % 2 == 0 }
let nums = [1, 2, 3, 4, 5, 6]
print(nums.filter(isEven)) // passing a named function directly, like Kotlin's ::isEven
