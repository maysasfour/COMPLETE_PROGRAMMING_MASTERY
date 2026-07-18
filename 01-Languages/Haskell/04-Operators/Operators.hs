isEvenLength :: [a] -> Bool
isEvenLength = even . length   -- point-free composition, see Lesson 06

main :: IO ()
main = do
    let result1 = 2 + 3
        result2 = (+) 2 3      -- exact same function, called prefix
    putStrLn ("result1 == result2: " ++ show (result1 == result2))

    putStrLn ("7 `div` 2 = " ++ show (7 `div` (2 :: Int)))
    putStrLn ("7 `mod` 2 = " ++ show (7 `mod` (2 :: Int)))
    putStrLn ("7 / 2 = " ++ show (7 / (2 :: Double)))

    putStrLn ("2 /= 3: " ++ show (2 /= (3 :: Int)))

    let withParens  = print (length (filter even [1 .. 10 :: Int]))
        withDollar  = length $ filter even [1 .. 10 :: Int]
    _ <- withParens
    putStrLn ("$ eliminates parens, same result: " ++ show (withDollar == length (filter even [1 .. 10 :: Int])))

    putStrLn ("isEvenLength [1,2,3,4]: " ++ show (isEvenLength [1, 2, 3, 4 :: Int]))
    putStrLn ("isEvenLength [1,2,3]: " ++ show (isEvenLength [1, 2, 3 :: Int]))
