import Text.Printf (printf)

data Shape = Circle Double | Rectangle Double Double | Triangle Double Double

area :: Shape -> Double
area (Circle r)        = pi * r * r
area (Rectangle w h)   = w * h
area (Triangle b h)    = 0.5 * b * h

describe :: Shape -> String
describe s@(Circle _)      = printf "Circle with area %.2f" (area s)
describe s@(Rectangle _ _) = printf "Rectangle with area %.2f" (area s)
describe s@(Triangle _ _)  = printf "Triangle with area %.2f" (area s)

main :: IO ()
main = do
  putStrLn (describe (Circle 5))
  putStrLn (describe (Rectangle 4 6))
  putStrLn (describe (Triangle 3 8))
