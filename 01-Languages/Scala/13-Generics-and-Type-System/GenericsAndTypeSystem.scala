// 13 - Generics and the Type System
// Parametric polymorphism, variance annotations (+T covariant, -T contravariant), and type bounds.

// A generic (parametrically polymorphic) container -- works for ANY type `A`.
class Box[A](val value: A):
  def get: A = value
  def map[B](f: A => B): Box[B] = Box(f(value))

// Covariance (+T): if Cat <: Animal, then Container[Cat] <: Container[Animal].
// Declaring the type parameter read-only (only ever produced, never accepted as input)
// is what makes this sound.
trait Container[+T]:
  def get: T

class Animal(val name: String):
  override def toString: String = s"Animal($name)"
class Cat(name: String) extends Animal(name):
  override def toString: String = s"Cat($name)"

class Holder[+T](item: T) extends Container[T]:
  def get: T = item

// Contravariance (-T): if Cat <: Animal, then Processor[Animal] <: Processor[Cat] --
// a processor that can handle ANY Animal can certainly handle a Cat.
trait Processor[-T]:
  def process(t: T): String

class AnimalProcessor extends Processor[Animal]:
  def process(t: Animal): String = s"processing ${t.toString}"

// Upper type bound (T <: Animal): T can be ANY subtype of Animal, but nothing else.
def describe[T <: Animal](t: T): String = s"describe: ${t.name} is an Animal"

// Lower type bound (B >: T): used when a method must accept a supertype of the
// original type parameter -- e.g. adding a possibly-unrelated element to an
// immutable, covariant list without breaking variance.
def prepend[T, B >: T](item: B, list: List[T]): List[B] = item :: list

@main def genericsAndTypeSystemDemo(): Unit =
  println("--- parametric polymorphism: Box[A] works for any A ---")
  val intBox = Box(42)
  val strBox = Box("hello")
  println(s"intBox.get = ${intBox.get}, strBox.get = ${strBox.get}")
  println(s"intBox.map(_ * 2).get = ${intBox.map(_ * 2).get}")

  println("\n--- covariance (+T): Holder[Cat] IS-A Container[Animal] ---")
  val catHolder: Container[Animal] = Holder[Cat](Cat("Whiskers")) // legal only because Container is +T
  println(s"catHolder.get = ${catHolder.get}")

  println("\n--- contravariance (-T): Processor[Animal] IS-A Processor[Cat] ---")
  val catProcessor: Processor[Cat] = new AnimalProcessor // legal only because Processor is -T
  println(catProcessor.process(Cat("Tom")))

  println("\n--- upper type bound: T <: Animal ---")
  println(describe(Cat("Felix")))

  println("\n--- lower type bound: widening on prepend ---")
  val cats: List[Cat] = List(Cat("A"), Cat("B"))
  val animals: List[Animal] = prepend(Animal("Generic"), cats) // widens List[Cat] to List[Animal]
  println(s"animals = $animals")
