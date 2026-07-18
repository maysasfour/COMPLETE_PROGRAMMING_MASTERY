primes :: [Integer]
primes = sieve [2 ..]
  where
    sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
    sieve []       = []

chunk :: Int -> [a] -> [[a]]
chunk _ [] = []
chunk n xs = let (h, t) = splitAt n xs in h : chunk n t

rotateLeft :: (a, b, c) -> (b, c, a)
rotateLeft (a, b, c) = (b, c, a)

main :: IO ()
main = do
    putStrLn ("take 10 primes = " ++ show (take 10 primes))
    putStrLn ("chunk 3 [1..10] = " ++ show (chunk 3 [1 .. 10 :: Int]))
    putStrLn ("rotateLeft (1,\"two\",True) = " ++ show (rotateLeft (1 :: Int, "two", True)))
