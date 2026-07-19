// 12 - Functional Concepts
// First-class functions, higher-order functions, map/filter/fold, and function composition.

@main def functionalConceptsDemo(): Unit =
  println("--- functions as first-class values ---")
  val square: Int => Int = x => x * x           // a function stored in a val, just like any other value
  val functions: List[Int => Int] = List(square, (x: Int) => x + 1, (x: Int) => -x)
  println(functions.map(f => f(5)))               // calling each function value in turn

  println("\n--- higher-order functions: taking/returning functions ---")
  def applyTwice(f: Int => Int, x: Int): Int = f(f(x)) // HOF: takes a function as a parameter
  println(s"applyTwice(square, 3) = ${applyTwice(square, 3)}")

  def multiplier(factor: Int): Int => Int = x => x * factor // HOF: RETURNS a function (a closure over `factor`)
  val triple = multiplier(3)
  println(s"triple(7) = ${triple(7)}")

  println("\n--- map / filter / fold ---")
  val nums = List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
  val doubled = nums.map(_ * 2)
  val evens = nums.filter(_ % 2 == 0)
  val sum = nums.foldLeft(0)(_ + _)               // fold: combine all elements into one value
  val product = nums.foldLeft(1)(_ * _)
  println(s"nums     = $nums")
  println(s"doubled  = $doubled")
  println(s"evens    = $evens")
  println(s"sum      = $sum")
  println(s"product  = $product")

  println("\n--- function composition ---")
  val addOne: Int => Int = _ + 1
  val timesTwo: Int => Int = _ * 2
  val addThenDouble = addOne andThen timesTwo      // andThen: left-to-right (addOne first, then timesTwo)
  val doubleThenAdd = addOne compose timesTwo      // compose: right-to-left (timesTwo first, then addOne)
  println(s"(addOne andThen timesTwo)(5) = ${addThenDouble(5)}") // (5+1)*2 = 12
  println(s"(addOne compose timesTwo)(5) = ${doubleThenAdd(5)}") // (5*2)+1 = 11
