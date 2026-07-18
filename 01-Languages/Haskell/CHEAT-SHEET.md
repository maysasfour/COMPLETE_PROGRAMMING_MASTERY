# Haskell Cheat Sheet

[Back to course overview](README.md)

## Basic Types and Variables

```haskell
age :: Int
age = 30

name :: String            -- String = [Char], a list of Char
name = "Ada"

pi' :: Double
pi' = 3.14159

flag :: Bool
flag = True

ch :: Char
ch = 'x'

-- Bindings are immutable -- no `let x = 1; x = 2` reassignment.
-- `let`/`where` introduce NEW names, they don't mutate existing ones.
```

## Functions

```haskell
add :: Int -> Int -> Int      -- takes Int, returns (Int -> Int); Haskell functions are curried
add x y = x + y

add5 :: Int -> Int
add5 = add 5                  -- partial application -- add5 10 == 15

square :: Int -> Int
square x = x * x

-- Point-free (no argument named):
double :: Int -> Int
double = (* 2)

-- lambda:
addLambda :: Int -> Int -> Int
addLambda = \x y -> x + y
```

## Pattern Matching

```haskell
describe :: Int -> String
describe 0 = "zero"
describe 1 = "one"
describe n
  | n < 0     = "negative"
  | even n    = "positive even"
  | otherwise = "positive odd"

firstTwo :: [a] -> Maybe (a, a)
firstTwo (x : y : _) = Just (x, y)
firstTwo _            = Nothing

swap :: (a, b) -> (b, a)
swap (a, b) = (b, a)
```

## `case` Expressions

```haskell
classify :: Maybe Int -> String
classify m = case m of
  Nothing -> "nothing"
  Just n | n > 0     -> "positive"
         | otherwise -> "non-positive"
```

## Lists

```haskell
xs :: [Int]
xs = [1, 2, 3, 4, 5]

1 : [2, 3]              -- cons -- [1,2,3]
xs ++ [6, 7]             -- concatenation
head xs                  -- 1 -- PARTIAL, throws on []; prefer `Data.List.uncons`
tail xs                  -- [2,3,4,5] -- also PARTIAL
length xs                -- 5
null xs                  -- False -- prefer this over `length xs == 0`
reverse xs                -- [5,4,3,2,1]
take 3 xs                 -- [1,2,3]
drop 3 xs                 -- [4,5]
xs !! 2                    -- 3 -- PARTIAL, throws if out of range

map (* 2) xs               -- [2,4,6,8,10]
filter even xs             -- [2,4]
foldr (+) 0 xs              -- 15 -- right fold, lazy, works on infinite lists (with a lazy combiner)
foldl (+) 0 xs               -- 15 -- left fold, LAZY accumulator -- avoid for large lists
foldl' (+) 0 xs               -- 15 -- Data.List, STRICT accumulator -- prefer for large sums
sum xs; product xs; maximum xs; minimum xs

[x * 2 | x <- xs, even x]      -- list comprehension -- [4,8]
zip [1,2,3] "abc"                -- [(1,'a'),(2,'b'),(3,'c')]
zipWith (+) [1,2,3] [10,20,30]     -- [11,22,33]

-- Infinite lists -- fine due to laziness, ALWAYS `take`/`takeWhile` before printing:
naturals :: [Integer]
naturals = [1 ..]
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
take 5 naturals   -- [1,2,3,4,5]
```

## `Maybe` and `Either`

```haskell
data Maybe a = Nothing | Just a
data Either a b = Left a | Right b     -- convention: Left = error, Right = success

safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide a b = Just (a `div` b)

maybe 0 id (Just 5)          -- 5 -- maybe defaultVal f m
fromMaybe 0 Nothing            -- 0 -- Data.Maybe
mapMaybe f xs                   -- Data.Maybe -- map + filter out Nothings in one pass

-- Chaining Maybe/Either with >>= or do-notation -- short-circuits on Nothing/Left:
lookupPort :: [(String,String)] -> Maybe Int
lookupPort cfg = do
  raw <- lookup "port" cfg
  case reads raw of
    [(n, "")] -> Just n
    _         -> Nothing

either show (const "ok") (Left "err" :: Either String Int)  -- "err"
```

## Type Classes

```haskell
class Speaker a where
  speak :: a -> String
  shout :: a -> String
  shout x = map toUpper (speak x)   -- default method, in terms of speak

data Dog = Dog String
instance Speaker Dog where
  speak (Dog n) = n ++ " says Woof!"

-- Standard classes, usually derived:
data Color = Red | Green | Blue deriving (Show, Eq, Ord, Enum, Bounded)
```

## `do`-Notation and `IO`

```haskell
main :: IO ()
main = do
  putStrLn "Enter your name:"
  name <- getLine                -- <- extracts the value FROM an IO action
  let greeting = "Hello, " ++ name  -- let for a pure binding inside do
  putStrLn greeting

readFile "notes.txt" >>= putStrLn      -- >>= is do-notation desugared
```

## Records and Algebraic Data Types

```haskell
data Person = Person { personName :: String, personAge :: Int } deriving Show

ada :: Person
ada = Person { personName = "Ada", personAge = 36 }

olderAda :: Person
olderAda = ada { personAge = 37 }         -- record update syntax, NOT mutation -- a new value

data Shape = Circle Double | Rectangle Double Double   -- sum type / tagged union
area :: Shape -> Double
area (Circle r)      = pi * r * r
area (Rectangle w h) = w * h
```

## Modules

```haskell
module MathUtils (add, square) where   -- exposes only these two names

import Data.List (sort, nub)            -- selective import
import qualified Data.Map as Map        -- qualified import, avoids name clashes
```

## Common Prelude Functions

```haskell
id x            -- x, unchanged
const x _        -- always x, ignores second argument
flip f x y        -- f y x
(.) f g = \x -> f (g x)   -- composition -- (f . g) x == f (g x)
($) f x = f x               -- low-precedence application -- f $ g $ h x == f (g (h x))
uncurry f (a,b)               -- f a b
curry f a b                     -- f (a,b)
```

## Running Code

```bash
runghc file.hs               # interpret, no artifacts
ghc -o out file.hs && ./out  # compile to a native binary
ghci file.hs                 # interactive REPL -- :t expr, :l file.hs, :r, :q

cabal build                  # real Cabal project
cabal run
cabal test
```
