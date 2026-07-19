// 11 - OOP and Traits
// Classes, case classes (auto equality/copy), traits (multiple-inheritance-capable
// interfaces with concrete members), and object singletons.

// A plain class: constructor params after `class Name(...)` become fields automatically.
class Animal(val name: String):
  def speak(): String = "..." // overridable by default -- Scala classes are open unless `final`

class Dog(name: String) extends Animal(name):
  override def speak(): String = s"$name says Woof!"

// `case class`: auto-generates equals/hashCode/toString/copy and a companion `apply`.
case class Point(x: Int, y: Int)

// Traits: interface-like constructs that CAN carry concrete implementations and state,
// and a class may mix in more than one -- Scala's answer to multiple inheritance.
trait Greeter:
  def greeting: String
  def greet(name: String): String = s"$greeting, $name!" // concrete default method

trait Loud:
  def shout(msg: String): String = msg.toUpperCase + "!!!"

// Mixing in BOTH traits -- neither is a superclass, both contribute behavior.
class Robot(val greeting: String) extends Greeter, Loud

// `object`: a singleton -- exactly one instance, created lazily on first access.
object Registry:
  private var count = 0
  def register(): Int =
    count += 1
    count

@main def oopAndTraitsDemo(): Unit =
  println("--- classes and overriding ---")
  val a: Animal = Dog("Rex")
  println(a.speak())

  println("\n--- case class: auto equality and copy ---")
  val p1 = Point(1, 2)
  val p2 = p1.copy(y = 99)
  println(s"p1 = $p1")
  println(s"p2 = $p2")
  println(s"p1 == p1.copy() : ${p1 == p1.copy()}") // structural equality, auto-generated
  println(s"p1 == p2        : ${p1 == p2}")

  println("\n--- traits: multiple mix-ins on one class ---")
  val r = Robot("Hello")
  println(r.greet("Ada"))          // from Greeter
  println(r.shout("attention"))    // from Loud

  println("\n--- object singleton ---")
  println(s"register() -> ${Registry.register()}")
  println(s"register() -> ${Registry.register()}")
  println(s"register() -> ${Registry.register()}")
