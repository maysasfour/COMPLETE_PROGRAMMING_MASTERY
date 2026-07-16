<?php
declare(strict_types=1);

namespace App\Tests;

use App\Calculator;
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Attributes\Test;
use PHPUnit\Framework\Attributes\DataProvider;

require_once __DIR__ . "/../src/Calculator.php"; // no autoloader configured -- manual require for this lesson

final class CalculatorTest extends TestCase {
    private Calculator $calc;

    protected function setUp(): void {
        $this->calc = new Calculator(); // runs before EVERY test method -- fresh instance each time
    }

    #[Test]
    public function addsTwoPositiveNumbers(): void {
        $this->assertSame(5, $this->calc->add(2, 3));
    }

    #[Test]
    public function addsNegativeNumbers(): void {
        $this->assertSame(-5, $this->calc->add(-2, -3));
    }

    // Data provider: PHPUnit's table-driven test mechanism, analogous to Go's table tests
    // or Rust's array-of-tuples loop, but expressed as a separate method PHPUnit calls
    // automatically once per data set, reporting each case as its own named result.
    public static function divisionCases(): array {
        return [
            "ten divided by two" => [10.0, 2.0, 5.0],
            "nine divided by three" => [9.0, 3.0, 3.0],
            "negative six divided by two" => [-6.0, 2.0, -3.0],
        ];
    }

    #[Test]
    #[DataProvider('divisionCases')]
    public function dividesCorrectly(float $a, float $b, float $expected): void {
        $this->assertSame($expected, $this->calc->divide($a, $b));
    }

    #[Test]
    public function divisionByZeroThrows(): void {
        $this->expectException(\InvalidArgumentException::class);
        $this->expectExceptionMessage("division by zero");
        $this->calc->divide(5.0, 0.0);
    }

    #[Test]
    #[DataProvider('palindromeCases')]
    public function detectsPalindromes(string $input, bool $expected): void {
        $this->assertSame($expected, $this->calc->isPalindrome($input));
    }

    public static function palindromeCases(): array {
        return [
            "racecar" => ["racecar", true],
            "phrase with spaces and case" => ["A man a plan a canal Panama", true],
            "not a palindrome" => ["hello", false],
            "empty string" => ["", true],
        ];
    }
}
