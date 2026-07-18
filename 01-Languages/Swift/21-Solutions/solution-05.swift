// solution-05.swift -- Exercise 05: Generic Stack<Element> with a Protocol Constraint

struct Stack<Element> {
    private var items: [Element] = []

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element? {
        items.popLast()
    }

    func peek() -> Element? {
        items.last
    }

    var isEmpty: Bool { items.isEmpty }
    var count: Int { items.count }
}

// This extension only exists for `Stack`s whose `Element` conforms to `Equatable` --
// a `Stack<SomeNonEquatableType>` simply doesn't gain a `.contains(_:)` method at all,
// enforced entirely at compile time via the generic constraint below.
extension Stack where Element: Equatable {
    func contains(_ item: Element) -> Bool {
        items.contains(item)
    }
}

print("--- Stack<Int> (Int: Equatable) ---")
var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)

let popped = stack.pop()
print("pop() -> \(popped.map(String.init) ?? "nil") (expected 3, LIFO order)")

print("contains(2) -> \(stack.contains(2))") // only compiles because Int: Equatable
print("final count -> \(stack.count)")

// --- Compile-time constraint proof (documented, not left in as live code) ---
// A non-Equatable type was tried against a scratch copy of this file:
//
//     struct NotEquatable {}
//     var badStack = Stack<NotEquatable>()
//     badStack.push(NotEquatable())
//     _ = badStack.contains(NotEquatable())
//
// This failed to COMPILE with:
//     error: referencing instance method 'contains' on 'Stack' requires that
//     'NotEquatable' conform to 'Equatable'
// -- proving the constraint is enforced statically, before the program ever runs, not
// as a runtime surprise the way an unconstrained generic (or a language without
// constrained extensions) might allow.
