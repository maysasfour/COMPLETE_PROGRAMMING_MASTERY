// A minimal standalone MUnit runner. MUnit's usual entry point is sbt's `test` task
// (via the sbt test-interface JARs also fetched here), but this course invokes
// scalac/scala directly with no build tool -- so this small runner drives MUnit's
// own public `munitTests()` API (a Seq of runnable Test cases) by hand, printing a
// real pass/fail summary exactly like a build tool's test reporter would.

import scala.concurrent.Await
import scala.concurrent.duration.*
import scala.concurrent.ExecutionContext.Implicits.global

@main def runTests(): Unit =
  val suite = new CalculatorSuite()
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
