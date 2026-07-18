// solution-03.swift -- Exercise 03: Protocol Extensions and Retroactive Conformance

protocol Summable {
    static func + (lhs: Self, rhs: Self) -> Self
    static var zero: Self { get }
}

extension Summable {
    // A default implementation every conformer gets "for free" -- it only relies on
    // `+` and `.zero`, both required by the protocol, so it never needs to know
    // anything conformer-specific.
    func summed(with others: [Self]) -> Self {
        others.reduce(self) { $0 + $1 }
    }
}

// Retroactive conformance: `Int` and `Double` already provide `+` via the standard
// library, so the ONLY thing each needs to add is `.zero` -- `summed(with:)` itself
// is inherited from the protocol extension with no Int-specific or Double-specific code.
extension Int: Summable {
    static var zero: Int { 0 }
}
extension Double: Summable {
    static var zero: Double { 0.0 }
}

struct Money: Summable, CustomStringConvertible {
    var amount: Double

    static func + (lhs: Money, rhs: Money) -> Money {
        Money(amount: lhs.amount + rhs.amount)
    }
    static var zero: Money { Money(amount: 0.0) }
    var description: String { "$\(amount)" }
}

print("--- Int (retroactive conformance) ---")
let intSum = 10.summed(with: [20, 30, 40])
print("10.summed(with: [20, 30, 40]) = \(intSum)")

print("\n--- Double (retroactive conformance) ---")
let doubleSum = 1.5.summed(with: [2.5, 3.0])
print("1.5.summed(with: [2.5, 3.0]) = \(doubleSum)")

print("\n--- Money (custom type, no Money-specific summed) ---")
let moneyValues = [Money(amount: 10.0), Money(amount: 5.5), Money(amount: 2.25)]
let total = Money.zero.summed(with: moneyValues)
print("Money.zero.summed(with: moneyValues) = \(total)")
