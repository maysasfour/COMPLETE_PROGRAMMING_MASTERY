# Exercises — 07 Collections

1. **`primes`** — build an infinite list of prime numbers using the classic Sieve of Eratosthenes expressed as a self-referential list comprehension, then `take 10` of it.

2. **`chunk`** — write `chunk :: Int -> [a] -> [[a]]` that splits a list into sublists of size `n` (last chunk may be shorter). Use recursion + `splitAt`.

3. **`swap3`** — write `rotateLeft :: (a, b, c) -> (b, c, a)` for 3-tuples using pattern matching.

See [exercise-01.md](exercise-01.md) for exact signatures and expected output.
