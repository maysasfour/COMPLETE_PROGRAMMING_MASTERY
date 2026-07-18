identity :: a -> a
identity x = x

firstOf :: (a, b) -> a
firstOf (x, _) = x

newtype Stack a = Stack [a] deriving Show

push :: a -> Stack a -> Stack a
push x (Stack xs) = Stack (x : xs)

pop :: Stack a -> Maybe (a, Stack a)
pop (Stack [])       = Nothing
pop (Stack (x : xs)) = Just (x, Stack xs)

allEqual :: Eq a => [a] -> Bool
allEqual []       = True
allEqual (x : xs) = all (== x) xs

myMaximum :: Ord a => [a] -> a
myMaximum [x]      = x
myMaximum (x : xs) = max x (myMaximum xs)

describeIfBigger :: (Ord a, Show a) => a -> a -> String
describeIfBigger x y
  | x > y     = show x ++ " is bigger than " ++ show y
  | otherwise = show y ++ " is bigger than or equal to " ++ show x

main :: IO ()
main = do
    putStrLn ("identity 42 = " ++ show (identity (42 :: Int)))
    putStrLn ("identity \"hello\" = " ++ identity "hello")
    putStrLn ("firstOf (1,\"two\") = " ++ show (firstOf (1 :: Int, "two")))

    let stack0 = Stack ([] :: [Int])
        stack1 = push 1 stack0
        stack2 = push 2 stack1
    putStrLn ("Stack after two pushes, popped once: " ++ show (pop stack2))

    putStrLn ("allEqual [1,1,1] = " ++ show (allEqual [1, 1, 1 :: Int]))
    putStrLn ("allEqual [1,2,1] = " ++ show (allEqual [1, 2, 1 :: Int]))
    putStrLn ("myMaximum [3,7,2,9,4] = " ++ show (myMaximum [3, 7, 2, 9, 4 :: Int]))
    putStrLn ("describeIfBigger 5 3 = " ++ describeIfBigger (5 :: Int) 3)
