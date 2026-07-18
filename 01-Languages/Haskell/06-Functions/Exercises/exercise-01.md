# Exercise 01 — Currying and Pattern Matching in Practice

Write a file `Exercise01.hs` with:

```haskell
safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide a b = Just (a `div` b)

multiply3 :: Int -> Int -> Int -> Int
multiply3 a b c = a * b * c

-- Build these via PARTIAL APPLICATION of multiply3, no lambda:
double :: Int -> Int
double = ...

triple :: Int -> Int
triple = ...

countVowels :: String -> Int
countVowels = ...   -- point-free: length . filter (...)
```

Expected, printed from `main`:

```
safeDivide 10 2 = Just 5
safeDivide 10 0 = Nothing
double 6 = 12
triple 6 = 18
countVowels "Haskell" = 2
```

Run with `runghc Exercise01.hs`.
