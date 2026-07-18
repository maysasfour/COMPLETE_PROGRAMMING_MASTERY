safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide a b = Just (a `div` b)

multiply3 :: Int -> Int -> Int -> Int
multiply3 a b c = a * b * c

-- Partial application through THREE arguments -- fixing the first two of
-- multiply3's curried chain (1 * 2 * c = 2c) still needs no special syntax,
-- proving currying isn't just a two-argument special case.
double :: Int -> Int
double = multiply3 1 2

triple :: Int -> Int
triple = multiply3 1 3

countVowels :: String -> Int
countVowels = length . filter (`elem` "aeiou")

main :: IO ()
main = do
    putStrLn ("safeDivide 10 2 = " ++ show (safeDivide 10 2))
    putStrLn ("safeDivide 10 0 = " ++ show (safeDivide 10 0))
    putStrLn ("double 6 = " ++ show (double 6))
    putStrLn ("triple 6 = " ++ show (triple 6))
    putStrLn ("countVowels \"Haskell\" = " ++ show (countVowels "Haskell"))
