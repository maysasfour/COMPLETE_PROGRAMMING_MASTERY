// Solution 2 -- word frequency counter (Lessons 07, 08)

def wordFrequency(text: String): Map[String, Int] =
  text
    .toLowerCase
    .split("\\s+")
    .map(_.replaceAll("[.,!?;:]", ""))
    .filter(_.nonEmpty)
    .groupBy(identity)
    .view
    .mapValues(_.length)
    .toMap

@main def solution2WordFrequency(): Unit =
  val text = "The quick brown fox jumps over the lazy dog. The dog barks, and the fox runs away!"
  val freq = wordFrequency(text)
  freq.toSeq.sortBy(-_._2).foreach { case (word, count) => println(s"$word: $count") }
