# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

> **Not compiled/run** — see [Lesson 01](../01-Setup/README.md) and the [course README](../README.md) for the disclosed reason.

## Learning Objectives

- Use `XCTest` — Swift's built-in testing framework, bundled with the toolchain (unlike Kotlin/PHP/Java, all of which needed a separately downloaded testing library in their own courses).
- Structure a test target via Swift Package Manager (`Package.swift`, Lesson 15) and use `setUp()`, `XCTAssertEqual`, `XCTAssertThrowsError`.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

`XCTest` is Swift's testing framework, bundled directly with the Swift toolchain and Xcode — no separate download or dependency needed, a genuine convenience contrasted with this repository's Kotlin course (needed `kotlin-test` + a JUnit 5 binding + the JUnit console launcher, all downloaded separately), PHP course (needed a downloaded PHPUnit `.phar`), and Java course (needed a downloaded JUnit Platform Console Standalone JAR).

## SPM Test Target Structure

```swift
// Package.swift
let package = Package(
    name: "Calculator",
    targets: [
        .target(name: "Calculator"),
        .testTarget(name: "CalculatorTests", dependencies: ["Calculator"]),
    ]
)
```

A Swift Package Manager project (Lesson 15) conventionally places library code under `Sources/<TargetName>/` and tests under `Tests/<TargetName>Tests/`, with `swift test` building and running the test target automatically.

## An `XCTest` Test Class

```swift
import XCTest
@testable import Calculator // @testable exposes internal (non-public) declarations to the test target

final class CalculatorTests: XCTestCase {
    var calc: Calculator!

    override func setUp() {
        super.setUp()
        calc = Calculator() // runs before EVERY test method
    }

    func testAddsTwoPositiveNumbers() {
        XCTAssertEqual(calc.add(2, 3), 5)
    }
}
```

Test methods must be named starting with `test` and take no parameters — `XCTest` discovers them by this naming convention (reflection-based), rather than requiring an explicit `@Test` annotation the way JUnit 5/`kotlin.test`/PHPUnit do (all covered in this repository's other courses).

## Table-Driven Testing and Testing Thrown Errors

```swift
func testDividesCorrectly() throws {
    let cases: [(Double, Double, Double)] = [(10.0, 2.0, 5.0), (9.0, 3.0, 3.0)]
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
```

## Detailed Example

See [Package.swift](Package.swift), [Sources/Calculator/Calculator.swift](Sources/Calculator/Calculator.swift) (the code under test), and [Tests/CalculatorTests/CalculatorTests.swift](Tests/CalculatorTests/CalculatorTests.swift) (5 tests: two plain assertions, one table-driven division test, one thrown-error test, and one palindrome test covering four cases).

## Run It

```bash
cd 01-Languages/Swift/18-Testing
swift test
```

**Not verified by execution in this course** — see the honesty note above.

## Expected Output

Running `swift test` should build the package and print a summary of all 5 tests passing (`Test Suite 'All tests' passed` or similar `XCTest` console output), with `testDividesCorrectly` internally validating all three of its table-driven cases.

## Common Mistakes

- Naming a test method without the `test` prefix — `XCTest` discovers tests by this naming convention; a method named `checkAddition()` instead of `testAddition()` simply won't run as a test at all, with no compile error or warning.
- Forgetting `@testable import` when a test needs access to `internal` (non-`public`) declarations in the module under test — without it, only `public` API is visible to the test target.
- Forgetting `super.setUp()` when overriding `setUp()` — while often harmless for simple cases, it's the conventional, correct pattern to call the superclass implementation.

## Best Practices

- Use `@testable import` to test internal implementation details without needing to mark everything `public` just for testability.
- Reset test fixtures in `setUp()` (or the newer `setUpWithError() throws` variant) rather than relying on shared state across tests.
- Use plain arrays of tuples for table-driven tests, mirroring the same pattern used in this repository's Rust and Kotlin courses, since `XCTest` has no dedicated parameterized-test attribute.

## Real-World Usage

`XCTest` (and increasingly, the newer Swift Testing framework introduced alongside Swift 6) is the standard testing framework for essentially all real Swift/iOS/macOS development — being bundled directly with the toolchain and deeply integrated with Xcode's test navigator and CI tooling makes it the default choice with no setup friction, unlike the external testing libraries needed in several other languages covered in this repository.

## Summary

- `XCTest` is bundled directly with the Swift toolchain — no separate download needed, a genuine convenience over Kotlin/PHP/Java's testing setups covered in this repository.
- Test methods are discovered by the `test`-prefix naming convention, not an explicit annotation.
- `setUp()` resets fixtures before every test; `XCTAssertEqual`/`XCTAssertThrowsError` provide familiar assertion idioms.

## Key Terms

- **`XCTest`** — Swift's built-in testing framework, bundled with the toolchain.
- **`@testable import`** — exposes a module's internal (non-public) declarations to a test target.

## Interview Questions

1. **How does `XCTest`'s test discovery mechanism differ from JUnit 5's or `kotlin.test`'s, both covered elsewhere in this repository?**
   `XCTest` discovers test methods purely by naming convention: any parameterless method whose name starts with `test` inside an `XCTestCase` subclass is automatically treated as a test case, with no explicit annotation required. JUnit 5 (used in this repository's Java course) and `kotlin.test` (used in the Kotlin course) instead require an explicit `@Test` annotation on each test method — a method without it simply isn't recognized as a test, regardless of its name. `XCTest`'s convention-based approach means a typo in the `test` prefix (e.g., naming a method `tset...`) silently causes that method to be skipped entirely, with no error or warning, a genuine trade-off for its simpler, annotation-free syntax.

2. **What does `@testable import` provide, and why is it useful when writing Swift tests?**
   Normally, importing a module only exposes its `public` (and `open`) API (Lesson 15's access control levels) — anything `internal` or more restrictive is invisible to code outside that module, including a separate test target. `@testable import ModuleName` relaxes this specifically for testing purposes, exposing `internal`-level declarations to the importing test file as well. This lets test code exercise a module's internal implementation details directly, without needing to mark everything `public` purely for the sake of testability — a genuine convenience for writing thorough unit tests without weakening a module's real, intended public API surface.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
