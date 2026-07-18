# Exercises — 05 Control Flow

1. **`fizzbuzz`** — write `fizzbuzz :: Int -> String` using guards: `"FizzBuzz"` for multiples of 15, `"Fizz"` for multiples of 3, `"Buzz"` for multiples of 5, otherwise the number itself as a string. Then write `fizzbuzzRange :: Int -> Int -> [String]` that applies it to every number in a range (no loop — use recursion or a list comprehension/`map`).

2. **`countdown`** — write a purely recursive `countdown :: Int -> [String]` that produces `["3","2","1","Liftoff!"]` for input `3` (no loop construct exists, so this must be recursion — the base case is `0`, which produces just `["Liftoff!"]`).

See [exercise-01.md](exercise-01.md) for the exact function signatures and starter file.
