describe :: Int -> String
describe 0 = "zero"
describe n
  | n < 0     = "negative"
  | otherwise = "positive"

firstOrDefault :: [Int] -> Int
firstOrDefault []      = 0
firstOrDefault (x : _) = x

add :: Int -> Int -> Int
add x y = x + y

addFive :: Int -> Int
addFive = add 5   -- partial application: add applied to just one argument

isPositive' :: Int -> Bool
isPositive' = (> 0)   -- point-free, built from an operator section

isPositiveLength :: [a] -> Bool
isPositiveLength = isPositive' . length

main :: IO ()
main = do
    putStrLn ("describe 0 = " ++ describe 0)
    putStrLn ("describe (-5) = " ++ describe (-5))
    putStrLn ("describe 7 = " ++ describe 7)

    putStrLn ("firstOrDefault [] = " ++ show (firstOrDefault []))
    putStrLn ("firstOrDefault [9,2,3] = " ++ show (firstOrDefault [9, 2, 3]))

    putStrLn ("add 5 3 = " ++ show (add 5 3))
    putStrLn ("addFive 3 = " ++ show (addFive 3))
    putStrLn ("addFive is a real function value: " ++ show (map addFive [1, 2, 3] == [6, 7, 8]))

    putStrLn ("isPositive' 5 = " ++ show (isPositive' 5))
    putStrLn ("isPositive' (-5) = " ++ show (isPositive' (-5)))
    putStrLn ("isPositiveLength [1,2,3] = " ++ show (isPositiveLength [1, 2, 3 :: Int]))
