// A real MUnit test suite -- MUnit was obtained via Coursier (org.scalameta:munit_3:1.0.0)
// and IS used here, since it was successfully obtainable (see README for why a standalone
// runner, rather than sbt's `test` task, is used to execute it in this dependency-minimal course).
class CalculatorSuite extends munit.FunSuite:

  test("add: two positive numbers") {
    assertEquals(Calculator.add(2, 3), 5)
  }

  test("add: negative numbers") {
    assertEquals(Calculator.add(-2, -3), -5)
  }

  test("divide: exact division") {
    assertEquals(Calculator.divide(10, 2), 5)
  }

  test("divide: by zero throws ArithmeticException") {
    intercept[ArithmeticException] {
      Calculator.divide(1, 0)
    }
  }

  test("isEven: true for even numbers") {
    assert(Calculator.isEven(4))
  }

  test("isEven: false for odd numbers") {
    assert(!Calculator.isEven(5))
  }
