// Functions.scala - methods vs function values (with eta-expansion), default/named
// parameters, and currying via multiple parameter lists.

def double(x: Int): Int = x * 2

def greet(name: String, greeting: String = "Hello"): String = s"$greeting, $name!"

def add(a: Int)(b: Int): Int = a + b

@main def functionsDemo(): Unit =
  val doubleFn: Int => Int = x => x * 2
  val fromMethod: Int => Int = double // eta-expansion: method reference -> function value

  println(s"method call: double(5) = ${double(5)}")
  println(s"function value call: doubleFn(5) = ${doubleFn(5)}")
  println(s"eta-expanded: fromMethod(5) = ${fromMethod(5)}")

  println(s"default param: ${greet("Ada")}")
  println(s"named params: ${greet(name = "Ada", greeting = "Hi")}")

  println(s"curried: add(5)(3) = ${add(5)(3)}")
  val add5 = add(5) // partial application: add5: Int => Int
  println(s"partially applied add5(3) = ${add5(3)}")
