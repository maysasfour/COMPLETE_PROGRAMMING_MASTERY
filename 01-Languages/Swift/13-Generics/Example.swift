// Example.swift - generic functions/types with `where` clauses, and protocols with
// associated types (a genuinely powerful Swift feature, comparable to Rust's traits with
// associated types, covered earlier in this repository -- more expressive than Java's
// erasure-based generics or even Kotlin's declaration-site variance).
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

// --- Generic function with a type constraint ---
func maxOf<T: Comparable>(_ a: T, _ b: T) -> T {
    return a > b ? a : b
}
print(maxOf(3, 7))
print(maxOf("apple", "banana"))

// --- Generic struct ---
struct Stack<Element> {
    private var items: [Element] = []
    mutating func push(_ item: Element) { items.append(item) } // `mutating` required -- struct value type!
    mutating func pop() -> Element? { return items.popLast() }
}
var intStack = Stack<Int>()
intStack.push(1)
intStack.push(2)
print(intStack.pop() ?? -1) // 2

// --- Protocols with associated types: a genuinely powerful generics mechanism ---
protocol Container {
    associatedtype Item // a PLACEHOLDER type, filled in by whatever conforms to this protocol
    mutating func add(_ item: Item)
    var count: Int { get }
}

struct IntContainer: Container {
    private var items: [Int] = []
    mutating func add(_ item: Int) { items.append(item) } // Item is inferred as Int here
    var count: Int { items.count }
}

func describe<C: Container>(_ container: C) -> String {
    return "container with \(container.count) items"
}
var ic = IntContainer()
ic.add(1)
ic.add(2)
ic.add(3)
print(describe(ic))

// --- where clauses for more specific generic constraints ---
func allEqual<T: Equatable>(_ items: [T]) -> Bool where T: Equatable {
    guard let first = items.first else { return true }
    return items.allSatisfy { $0 == first }
}
print(allEqual([1, 1, 1]))  // true
print(allEqual([1, 2, 1]))  // false
