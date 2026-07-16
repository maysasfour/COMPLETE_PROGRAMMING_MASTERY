# 18 — Testing

[Back to course overview](../README.md) | [Previous: API Integration](../17-API-Integration/README.md)

## Learning Objectives

- Write and run tests with PHPUnit, PHP's de facto standard testing framework (downloaded as a standalone `.phar`, not bundled with the language — unlike Go's built-in `testing` package).
- Use PHPUnit's data providers for table-driven tests, and `expectException()` for testing thrown exceptions.
- Understand `setUp()`, run automatically before every test method.

## Prerequisites

[17-API-Integration](../17-API-Integration/README.md)

## Concept

Unlike Go (built-in `testing`) or Rust (built-in `#[test]`), PHP has **no built-in testing framework** — PHPUnit is the de facto standard, distributed as a standalone `.phar` (PHP Archive) file that can be downloaded and run directly with no Composer install required, similar to how this repository's Java course used a downloaded JUnit Platform Console Standalone JAR, and the C++ course used a downloaded Catch2 amalgamated header.

## A PHPUnit Test Class

```php
final class CalculatorTest extends TestCase {
    private Calculator $calc;

    protected function setUp(): void {
        $this->calc = new Calculator(); // runs before EVERY test method -- fresh state each time
    }

    #[Test]
    public function addsTwoPositiveNumbers(): void {
        $this->assertSame(5, $this->calc->add(2, 3));
    }
}
```

`setUp()` runs automatically before each test method, providing a fresh `Calculator` instance per test — ensuring tests don't share mutable state. `#[Test]` (PHP 8+ attribute syntax) marks a method as a test case (PHPUnit also recognizes methods simply named with a `test` prefix, an older convention still widely used).

## Data Providers: PHPUnit's Table-Driven Tests

```php
public static function divisionCases(): array {
    return [
        "ten divided by two" => [10.0, 2.0, 5.0],
        "nine divided by three" => [9.0, 3.0, 3.0],
    ];
}

#[Test]
#[DataProvider('divisionCases')]
public function dividesCorrectly(float $a, float $b, float $expected): void {
    $this->assertSame($expected, $this->calc->divide($a, $b));
}
```

A data provider is a static method returning an array of argument sets; PHPUnit calls the test method once per entry, reporting each as a separately-named result (visible in `--testdox` output as "Divides correctly with data set..."). This is functionally the same idea as Go's table-driven tests or Rust's array-of-tuples loop from earlier in this repository, but implemented as a distinct, framework-recognized mechanism rather than a manual loop inside the test body.

## Testing Thrown Exceptions

```php
#[Test]
public function divisionByZeroThrows(): void {
    $this->expectException(\InvalidArgumentException::class);
    $this->expectExceptionMessage("division by zero");
    $this->calc->divide(5.0, 0.0);
}
```

## Detailed Example

See [src/Calculator.php](src/Calculator.php) (the code under test) and [tests/CalculatorTest.php](tests/CalculatorTest.php) (10 tests: two plain assertions, three data-provider-driven division cases, one exception test, and four data-provider-driven palindrome cases).

## Run It

```bash
cd 01-Languages/PHP/18-Testing
# Download PHPUnit's standalone .phar (not committed to the repo, like a downloaded JAR):
curl -sSL -o phpunit.phar https://phar.phpunit.de/phpunit-11.phar
php phpunit.phar --testdox tests/CalculatorTest.php
```

## Expected Output

Running the command above prints `10 / 10 (100%)`, then a `--testdox` breakdown listing all 10 tests (including each data-provider case by its named key, e.g. "Divides correctly with data set 'ten divided by two'"), ending with `OK (10 tests, 11 assertions)`.

## Common Mistakes

- Assuming PHP ships a testing framework the way Go or Rust do — it doesn't; PHPUnit (or an alternative like Pest) must be installed separately, typically via Composer in a real project (or downloaded directly as a `.phar`, as shown here for an install-free lesson).
- Sharing a single test-fixture instance across multiple test methods instead of recreating it in `setUp()` — this can let one test's mutations leak into another, an especially important discipline for classes involving mutable state.
- Forgetting `expectException()` must be called **before** the code that's expected to throw — calling it after would never actually verify anything, since execution stops at the throwing line.

## Best Practices

- Use data providers (`#[DataProvider('methodName')]`) for any test exercising the same logic across multiple input/output pairs, rather than duplicating near-identical test methods.
- Reset test fixtures in `setUp()` rather than relying on class-level static state across tests.
- Name data provider array keys descriptively (as shown) — they appear directly in test-runner output, making failures immediately identifiable by case.

## Real-World Usage

PHPUnit (or increasingly, the more expressive Pest, itself built on PHPUnit) is the standard testing framework across the PHP ecosystem — Laravel and Symfony both ship first-class PHPUnit integration, and PHPUnit is virtually always installed via Composer's `require-dev` in real projects rather than downloaded as a standalone `.phar` the way this install-free lesson demonstrates.

## Summary

- PHP has no built-in testing framework; PHPUnit is the de facto standard, downloadable as a standalone `.phar` for install-free use.
- `setUp()` runs before every test method, providing fresh fixture state.
- Data providers implement PHPUnit's version of table-driven testing, reporting each case by name.
- `expectException()`/`expectExceptionMessage()` verify a specific exception is thrown.

## Key Terms

- **PHPUnit** — PHP's de facto standard testing framework, not part of the language core.
- **Data provider** — a static method supplying multiple argument sets to a single test method, PHPUnit's table-driven-testing mechanism.

## Interview Questions

1. **Does PHP have a built-in testing framework the way Go has `testing` or Rust has `#[test]`?**
   No — PHP's standard library has no testing framework at all. PHPUnit has become the de facto standard through community adoption (and is what virtually every major PHP framework, including Laravel and Symfony, integrates with directly), but it's an external dependency, not part of the language core. It's typically installed via Composer in real projects, though it can also be downloaded and run as a standalone `.phar` file with no Composer install at all, as demonstrated in this lesson.

2. **What does a PHPUnit data provider do, and how does it compare to Go's table-driven test pattern?**
   A data provider is a static method returning an array of argument sets; PHPUnit automatically calls the associated test method once for each entry, treating each as an independently-reported test result (identifiable by the array's key, if named). This achieves the same underlying goal as Go's table-driven tests (looping over a slice of input/expected-output structs) or Rust's array-of-tuples loop from earlier in this repository, but as a framework-level feature with dedicated reporting per case, rather than a single test iterating manually over cases in one loop body with a single overall pass/fail result.

## Recommended Next Lesson

[19 — Best Practices](../19-Best-Practices/README.md)
