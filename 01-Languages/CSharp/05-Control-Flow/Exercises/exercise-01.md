# Exercise 01 — FizzBuzz as a Switch Expression

[Back to lesson](../README.md)

## Task

Write a method `string FizzBuzz(int n)` using a **switch expression** (not `if`/`else`) that returns `"FizzBuzz"` for multiples of 15, `"Fizz"` for multiples of 3, `"Buzz"` for multiples of 5, and the number itself (as a string) otherwise. Then print the results for 1 through 15 using a `for` loop.

## Constraints

- Must use a `switch` expression with `when` guards (or relational/pattern combinations), not `if`/`else`.
- The combined `%3 && %5` case must be checked before the individual `%3`/`%5` cases.

## Starter Code

```csharp
string FizzBuzz(int n) => n switch {
    // your patterns here
};

for (int i = 1; i <= 15; i++) {
    Console.WriteLine(FizzBuzz(i));
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

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.cs](../Solutions/solution-01.cs).
