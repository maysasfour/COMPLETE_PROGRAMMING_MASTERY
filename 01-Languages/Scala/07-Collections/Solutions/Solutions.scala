// Solutions.scala - 07 Collections exercise solutions, actually compiled and run.

def evenDoubled(xs: List[Int]): List[Int] =
  xs.filter(_ % 2 == 0).map(_ * 2)

def incrementAges(ages: Map[String, Int]): Map[String, Int] =
  ages.view.mapValues(_ + 1).toMap

def wordFrequency(words: List[String]): Map[String, Int] =
  words.groupBy(identity).view.mapValues(_.size).toMap

@main def solutionsDemo(): Unit =
  println(evenDoubled(List(1, 2, 3, 4, 5, 6)))
  println(incrementAges(Map("Ada" -> 30, "Grace" -> 40)))
  println(wordFrequency(List("a", "b", "a", "c", "b", "a")))
