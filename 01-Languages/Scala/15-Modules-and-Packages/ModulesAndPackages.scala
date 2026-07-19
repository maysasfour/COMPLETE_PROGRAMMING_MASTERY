// 15 - Modules and Packages
// Packages organize code into namespaces; `import` brings names into scope; sbt/Coursier
// manage dependencies and builds (discussed in prose in the README -- no build tool needed
// to demonstrate the LANGUAGE feature of packages itself).

import geometry.shapes.* // wildcard import -- brings both Circle and Rectangle into scope
import geometry.Formatter // a single specific import

@main def modulesAndPackagesDemo(): Unit =
  println("--- using types from geometry.shapes, formatted via geometry.Formatter ---")
  val c = Circle(2.0)
  val r = Rectangle(3.0, 4.0)
  println(Formatter.describe(c))
  println(Formatter.describe(r))

  println("\n--- fully-qualified access works too, without any import ---")
  val c2 = geometry.shapes.Circle(1.0)
  println(s"fully-qualified: ${geometry.Formatter.describe(c2)}")
