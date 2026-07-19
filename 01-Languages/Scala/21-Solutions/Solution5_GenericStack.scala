// Solution 5 -- generic, immutable stack + a bounded-type higher-order function (Lessons 12, 13)

final case class Stack[+A](items: List[A] = Nil):
  def push[B >: A](item: B): Stack[B] = Stack(item :: items) // lower bound: widen if needed, like Lesson 13's prepend
  def pop: Option[(A, Stack[A])] = items match
    case Nil          => None
    case head :: tail => Some((head, Stack(tail)))
  def isEmpty: Boolean = items.isEmpty

// Bounded via a type-equality evidence parameter: only callable when A is actually Int.
def sumIfNumeric[A](stack: Stack[A])(using ev: A =:= Int): Int =
  stack.items.map(ev).sum

@main def solution5GenericStack(): Unit =
  val intStack = Stack[Int]().push(1).push(2).push(3)
  println(s"intStack.items = ${intStack.items}")
  println(s"sumIfNumeric(intStack) = ${sumIfNumeric(intStack)}")

  intStack.pop match
    case Some((top, rest)) => println(s"popped $top, remaining = ${rest.items}")
    case None              => println("stack was empty")

  val strStack = Stack[String]().push("a").push("b")
  println(s"strStack.items = ${strStack.items} (isEmpty=${strStack.isEmpty})")
  // sumIfNumeric(strStack) -- would NOT compile: no `String =:= Int` evidence exists, caught at compile time
