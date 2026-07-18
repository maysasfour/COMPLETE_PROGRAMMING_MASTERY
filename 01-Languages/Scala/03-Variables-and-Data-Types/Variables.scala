// Variables.scala - val (immutable) vs var (mutable), type inference across core types,
// and Unit as an actual type with one value: ().

@main def variablesDemo(): Unit =
  val x = 5
  var y = 5
  println(s"x=$x, y=$y (before reassignment)")
  y = 6 // fine -- y is a var
  println(s"y=$y (after reassignment)")
  // x = 6  // uncommenting this line is a compile error: "Reassignment to val x"

  val d = 3.14
  val s = "hello"
  val b = true
  println(s"inferred types: d=$d, s=$s, b=$b")

  val u: Unit = ()
  println(s"Unit value: $u")
