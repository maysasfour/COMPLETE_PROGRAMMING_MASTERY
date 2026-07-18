import Data.List (uncons)
import Data.Maybe (fromMaybe)

-- PARTIAL (unsafe): crashes on []. Kept here only to name the anti-pattern; never call it below.
unsafeFirst :: [a] -> a
unsafeFirst = head

-- TOTAL (safe): a Maybe result forces the caller to handle the empty case,
-- exactly mirroring Lesson 09's Maybe discipline.
safeFirst :: [a] -> Maybe a
safeFirst xs = case uncons xs of
  Nothing     -> Nothing
  Just (x, _) -> Just x

describeFirst :: [Int] -> String
describeFirst xs = case safeFirst xs of
  Nothing -> "empty list, no crash"
  Just x  -> "first element: " ++ show x

-- POINT-FUL: names every argument explicitly.
sumOfSquaresPointful :: [Int] -> Int
sumOfSquaresPointful xs = sum (map (\x -> x * x) xs)

-- POINT-FREE: the same function, defined purely by composition, no argument named.
sumOfSquaresPointfree :: [Int] -> Int
sumOfSquaresPointfree = sum . map (^ 2)

-- A point-free definition taken too far -- technically correct, genuinely harder to read
-- at a glance than naming the argument would be. Included to show the readability tradeoff,
-- not as something to imitate reflexively.
overdonePointfree :: [[Int]] -> Int
overdonePointfree = sum . map (sum . map (^ 2)) . filter (not . null)

main :: IO ()
main = do
  putStrLn (describeFirst [10, 20, 30])
  putStrLn (describeFirst [])
  print (sumOfSquaresPointful [1, 2, 3, 4])
  print (sumOfSquaresPointfree [1, 2, 3, 4])
  print (fromMaybe 0 (safeFirst ([] :: [Int])))
  print (overdonePointfree [[1, 2], [], [3]])
