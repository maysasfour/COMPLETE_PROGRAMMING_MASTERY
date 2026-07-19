// Standalone MUnit runner, identical approach to Lesson 18 -- calls MUnit's own
// public munitTests() API by hand since this course has no sbt project to drive it.

import scala.concurrent.Await
import scala.concurrent.duration.*
import scala.concurrent.ExecutionContext.Implicits.global

@main def runTaskTrackerTests(): Unit =
  val suite = new TaskRepositorySuite()
  val tests = suite.munitTests()
  var passed = 0
  var failed = 0
  for t <- tests do
    try
      Await.result(t.body(), 10.seconds)
      println(s"PASS  ${t.name}")
      passed += 1
    catch
      case e: Throwable =>
        println(s"FAIL  ${t.name} -- ${e.getClass.getSimpleName}: ${e.getMessage}")
        failed += 1
  println(s"\n${passed + failed} tests run, $passed passed, $failed failed")
  if failed > 0 then sys.exit(1)
