# 21 — Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

Matching solutions to [20-Exercises](../20-Exercises/README.md). All solutions below were actually compiled and run; output shown is real, captured output.

## Solution 1 — FizzBuzz With Pattern Matching

See [Solution1_FizzBuzz.scala](Solution1_FizzBuzz.scala).

```bash
scalac Solution1_FizzBuzz.scala
scala run . --main-class solution1FizzBuzz
```

```
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
16
17
Fizz
19
Buzz
```

## Solution 2 — Word Frequency Counter

See [Solution2_WordFrequency.scala](Solution2_WordFrequency.scala).

```bash
scala run . --main-class solution2WordFrequency
```

```
the: 4
dog: 2
fox: 2
lazy: 1
runs: 1
barks: 1
over: 1
brown: 1
quick: 1
jumps: 1
away: 1
and: 1
```

## Solution 3 — Safe Division Pipeline

See [Solution3_SafeDivision.scala](Solution3_SafeDivision.scala).

```bash
scala run . --main-class solution3SafeDivision
```

```
chain(goodInputs) = Right(List(5.0, 3.0, 25.0))
chain(badInputs)  = Left(division by zero)
```

## Solution 4 — Shape Hierarchy With Traits

See [Solution4_ShapeHierarchy.scala](Solution4_ShapeHierarchy.scala).

```bash
scala run . --main-class solution4ShapeHierarchy
```

```
Circle with area 12.57
Square with area 9.00
Circle with area 3.14
total area = 24.71
```

## Solution 5 — Generic Stack With Bounded Type

See [Solution5_GenericStack.scala](Solution5_GenericStack.scala) — uses a `Stack[+A]` (covariant) with a lower-bounded `push[B >: A]`, and `sumIfNumeric` constrained via a `using ev: A =:= Int` type-equality evidence parameter (only callable when `A` really is `Int`; `sumIfNumeric(strStack)` on the `String` stack would not compile).

```bash
scala run . --main-class solution5GenericStack
```

```
intStack.items = List(3, 2, 1)
sumIfNumeric(intStack) = 6
popped 3, remaining = List(2, 1)
strStack.items = List(b, a) (isEmpty=false)
```

## Solution 6 — Concurrent Word Counts Across Sources

See [Solution6_ConcurrentWordCounts.scala](Solution6_ConcurrentWordCounts.scala).

```bash
scala run . --main-class solution6ConcurrentWordCounts
```

Actually-measured output (small timing variance is expected/normal):

```
total word count across all 3 documents = 29
elapsed = 363ms (expect ~250ms, not ~750ms -- confirms real concurrency)
```

## Solution 7 — Parameterized Query Builder

See [Solution7_QueryBuilder.scala](Solution7_QueryBuilder.scala) — requires `sqlite-jdbc` on the classpath (see [Lesson 16](../16-Database-Access/README.md) for how to fetch it via Coursier).

```bash
scalac -classpath "<sqlite-jdbc-jar>;<slf4j-api-jar>" Solution7_QueryBuilder.scala
java -cp ".;<sqlite-jdbc-jar>;<slf4j-api-jar>;<scala3-library_3-jar>;<scala-library-2.13-jar>" solution7QueryBuilder
```

```
inserted 2 products
found: id=2 name=Mouse price=19.99
Monitor correctly not found
```

## Solution 8 — End-to-End: Fetch, Filter, Persist

See [Solution8_FetchFilterPersist.scala](Solution8_FetchFilterPersist.scala) — requires network access and the `sqlite-jdbc` classpath from Solution 7.

```bash
scalac -classpath "<sqlite-jdbc-jar>;<slf4j-api-jar>" Solution8_FetchFilterPersist.scala
java -cp ".;<sqlite-jdbc-jar>;<slf4j-api-jar>;<scala3-library_3-jar>;<scala-library-2.13-jar>" solution8FetchFilterPersist
```

Real output from an actual run (the exact completed-todo count reflects jsonplaceholder's live fake data and may vary):

```
fetched todos: status=200
completed todos for userId=1: 11

persisted row: user_id=1 completed_count=11
```

## Recommended Next Lesson

[22 — Mini-Projects](../22-Mini-Projects/README.md)
