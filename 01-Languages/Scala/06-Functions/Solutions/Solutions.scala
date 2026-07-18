// Solutions.scala - 06 Functions exercise solutions, actually compiled and run.

def power(base: Int)(exp: Int): Int =
  math.pow(base.toDouble, exp.toDouble).toInt

def formatMoney(amount: Double, currency: String = "USD"): String =
  f"$currency $amount%.2f"

def applyTwice(f: Int => Int, x: Int): Int =
  f(f(x))

@main def solutionsDemo(): Unit =
  println(s"power(2)(10) = ${power(2)(10)}")
  println(formatMoney(19.99))
  println(formatMoney(50, "EUR"))
  println(s"applyTwice(_ + 3, 10) = ${applyTwice(_ + 3, 10)}")
