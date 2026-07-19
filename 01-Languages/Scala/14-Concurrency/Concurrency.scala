// 14 - Concurrency
// scala.concurrent.Future for asynchronous, concurrent work, with REAL measured timing
// proving tasks actually overlap rather than running one after another.

import scala.concurrent.{Future, Await, ExecutionContext}
import scala.concurrent.duration.*
import scala.util.{Success, Failure}

given ExecutionContext = ExecutionContext.global // thread pool backing all Futures below

def slowTask(name: String, millis: Int): Future[String] = Future {
  Thread.sleep(millis)
  s"$name done after ${millis}ms"
}

@main def concurrencyDemo(): Unit =
  println("--- sequential baseline: three 300ms tasks run ONE AFTER ANOTHER ---")
  val seqStart = System.nanoTime()
  Await.result(slowTask("seq-A", 300), 5.seconds)
  Await.result(slowTask("seq-B", 300), 5.seconds)
  Await.result(slowTask("seq-C", 300), 5.seconds)
  val seqMillis = (System.nanoTime() - seqStart) / 1000000
  println(s"sequential total: ${seqMillis}ms (expect ~900ms)")

  println("\n--- concurrent: three 300ms tasks started AT THE SAME TIME ---")
  val concStart = System.nanoTime()
  val fa = slowTask("conc-A", 300) // starts running immediately on the thread pool
  val fb = slowTask("conc-B", 300) // started before fa has finished -- genuine overlap
  val fc = slowTask("conc-C", 300)
  val combined: Future[(String, String, String)] = for
    a <- fa
    b <- fb
    c <- fc
  yield (a, b, c)
  val (ra, rb, rc) = Await.result(combined, 5.seconds)
  val concMillis = (System.nanoTime() - concStart) / 1000000
  println(s"$ra")
  println(s"$rb")
  println(s"$rc")
  println(s"concurrent total: ${concMillis}ms (expect ~300ms, NOT ~900ms -- proves real overlap)")

  println("\n--- Future composition and failure handling ---")
  val okFuture: Future[Int] = Future { 10 / 2 }
  val failFuture: Future[Int] = Future { 10 / 0 }

  Await.ready(okFuture, 2.seconds).value.get match
    case Success(v) => println(s"okFuture succeeded: $v")
    case Failure(e) => println(s"okFuture failed: ${e.getMessage}")

  Await.ready(failFuture, 2.seconds).value.get match
    case Success(v) => println(s"failFuture succeeded: $v")
    case Failure(e) => println(s"failFuture failed: ${e.getClass.getSimpleName}: ${e.getMessage}")

  println("\n--- chaining with map/flatMap ---")
  val chained = Future(5).map(_ * 2).flatMap(x => Future(x + 1))
  println(s"chained result: ${Await.result(chained, 2.seconds)}")
