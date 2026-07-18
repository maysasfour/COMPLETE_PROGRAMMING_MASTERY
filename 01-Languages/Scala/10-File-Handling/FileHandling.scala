// FileHandling.scala - scala.io.Source for reading, java.nio.file for writing (Scala has
// no built-in write-side file API of its own -- it borrows java.nio.file directly), and an
// honest demonstration that Scala has NO built-in JSON support at all.

import scala.io.Source
import java.nio.file.{Files, Paths}
import java.nio.charset.StandardCharsets

@main def fileHandlingDemo(): Unit =
  val path = Paths.get("demo-scala-file.txt")

  // Writing: java.nio.file directly -- Scala has no write-side API of its own.
  Files.write(path, "line one\nline two\nline three".getBytes(StandardCharsets.UTF_8))
  println(s"wrote to ${path.toAbsolutePath}")

  // Reading: scala.io.Source, Scala's own thin read-side wrapper over java.io.
  val source = Source.fromFile(path.toFile)
  try
    val lines = source.getLines().toList
    println(s"read back ${lines.length} lines:")
    lines.foreach(l => println(s"  $l"))
  finally source.close() // Source does NOT auto-close; forgetting this leaks a file handle

  // Honest gap: Scala's standard library has NO built-in JSON parser/serializer at all --
  // the same gap Java and Kotlin have. A real project needs circe, play-json, or upickle.
  val fakeJsonLine = """{"name": "Ada", "age": 31}"""
  println(s"\nScala has NO built-in JSON support -- this is just a String, not parsed: $fakeJsonLine")
  println(s"Manually 'parsing' it here would be fragile/wrong; a real project needs a library" +
    " (circe/play-json/upickle), exactly the same honest gap as Java's and Kotlin's courses.")

  Files.deleteIfExists(path)
  println(s"\ncleaned up: ${path.toAbsolutePath} exists = ${Files.exists(path)}")
