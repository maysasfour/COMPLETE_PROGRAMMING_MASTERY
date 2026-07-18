# Exercise 01 — Infinite Primes, Chunking, Tuple Rotation

Write a file `Exercise01.hs` with:

```haskell
primes :: [Integer]
primes = sieve [2 ..]
  where
    sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
    sieve []       = []

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = ...   -- use splitAt n xs, recurse on the remainder

rotateLeft :: (a, b, c) -> (b, c, a)
rotateLeft (a, b, c) = ...
```

Expected, printed from `main`:

```
take 10 primes = [2,3,5,7,11,13,17,19,23,29]
chunk 3 [1..10] = [[1,2,3],[4,5,6],[7,8,9],[10]]
rotateLeft (1,"two",True) = ("two",True,1)
```

Run with `runghc Exercise01.hs`. Note: `primes` is a genuinely infinite list, exactly like Lesson 07's `naturals`/`fibs` — `take 10` must be used, never a bare `print primes`.
