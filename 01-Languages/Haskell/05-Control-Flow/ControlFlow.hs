sumTo :: Int -> Int
sumTo 0 = 0
sumTo n = n + sumTo (n - 1)

sumToHOF :: Int -> Int
sumToHOF n = sum [1 .. n]

classify :: Int -> String
classify n = if n < 0 then "negative" else if n == 0 then "zero" else "positive"

describe :: Int -> String
describe n = "Number is " ++ (if even n then "even" else "odd")

bmiCategory :: Double -> String
bmiCategory bmi
  | bmi < 18.5 = "underweight"
  | bmi < 25.0 = "normal"
  | bmi < 30.0 = "overweight"
  | otherwise  = "obese"

main :: IO ()
main = do
    putStrLn ("sumTo 5 = " ++ show (sumTo 5))
    putStrLn ("sumToHOF 5 = " ++ show (sumToHOF 5))
    putStrLn ("sumTo 5 == sumToHOF 5: " ++ show (sumTo 5 == sumToHOF 5))

    putStrLn ("classify (-3) = " ++ classify (-3))
    putStrLn ("classify 0 = " ++ classify 0)
    putStrLn ("classify 7 = " ++ classify 7)

    putStrLn ("describe 4 = " ++ describe 4)
    putStrLn ("describe 7 = " ++ describe 7)

    putStrLn ("bmiCategory 17.0 = " ++ bmiCategory 17.0)
    putStrLn ("bmiCategory 22.0 = " ++ bmiCategory 22.0)
    putStrLn ("bmiCategory 27.0 = " ++ bmiCategory 27.0)
    putStrLn ("bmiCategory 35.0 = " ++ bmiCategory 35.0)
