// The (tiny) module under test for this lesson's MUnit suite.
object Calculator:
  def add(a: Int, b: Int): Int = a + b
  def divide(a: Int, b: Int): Int =
    if b == 0 then throw ArithmeticException("cannot divide by zero")
    else a / b
  def isEven(n: Int): Boolean = n % 2 == 0
