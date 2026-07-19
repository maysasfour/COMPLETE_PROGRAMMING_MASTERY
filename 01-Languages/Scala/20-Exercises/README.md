# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

These exercises span the whole course (Lessons 01–19). Matching, compiled-and-run solutions are in [21-Solutions](../21-Solutions/README.md) — attempt each problem yourself first.

## Problem 1 — FizzBuzz With Pattern Matching (Lessons 05, 06)

Write a function `fizzbuzz(n: Int): String` that returns `"Fizz"` for multiples of 3, `"Buzz"` for multiples of 5, `"FizzBuzz"` for multiples of both, and `n.toString` otherwise. Use a `match` expression, not a chain of `if`/`else`. Print the results for `1` to `20`.

## Problem 2 — Word Frequency Counter (Lessons 07, 08)

Write a function `wordFrequency(text: String): Map[String, Int]` that splits `text` on whitespace, lowercases each word, strips punctuation, and returns a map from word to occurrence count. Use it on a short multi-sentence paragraph and print the result sorted by frequency, descending.

## Problem 3 — Safe Division Pipeline (Lesson 09)

Write `def safeDivide(a: Double, b: Double): Either[String, Double]` returning `Left("division by zero")` for `b == 0` and `Right(a / b)` otherwise. Then write `def chain(inputs: List[(Double, Double)]): Either[String, List[Double]]` that runs `safeDivide` over every pair, short-circuiting with the first `Left` encountered (hint: `List`'s `foldLeft` over `Either`, or a for-comprehension over `Either` values collected into a list).

## Problem 4 — Shape Hierarchy With Traits (Lesson 11)

Define a `trait Shape` with an abstract `area: Double` and a concrete `def describe: String` default method. Implement `case class Circle(radius: Double)` and `case class Square(side: Double)` extending it. Write a function that takes a `List[Shape]` and returns the total area, then print each shape's `describe` output alongside the total.

## Problem 5 — Generic Stack With Bounded Type (Lessons 12, 13)

Implement a generic, immutable `Stack[+A]` (backed by a `List[A]` internally) with `push`, `pop` (returning `Option[(A, Stack[A])]`), and `isEmpty`. Then write a higher-order function `def sumIfNumeric[A](stack: Stack[A])(using ev: A =:= Int): Int` (or an equivalent bounded-type approach) that sums the stack's elements, demonstrating both generics and a type constraint together.

## Problem 6 — Concurrent Word Counts Across Sources (Lesson 14)

Given three hard-coded "documents" (strings) representing slow-to-process sources, write a function that processes all three **concurrently** as `Future[Int]` (word count per document, simulated with a `Thread.sleep`), combines the results with a for-comprehension, and prints the total elapsed time — confirming (with real measured timing, not just an assumption) that the three ran concurrently rather than sequentially.

## Problem 7 — Parameterized Query Builder (Lesson 16)

Using the `sqlite-jdbc` setup from Lesson 16, create a small in-memory (`jdbc:sqlite::memory:`) `products` table (`id`, `name`, `price`). Write a function `insertProduct(conn, name: String, price: Double): Unit` using a `PreparedStatement`, and a function `findByName(conn, name: String): Option[(Int, String, Double)]` that safely queries by name (bound parameter, not concatenation). Demonstrate both with at least two products and one lookup.

## Problem 8 — End-to-End: Fetch, Filter, Persist (Lessons 16, 17)

Combine Lessons 16 and 17: fetch `https://jsonplaceholder.typicode.com/todos?userId=1` with `HttpClient`, hand-parse (or count) how many returned todos have `"completed": true` appearing in the raw JSON text (a simple string-based count is fine — no JSON library, consistent with Lesson 10's honest no-JSON-parser stance), and insert that count into a small SQLite table via JDBC as a single summary row. Print the final row back out by querying it.

## Recommended Next

[21 — Solutions](../21-Solutions/README.md)
