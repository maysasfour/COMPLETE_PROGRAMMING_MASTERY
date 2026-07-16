import 'package:test/test.dart';
import 'package:testing_lesson/calculator.dart';

void main() {
  late Calculator calc; // late: promised non-null, initialized in setUp before every test (Lesson 03)

  setUp(() {
    calc = Calculator(); // runs before EVERY test -- fresh instance each time
  });

  test('adds two positive numbers', () {
    expect(calc.add(2, 3), equals(5));
  });

  test('adds negative numbers', () {
    expect(calc.add(-2, -3), equals(-5));
  });

  // Table-driven style: a plain list of records, looped over manually -- the `test` package
  // has no distinct "parameterized test" attribute, so a plain loop (or nested group()) is
  // the idiomatic approach, mirroring the pattern used in this repository's Rust/Kotlin/Swift courses.
  test('divides correctly', () {
    var cases = [(10.0, 2.0, 5.0), (9.0, 3.0, 3.0), (-6.0, 2.0, -3.0)];
    for (var (a, b, expected) in cases) {
      expect(calc.divide(a, b), equals(expected), reason: 'divide($a, $b) failed');
    }
  });

  test('division by zero throws', () {
    expect(() => calc.divide(5.0, 0.0), throwsArgumentError);
  });

  test('detects palindromes', () {
    expect(calc.isPalindrome('racecar'), isTrue);
    expect(calc.isPalindrome('A man a plan a canal Panama'), isTrue);
    expect(calc.isPalindrome('hello'), isFalse);
    expect(calc.isPalindrome(''), isTrue);
  });
}
