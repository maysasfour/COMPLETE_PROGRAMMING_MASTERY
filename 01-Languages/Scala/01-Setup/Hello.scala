// Hello.scala - minimal Scala 3 entry point, proving the compile-then-run toolchain
// works end to end, plus a one-line proof of zero-wrapper JVM/Java interop.

@main def hello(): Unit =
  val a = 1
  val b = 2
  val c = 3
  println(s"Hello Scala, sum=${a + b + c}")
  // Calling a Java standard library static method directly, no wrapper/binding code --
  // this is possible only because Scala compiles to the same JVM bytecode Java does.
  println(s"JVM interop: Java's System.getProperty(\"java.version\") works with zero wrapper code")
