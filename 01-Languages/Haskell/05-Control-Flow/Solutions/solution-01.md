# Solution 01 — FizzBuzz and Countdown

See [Exercise01.hs](Exercise01.hs) for the full runnable code.

## FizzBuzz

```haskell
fizzbuzz :: Int -> String
fizzbuzz n
  | n `mod` 15 == 0 = "FizzBuzz"
  | n `mod` 3  == 0 = "Fizz"
  | n `mod` 5  == 0 = "Buzz"
  | otherwise       = show n
```

The order matters: checking `mod 15` first is what makes `otherwise`-style guard fallthrough work correctly for multiples of both 3 and 5 — if `mod 3` were checked first, 15 would incorrectly print `"Fizz"` and never reach the `"FizzBuzz"` case.

```haskell
fizzbuzzRange :: Int -> Int -> [String]
fizzbuzzRange lo hi = map fizzbuzz [lo .. hi]
```

No loop needed — `[lo .. hi]` builds the list of numbers, and `map` (Lesson 12) applies `fizzbuzz` to each one.

## Countdown

```haskell
countdown :: Int -> [String]
countdown 0 = ["Liftoff!"]                    -- base case
countdown n = show n : countdown (n - 1)      -- recursive case
```

`countdown 3` expands as `"3" : countdown 2` → `"3" : "2" : countdown 1` → `"3" : "2" : "1" : countdown 0` → `"3" : "2" : "1" : ["Liftoff!"]`, giving `["3","2","1","Liftoff!"]`. This is the pattern-matching-driven recursion style Lesson 06 covers in depth — the base case (`0`) and recursive case (everything else) are two separate equations, not an `if` inside one function body.

## Verified Output

```bash
$ runghc Exercise01.hs
["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
["3","2","1","Liftoff!"]
```
