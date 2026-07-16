# Exercise 01 — FizzBuzz as a Switch Expression

[Back to lesson](../README.md)

## Task

Write a static method `String fizzBuzz(int n)` using a **switch expression with `when` guards** that returns `"FizzBuzz"` for multiples of 15, `"Fizz"` for multiples of 3, `"Buzz"` for multiples of 5, and the number itself (as a string) otherwise. Print results for 1 through 15.

## Constraints

- Must use a `switch` expression (`->` syntax) with pattern matching and `when` guards, not `if`/`else`.
- Check the combined `%15` case before the individual `%3`/`%5` cases.

## Starter Code

```java
static String fizzBuzz(int n) {
    return switch (n) {
        // your patterns here
    };
}
```

## Expected Output

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
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/Solution01.java](../Solutions/Solution01.java).
