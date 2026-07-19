// Solution 6 -- concurrent word counts across sources, real measured timing (Lesson 14)

import scala.concurrent.{Future, Await, ExecutionContext}
import scala.concurrent.duration.*

given ExecutionContext = ExecutionContext.global

def slowWordCount(doc: String, delayMillis: Int): Future[Int] = Future {
  Thread.sleep(delayMillis) // simulates a slow-to-process source
  doc.split("\\s+").length
}

@main def solution6ConcurrentWordCounts(): Unit =
  val docA = "the quick brown fox jumps over the lazy dog"
  val docB = "scala is a hybrid object oriented and functional programming language"
  val docC = "futures represent asynchronous computations that may not have completed yet"

  val start = System.nanoTime()
  val fa = slowWordCount(docA, 250)
  val fb = slowWordCount(docB, 250)
  val fc = slowWordCount(docC, 250)
  val combined = for
    a <- fa
    b <- fb
    c <- fc
  yield a + b + c

  val total = Await.result(combined, 5.seconds)
  val elapsedMillis = (System.nanoTime() - start) / 1000000
  println(s"total word count across all 3 documents = $total")
  println(s"elapsed = ${elapsedMillis}ms (expect ~250ms, not ~750ms -- confirms real concurrency)")
