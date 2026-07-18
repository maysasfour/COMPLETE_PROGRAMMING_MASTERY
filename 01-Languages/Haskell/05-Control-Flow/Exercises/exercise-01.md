# Exercise 01 — FizzBuzz and Countdown

## Part 1: FizzBuzz with Guards

Write:

```haskell
fizzbuzz :: Int -> String
fizzbuzz n
  | ... = ...   -- fill in using guards, checking multiples of 15 first
```

Then:

```haskell
fizzbuzzRange :: Int -> Int -> [String]
fizzbuzzRange lo hi = ...   -- apply fizzbuzz to every number from lo to hi, inclusive
```

Expected: `fizzbuzzRange 1 15` produces
`["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]`.

## Part 2: Countdown by Recursion

Write:

```haskell
countdown :: Int -> [String]
countdown 0 = ["Liftoff!"]
countdown n = ...   -- recursive case
```

Expected: `countdown 3` produces `["3","2","1","Liftoff!"]`.

Write both in a file named `Exercise01.hs` with a `main` that prints both results, and check it with `runghc Exercise01.hs`.
