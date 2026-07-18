module Calculator (add, safeDivide) where

add :: Int -> Int -> Int
add x y = x + y

safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide a b = Just (a `div` b)
