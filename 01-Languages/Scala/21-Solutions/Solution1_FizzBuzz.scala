// Solution 1 -- FizzBuzz with pattern matching (Lessons 05, 06)

def fizzbuzz(n: Int): String =
  (n % 3, n % 5) match
    case (0, 0) => "FizzBuzz"
    case (0, _) => "Fizz"
    case (_, 0) => "Buzz"
    case _      => n.toString

@main def solution1FizzBuzz(): Unit =
  (1 to 20).foreach(n => println(fizzbuzz(n)))
