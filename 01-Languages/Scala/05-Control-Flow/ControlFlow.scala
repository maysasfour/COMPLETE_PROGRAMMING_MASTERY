// ControlFlow.scala - if as an expression, match with type/guard/tuple patterns,
// and for loops vs for-yield comprehensions.

def describe(x: Any): String = x match
  case 0                 => "zero"
  case n: Int if n > 0   => s"positive int $n"
  case s: String         => s"a string of length ${s.length}"
  case (a, b)             => s"a pair: $a, $b"
  case _                  => "something else"

@main def controlFlowDemo(): Unit =
  val n = 5
  val category = if n > 0 then "positive" else if n < 0 then "negative" else "zero"
  println(s"if-expression: $n is $category")

  println(s"match: 0 -> ${describe(0)}")
  println(s"match: 7 -> ${describe(7)}")
  println(s"match: hi -> ${describe("hi")}")
  println(s"match: (1,2) -> ${describe((1, 2))}")
  println(s"match: 3.14 -> ${describe(3.14)}")

  print("for loop: ")
  for i <- 1 to 3 do print(s"$i ")
  println()

  val squares = for i <- 1 to 3 yield i * i
  println(s"for-yield squares: ${squares.toList}")
