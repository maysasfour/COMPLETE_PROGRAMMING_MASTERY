xs :: [Int]
xs = [1, 2, 3, 4, 5]

consed :: [Int]
consed = 0 : xs

point :: (Int, Int)
point = (3, 4)

personRecord :: (String, Int, Bool)
personRecord = ("Ada", 36, True)

getName :: (String, Int, Bool) -> String
getName (name, _, _) = name

squares :: [Int]
squares = [x * x | x <- [1 .. 10]]

evens :: [Int]
evens = [x | x <- [1 .. 20], even x]

pairs :: [(Int, Int)]
pairs = [(x, y) | x <- [1 .. 3], y <- [1 .. 3], x /= y]

naturals :: [Integer]
naturals = [1 ..]   -- genuinely infinite

fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)   -- infinite, self-referential

firstTenNaturals :: [Integer]
firstTenNaturals = take 10 naturals

firstTenFibs :: [Integer]
firstTenFibs = take 10 fibs

main :: IO ()
main = do
    putStrLn ("xs = " ++ show xs)
    putStrLn ("consed = " ++ show consed)
    putStrLn ("point = " ++ show point)
    putStrLn ("personRecord name = " ++ getName personRecord)
    putStrLn ("squares = " ++ show squares)
    putStrLn ("evens = " ++ show evens)
    putStrLn ("pairs = " ++ show pairs)

    -- The key live proof: these `take`s terminate INSTANTLY despite `naturals`
    -- and `fibs` having no upper bound in their own definitions.
    putStrLn ("firstTenNaturals = " ++ show firstTenNaturals)
    putStrLn ("firstTenFibs = " ++ show firstTenFibs)

    putStrLn ("list append (++) O(n) demo: " ++ show (xs ++ [6]))
    putStrLn ("random access xs !! 3 = " ++ show (xs !! 3))
