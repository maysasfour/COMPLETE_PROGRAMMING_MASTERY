# Scala Cheat Sheet

## Variables

```scala
val x = 5          // immutable binding (preferred)
var y = 10          // mutable binding
val z: Int = 5       // explicit type annotation
```

## Basic Types

`Int`, `Long`, `Double`, `Float`, `Boolean`, `Char`, `String`, `Unit` (like `void`), `Any`, `Nothing`.

## Operators (all are methods)

```scala
1 + 2        // sugar for 1.+(2)
a == b       // structural equality (calls .equals)
a.eq(b)      // reference equality
!flag        // boolean not
```

## Control Flow

```scala
val r = if (x > 0) "pos" else "neg"       // if is an expression

x match {
  case 0 => "zero"
  case n if n > 0 => "positive"
  case _ => "negative"
}

for (i <- 1 to 5) println(i)
val squares = for (i <- 1 to 5) yield i * i
```

## Functions

```scala
def add(a: Int, b: Int): Int = a + b
def greet(name: String = "world"): String = s"hello $name"   // default param
def curriedAdd(a: Int)(b: Int): Int = a + b                   // currying
val addFn: (Int, Int) => Int = (a, b) => a + b                 // function value
```

## Collections (immutable by default)

```scala
val xs = List(1, 2, 3)
val v  = Vector(1, 2, 3)
val m  = Map("a" -> 1, "b" -> 2)
val s  = Set(1, 2, 3)

xs.map(_ * 2)
xs.filter(_ > 1)
xs.foldLeft(0)(_ + _)
```

## Strings

```scala
s"Hello, $name! ${1 + 1}"     // interpolation
f"Pi is $pi%.2f"               // formatted interpolation
```

## Error Handling

```scala
try { risky() } catch { case e: Exception => println(e.getMessage) } finally { cleanup() }
val opt: Option[Int] = Some(5)
val eth: Either[String, Int] = Right(5)
val t: scala.util.Try[Int] = scala.util.Try(1 / 0)
```

## OOP

```scala
class Point(val x: Int, val y: Int)
case class Person(name: String, age: Int)     // equals/hashCode/toString/copy for free
trait Greeter { def greet(): String = "hi" }
object Singleton { def instance() = "one" }
```

## Generics and Variance

```scala
class Box[T](val value: T)
class Producer[+T](val item: T)     // covariant
class Consumer[-T] { def consume(t: T): Unit = () }  // contravariant
def maxOf[T](a: T, b: T)(using ord: Ordering[T]): T = if (ord.gt(a, b)) a else b
```

## Concurrency

```scala
import scala.concurrent.{Future, ExecutionContext}
import scala.concurrent.ExecutionContext.Implicits.global
val f: Future[Int] = Future { 1 + 1 }
```

## Packages

```scala
package com.example.app
import scala.collection.mutable.ListBuffer
```

## Run a File

```bash
scalac MyFile.scala
scala run . --main-class myMainFunction
```

See the full course starting at [README.md](README.md).
