doubleAll :: [Int] -> [Int]
doubleAll = map (* 2)

keepEven :: [Int] -> [Int]
keepEven = filter even

sumR :: [Int] -> Int
sumR = foldr (+) 0

sumL :: [Int] -> Int
sumL = foldl (+) 0

firstEven :: [Int] -> Maybe Int
firstEven = foldr (\x acc -> if even x then Just x else acc) Nothing

-- A small pipeline: sum of squares of the even numbers 1..10, built entirely
-- from map/filter/fold composed with (.), no hand-written recursion at all.
pipeline :: Int
pipeline = sum . map (^ (2 :: Int)) . filter even $ [1 .. 10]

main :: IO ()
main = do
    putStrLn ("doubleAll [1,2,3] = " ++ show (doubleAll [1, 2, 3]))
    putStrLn ("keepEven [1..10] = " ++ show (keepEven [1 .. 10]))
    putStrLn ("sumR [1,2,3,4] = " ++ show (sumR [1, 2, 3, 4]))
    putStrLn ("sumL [1,2,3,4] = " ++ show (sumL [1, 2, 3, 4]))
    putStrLn ("firstEven [1..] (infinite list) = " ++ show (firstEven [1 ..]))
    putStrLn ("pipeline (sum of squares of evens, 1..10) = " ++ show pipeline)
