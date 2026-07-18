// Strings.scala - string interpolation (s/f/raw), immutability, and common String methods.
// java.lang.String backs Scala's String directly (same interop point as Kotlin's course).

@main def stringsDemo(): Unit =
  val name = "Ada"
  val age = 31

  println(s"s-interpolator: Hello, $name! Next year you'll be ${age + 1}.")
  println(f"f-interpolator (formatted): $name%s is $age%03d years old, pi=${math.Pi}%.2f")
  println(raw"raw-interpolator: no escape processing -- tab\tnewline\n stays literal")

  val original = "hello"
  val upper = original.toUpperCase
  println(s"immutability: original=$original upper=$upper (original unchanged: ${original == "hello"})")

  val multi = """line one
line two""".stripMargin
  println(s"multi-line:\n$multi")

  println(s"length=${original.length}, replace=${original.replace('l', 'L')}, split=${"a,b,c".split(",").toList}")
  println(s"trim='${"  padded  ".trim}', contains=${original.contains("ell")}")
