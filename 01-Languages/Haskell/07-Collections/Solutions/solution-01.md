# Solution 01 — Infinite Primes, Chunking, Tuple Rotation

See [Exercise01.hs](Exercise01.hs) for the full runnable code.

## `primes` — Infinite Sieve of Eratosthenes

```haskell
primes :: [Integer]
primes = sieve [2 ..]
  where
    sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
    sieve []       = []
```

`sieve` takes the head of its input as a genuine prime (the smallest number not yet filtered out by any earlier prime), then recurses on a filtered version of the rest with every multiple of that prime removed — exactly the sieve algorithm, but expressed over an infinite list. `take 10 primes` only forces the sieve to run far enough to produce 10 primes; the underlying `[2 ..]` and every recursive `sieve` call past that point are never touched, the same laziness guarantee Lesson 07's `naturals`/`fibs` rely on.

## `chunk` — Recursive Splitting

```haskell
chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = let (h, t) = splitAt n xs in h : chunk n t
```

`splitAt n xs` gives `(first n elements, rest)` in one call; `chunk` recurses on the rest until nothing's left, consing each chunk onto the front (O(1) per chunk, per Lesson 07's cons-is-cheap point).

## `rotateLeft` — 3-Tuple Pattern Matching

```haskell
rotateLeft :: (a, b, c) -> (b, c, a)
rotateLeft (a, b, c) = (b, c, a)
```

Since `fst`/`snd` only exist for pairs (Lesson 07), a 3-tuple must be destructured by pattern matching its constructor directly, then reassembled in the new order.

## Verified Output

```bash
$ runghc Exercise01.hs
take 10 primes = [2,3,5,7,11,13,17,19,23,29]
chunk 3 [1..10] = [[1,2,3],[4,5,6],[7,8,9],[10]]
rotateLeft (1,"two",True) = ("two",True,1)
```
