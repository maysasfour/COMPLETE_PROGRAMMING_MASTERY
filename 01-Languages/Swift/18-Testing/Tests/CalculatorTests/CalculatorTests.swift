// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.
import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {
    var calc: Calculator! // implicitly-unwrapped Optional: nil until setUp runs, then always used non-nil

    override func setUp() {
        super.setUp()
        calc = Calculator() // runs before EVERY test method -- fresh instance each time
    }

    func testAddsTwoPositiveNumbers() {
        XCTAssertEqual(calc.add(2, 3), 5)
    }

    func testAddsNegativeNumbers() {
        XCTAssertEqual(calc.add(-2, -3), -5)
    }

    // Table-driven style: an array of tuples, looped over manually -- XCTest doesn't have
    // a distinct "parameterized test" attribute the way JUnit5/PHPUnit do, so a plain loop
    // is the idiomatic Swift/XCTest approach, mirroring the Rust course's array-of-tuples pattern.
    func testDividesCorrectly() throws {
        let cases: [(Double, Double, Double)] = [
            (10.0, 2.0, 5.0),
            (9.0, 3.0, 3.0),
            (-6.0, 2.0, -3.0),
        ]
        for (a, b, expected) in cases {
            let result = try calc.divide(a, b)
            XCTAssertEqual(result, expected, "divide(\(a), \(b)) failed")
        }
    }

    func testDivisionByZeroThrows() {
        XCTAssertThrowsError(try calc.divide(5.0, 0.0)) { error in
            XCTAssertEqual(error as? Calculator.CalculatorError, .divisionByZero)
        }
    }

    func testDetectsPalindromes() {
        XCTAssertTrue(calc.isPalindrome("racecar"))
        XCTAssertTrue(calc.isPalindrome("A man a plan a canal Panama"))
        XCTAssertFalse(calc.isPalindrome("hello"))
        XCTAssertTrue(calc.isPalindrome(""))
    }
}
