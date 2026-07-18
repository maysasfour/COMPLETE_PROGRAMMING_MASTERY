fizzbuzz :: Int -> String
fizzbuzz n
  | n `mod` 15 == 0 = "FizzBuzz"
  | n `mod` 3  == 0 = "Fizz"
  | n `mod` 5  == 0 = "Buzz"
  | otherwise       = show n

fizzbuzzRange :: Int -> Int -> [String]
fizzbuzzRange lo hi = map fizzbuzz [lo .. hi]

countdown :: Int -> [String]
countdown 0 = ["Liftoff!"]
countdown n = show n : countdown (n - 1)

main :: IO ()
main = do
    print (fizzbuzzRange 1 15)
    print (countdown 3)
