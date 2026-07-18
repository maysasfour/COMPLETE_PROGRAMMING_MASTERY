// Collections.scala - LIVE proof that scala.collection.immutable is the default
// (List is imported as its immutable variant with zero explicit import), core
// map/filter/fold operations, and the explicit mutable opt-in contrast.

@main def collectionsDemo(): Unit =
  val xs = List(1, 2, 3) // no import needed -- this IS scala.collection.immutable.List
  val ys = xs.appended(4) // returns a NEW list; does not touch xs
  println(s"xs=$xs, ys=$ys")
  println(s"xs unchanged after appended(): ${xs == List(1, 2, 3)}")
  assert(xs == List(1, 2, 3), "xs should be untouched -- collections are immutable by default")

  println(s"map: ${xs.map(_ * 2)}")
  println(s"filter: ${xs.filter(_ % 2 == 0)}")
  println(s"foldLeft sum: ${xs.foldLeft(0)(_ + _)}")

  // Mutable collections require an EXPLICIT opt-in import -- the inverse of Java's default.
  import scala.collection.mutable.ListBuffer
  val buf = ListBuffer(1, 2, 3)
  buf += 4 // buf genuinely mutates in place here, but only because mutable was explicitly imported
  println(s"mutable ListBuffer after += : $buf")
