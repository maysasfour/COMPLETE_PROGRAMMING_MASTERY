// Syntax.scala - semicolon inference, brace-style vs Scala 3 indentation-style blocks
// (both compiled here, proving they coexist and compile to equivalent code),
// and proof that a `{ }` block itself is an expression with a value.

def classifyBraces(n: Int): String = {
  if (n > 0) "positive"
  else "non-positive"
}

def classifyIndent(n: Int): String =
  if n > 0 then "positive"
  else "non-positive"

@main def syntaxDemo(): Unit =
  val a = 1
  val b = 2; val c = a + b // semicolon required only because two statements share one line
  println(s"brace style: ${classifyBraces(5)}")
  println(s"indentation style: ${classifyIndent(5)}")

  // A block is itself an expression: its value is its last statement's value.
  val blockResult = {
    val x = 10
    val y = 20
    x + y // this is the value the whole block evaluates to
  }
  println(s"block-as-expression result: $blockResult")
