# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write tests using the `test` package — the official, Dart-team-maintained testing framework, added as a `dev_dependency`.
- Use `setUp()`, `expect()`/matchers (`equals`, `isTrue`, `throwsArgumentError`), and table-driven testing with Dart 3 record destructuring.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

The `test` package is Dart's official, team-maintained testing framework — not literally bundled into the SDK binary the way Swift's `XCTest` is, but published and maintained by the Dart team itself on pub.dev, and universally used as the de facto standard (comparable in spirit to Kotlin needing `kotlin-test` + a binding, or PHP needing a downloaded PHPUnit, both covered elsewhere in this repository, though `test` requires only a single, official, well-integrated dependency).

## Project Structure and `pubspec.yaml`

```yaml
name: testing_lesson
dev_dependencies:
  test: ^1.25.0
```

Convention places library code under `lib/` and tests under `test/`, with `dart test` discovering and running every `*_test.dart` file automatically.

## A `test` Package Test File

```dart
import 'package:test/test.dart';
import 'package:testing_lesson/calculator.dart';

void main() {
  late Calculator calc;

  setUp(() {
    calc = Calculator(); // runs before EVERY test
  });

  test('adds two positive numbers', () {
    expect(calc.add(2, 3), equals(5));
  });
}
```

Tests are plain functions passed to `test('description', () { ... })`, all registered inside a `main()` function — no annotation-based discovery (contrasted with JUnit 5/`kotlin.test`'s `@Test`, both covered elsewhere in this repository) or naming-convention discovery (contrasted with Swift's `XCTest`, also covered elsewhere) — instead, every test is explicitly registered by calling `test(...)` within `main()`.

## Table-Driven Testing with Record Destructuring

```dart
test('divides correctly', () {
  var cases = [(10.0, 2.0, 5.0), (9.0, 3.0, 3.0), (-6.0, 2.0, -3.0)];
  for (var (a, b, expected) in cases) {
    expect(calc.divide(a, b), equals(expected), reason: 'divide($a, $b) failed');
  }
});
```

## Testing Thrown Exceptions

```dart
test('division by zero throws', () {
  expect(() => calc.divide(5.0, 0.0), throwsArgumentError);
});
```

## Detailed Example

See [pubspec.yaml](pubspec.yaml), [lib/calculator.dart](lib/calculator.dart) (the code under test), and [test/calculator_test.dart](test/calculator_test.dart) (5 tests: two plain assertions, one table-driven division test using Dart 3 record destructuring, one thrown-error test, and one palindrome test covering four cases).

## Run It

```bash
cd 01-Languages/Dart/18-Testing
dart pub get
dart test
```

## Expected Output

Running `dart test` prints each test's description as it runs, ending with `All tests passed!` — confirmed by actual execution: all 5 tests passed.

## Common Mistakes

- Forgetting tests must be explicitly registered by calling `test(...)` inside `main()` — unlike annotation-based (JUnit 5/`kotlin.test`) or naming-convention-based (`XCTest`) discovery, both covered elsewhere in this repository, a function that's never passed to `test()` simply never runs, with no error or warning.
- Forgetting `setUp()` runs before *every* `test()` call in the same file — shared, accidentally-stateful fixtures across tests are a common source of order-dependent test failures if `setUp()` isn't used to reset state.
- Using a plain `for` loop without a `reason:` argument on `expect()` for table-driven tests — when one case out of many fails, a generic assertion-failure message doesn't say which case, unlike an `expect()` call with a descriptive `reason:`.

## Best Practices

- Use `setUp()` to reset test fixtures before every test, avoiding shared mutable state between tests.
- Use Dart 3 record destructuring (`for (var (a, b, expected) in cases)`) for concise, readable table-driven tests.
- Group related tests with `group('description', () { ... })` for better organization and more readable test-run output in larger test suites.

## Real-World Usage

The `test` package is the standard testing framework for essentially all real Dart and Flutter projects (Flutter additionally has `flutter_test` for widget-level testing, built on top of the same underlying conventions) — it's listed as a `dev_dependency` in virtually every real Dart `pubspec.yaml`, and `dart test`/`flutter test` are the standard CI commands for running a project's test suite.

## Summary

- The `test` package is Dart's official, team-maintained testing framework, added as a `dev_dependency`.
- Tests are explicitly registered via `test('description', () { ... })` inside `main()` — no annotation- or naming-convention-based discovery.
- `setUp()` resets fixtures before every test; `expect()` with matchers (`equals`, `isTrue`, `throwsArgumentError`) provides familiar assertion idioms.

## Key Terms

- **`test` package** — Dart's official, pub.dev-distributed testing framework.
- **`setUp()`** — a function run before every `test()` in the same file, used to reset fixtures.

## Interview Questions

1. **How does the `test` package's test-discovery mechanism differ from XCTest's or JUnit 5's, both covered elsewhere in this repository?**
   The `test` package requires every test to be explicitly registered by calling `test('description', () { ... })` inside the file's `main()` function — there's no automatic discovery based on annotations (like JUnit 5's `@Test` or `kotlin.test`'s `@Test`) or naming conventions (like Swift's `XCTest`, which recognizes any parameterless method starting with `test` inside an `XCTestCase` subclass). This means a function accidentally never passed to `test()` simply doesn't run as a test at all — there's no compiler warning or discovery mechanism that would catch this, since from the language's perspective it's just an unused function, not a malformed test.

2. **Why is a plain loop with Dart 3 record destructuring commonly used for table-driven tests instead of a dedicated parameterization feature?**
   The `test` package has no built-in "parameterized test" construct comparable to JUnit 5's `@ParameterizedTest`/`@CsvSource` or PHPUnit's `#[DataProvider]` (both covered elsewhere in this repository) — instead, idiomatic Dart testing uses a plain `List` of tuples/records looped over inside a single `test()` block, with `expect()`'s optional `reason:` parameter supplying a per-case failure message. This mirrors the same array-of-tuples pattern used in this repository's Rust, Kotlin, and Swift courses' testing lessons, and Dart 3's record destructuring syntax (`for (var (a, b, expected) in cases)`) makes this pattern especially concise and readable compared to manually indexing into tuple/list elements.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
