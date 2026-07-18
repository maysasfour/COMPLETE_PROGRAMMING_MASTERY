myMap :: (a -> b) -> [a] -> [b]
myMap _ []       = []
myMap f (x : xs) = f x : myMap f xs

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter _ []       = []
myFilter p (x : xs)
  | p x       = x : myFilter p xs
  | otherwise = myFilter p xs

myFoldr :: (a -> b -> b) -> b -> [a] -> b
myFoldr _ z []       = z
myFoldr f z (x : xs) = f x (myFoldr f z xs)

-- Pipeline built from OUR OWN recursive versions, via composition:
sumEvenSquaresMine :: [Int] -> Int
sumEvenSquaresMine = myFoldr (+) 0 . myMap (^ 2) . myFilter even

-- The same pipeline built from Prelude's built-ins, via composition:
sumEvenSquaresPrelude :: [Int] -> Int
sumEvenSquaresPrelude = foldr (+) 0 . map (^ 2) . filter even

main :: IO ()
main = do
  let xs = [1 .. 10]
  print (sumEvenSquaresMine xs)
  print (sumEvenSquaresPrelude xs)
  print (sumEvenSquaresMine xs == sumEvenSquaresPrelude xs)
