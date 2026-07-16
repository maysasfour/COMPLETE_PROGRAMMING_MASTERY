public struct Calculator {
    public init() {}

    public func add(_ a: Int, _ b: Int) -> Int { return a + b }

    public enum CalculatorError: Error, Equatable {
        case divisionByZero
    }

    public func divide(_ a: Double, _ b: Double) throws -> Double {
        if b == 0 { throw CalculatorError.divisionByZero }
        return a / b
    }

    public func isPalindrome(_ s: String) -> Bool {
        let cleaned = s.lowercased().filter { $0.isLetter || $0.isNumber }
        return cleaned == String(cleaned.reversed())
    }
}
