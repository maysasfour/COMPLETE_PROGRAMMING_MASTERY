// ErrorHandling.scala - try/catch/finally as an expression, a custom exception, and the
// idiomatic functional alternative: Option, Either, and Try.

import scala.util.{Try, Success, Failure}

class InsufficientFundsException(val shortfall: Double)
    extends Exception(s"insufficient funds, short by $shortfall")

def divide(a: Double, b: Double): Double =
  if b == 0.0 then throw new ArithmeticException(s"cannot divide $a by zero") else a / b

def withdraw(balance: Double, amount: Double): Double =
  if amount > balance then throw new InsufficientFundsException(amount - balance)
  else balance - amount

// Option: absence as a type, no null anywhere.
def findUser(id: Int): Option[String] =
  if id == 1 then Some("Ada") else None

// Either: a typed success/failure result, carrying WHY it failed on the Left.
def parseAge(input: String): Either[String, Int] =
  input.toIntOption match
    case Some(n) if n >= 0 => Right(n)
    case Some(_)             => Left(s"age cannot be negative: $input")
    case None                => Left(s"not a number: $input")

@main def errorHandlingDemo(): Unit =
  println("--- try/catch/finally, and try AS AN EXPRESSION ---")
  val result: Double =
    try divide(10.0, 0.0)
    catch case e: ArithmeticException => -1.0
    finally println("finally always runs")
  println(s"result: $result")

  println("\n--- custom exception ---")
  try withdraw(100.0, 150.0)
  catch case e: InsufficientFundsException => println(s"${e.getMessage} (shortfall=${e.shortfall})")

  println("\n--- Option: no null anywhere ---")
  println(s"findUser(1) = ${findUser(1)}")
  println(s"findUser(99) = ${findUser(99)}")
  println(s"getOrElse fallback: ${findUser(99).getOrElse("unknown")}")

  println("\n--- Either: typed success/failure with a reason ---")
  println(s"parseAge(\"31\") = ${parseAge("31")}")
  println(s"parseAge(\"-5\") = ${parseAge("-5")}")
  println(s"parseAge(\"abc\") = ${parseAge("abc")}")

  println("\n--- Try: wraps a possibly-throwing computation as a value ---")
  val t1: Try[Double] = Try(divide(10.0, 2.0))
  val t2: Try[Double] = Try(divide(10.0, 0.0))
  println(s"Try success: $t1")
  println(s"Try failure: $t2")
  t2 match
    case Success(v) => println(s"got $v")
    case Failure(e) => println(s"handled failure: ${e.getMessage}")
