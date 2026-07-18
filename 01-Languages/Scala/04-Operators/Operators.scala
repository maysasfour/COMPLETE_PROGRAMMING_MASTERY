// Operators.scala - LIVE proof that Scala operators are ordinary method calls:
// `1 + 2` and `1.+(2)` are compiled and compared here, not just claimed in prose.

@main def operatorsDemo(): Unit =
  val infix = 1 + 2
  val methodCall = 1.+(2) // explicit method-call syntax for the exact same "+" method
  println(s"infix: 1 + 2 = $infix")
  println(s"method call: 1.+(2) = $methodCall")
  println(s"identical result: ${infix == methodCall}")
  assert(infix == methodCall, "operators-are-methods proof failed")

  println(s"arithmetic: 5+3=${5 + 3}, 5-3=${5 - 3}, 5*3=${5 * 3}, 5/3=${5 / 3}, 5%3=${5 % 3}")
  println(s"comparison: 5>3=${5 > 3}, 5==3=${5 == 3}")
  println(s"logical: true&&false=${true && false}, true||false=${true || false}, !true=${!true}")
  println(s"string concat: ${"a" + "b"}")
