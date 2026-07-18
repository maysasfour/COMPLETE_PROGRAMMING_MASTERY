// Solutions.scala - 05 Control Flow exercise solutions, actually compiled and run.

def fizzbuzz(n: Int): String = n match
  case n if n % 15 == 0 => "FizzBuzz"
  case n if n % 3 == 0  => "Fizz"
  case n if n % 5 == 0  => "Buzz"
  case n                 => n.toString

def gradeOf(score: Int): String = score match
  case s if s >= 90 => "A"
  case s if s >= 80 => "B"
  case s if s >= 70 => "C"
  case _              => "F"

def evenSquares(): List[Int] =
  (for i <- 1 to 10 if i % 2 == 0 yield i * i).toList

@main def solutionsDemo(): Unit =
  println((1 to 15).map(fizzbuzz).mkString(", "))
  println(List(95, 82, 71, 40).map(gradeOf))
  println(evenSquares())
