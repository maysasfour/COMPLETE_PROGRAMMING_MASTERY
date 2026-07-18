# Exercises — 06 Functions

1. **`safeDivide`** — write `safeDivide :: Int -> Int -> Maybe Int` (`Maybe` is introduced properly in Lesson 09, but use it here as "might not produce a value") using pattern matching on the divisor being `0`.

2. **`multiply3`** — write `multiply3 :: Int -> Int -> Int -> Int` and, WITHOUT writing a lambda, partially apply it twice to produce `double :: Int -> Int` (multiply by 2) and `triple :: Int -> Int` (multiply by 3), proving currying works through three arguments, not just two.

3. **Point-free `countVowels`** — write `countVowels :: String -> Int` in point-free style, composing `length` and `filter (`elem` "aeiou")`.

See [exercise-01.md](exercise-01.md) for exact signatures and expected output.
