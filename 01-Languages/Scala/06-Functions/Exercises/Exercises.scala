// Exercises.scala - 06 Functions
//
// 1. Write `power(base: Int)(exp: Int): Int` (curried) computing base^exp.
// 2. Write `formatMoney(amount: Double, currency: String = "USD"): String` using a
//    default parameter, returning e.g. "USD 19.99".
// 3. Write a higher-order function `applyTwice(f: Int => Int, x: Int): Int` that
//    applies `f` to `x` twice.

def power(base: Int)(exp: Int): Int =
  ??? // TODO

def formatMoney(amount: Double, currency: String = "USD"): String =
  ??? // TODO

def applyTwice(f: Int => Int, x: Int): Int =
  ??? // TODO

@main def exercisesDemo(): Unit =
  println("Implement the TODOs above, then compare against Solutions/Solutions.scala")
