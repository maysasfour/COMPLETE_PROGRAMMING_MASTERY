// Solution 3 -- safe division pipeline (Lesson 09)

def safeDivide(a: Double, b: Double): Either[String, Double] =
  if b == 0 then Left("division by zero") else Right(a / b)

def chain(inputs: List[(Double, Double)]): Either[String, List[Double]] =
  inputs.foldLeft[Either[String, List[Double]]](Right(Nil)) { (accEither, pair) =>
    for
      acc <- accEither
      result <- safeDivide(pair._1, pair._2)
    yield acc :+ result
  }

@main def solution3SafeDivision(): Unit =
  val goodInputs = List((10.0, 2.0), (9.0, 3.0), (100.0, 4.0))
  println(s"chain(goodInputs) = ${chain(goodInputs)}")

  val badInputs = List((10.0, 2.0), (5.0, 0.0), (100.0, 4.0))
  println(s"chain(badInputs)  = ${chain(badInputs)}")
