# Solution 01 — Currying and Pattern Matching in Practice

See [Exercise01.hs](Exercise01.hs) for the full runnable code.

## `safeDivide` — Pattern Matching on the Divisor

```haskell
safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing         -- matches ANY first argument, but only divisor 0
safeDivide a b = Just (a `div` b)
```

The `_` in the first equation means "match any value here, I don't need to name it" — pattern matching lets the *second* argument's literal value (`0`) alone decide which equation fires, without an `if` inside a single function body.

## `double`/`triple` — Currying Through Three Arguments

```haskell
multiply3 :: Int -> Int -> Int -> Int   -- really Int -> (Int -> (Int -> Int))
multiply3 a b c = a * b * c

double :: Int -> Int
double = multiply3 1 2   -- fixes the first TWO of three curried arguments

triple :: Int -> Int
triple = multiply3 1 3
```

`multiply3 1 2` supplies two of the three arguments `multiply3` needs, leaving a genuine `Int -> Int` function value awaiting the third — proving currying isn't a special two-argument case; it chains through as many arguments as the function has, with no different syntax needed at three versus two.

## `countVowels` — Point-Free Composition

```haskell
countVowels :: String -> Int
countVowels = length . filter (`elem` "aeiou")
```

Read right-to-left (Lesson 04): `filter (`elem` "aeiou")` keeps only the vowel characters, then `length` counts what's left — composed with `.`, with no argument ever named.

## Verified Output

```bash
$ runghc Exercise01.hs
safeDivide 10 2 = Just 5
safeDivide 10 0 = Nothing
double 6 = 12
triple 6 = 18
countVowels "Haskell" = 2
```
