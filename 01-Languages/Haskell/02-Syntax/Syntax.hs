circleArea :: Double -> Double
circleArea r = pi * rSquared
  where
    rSquared = r * r   -- `where` -- scoped to the whole circleArea definition

circleAreaLet :: Double -> Double
circleAreaLet r =
    let rSquared = r * r   -- `let ... in` -- scoped only to the expression after `in`
    in pi * rSquared

main :: IO ()
main = do
    putStrLn "a"
    putStrLn "b"
    putStrLn ("Area (where): " ++ show (circleArea 5.0))
    putStrLn ("Area (let):   " ++ show (circleAreaLet 5.0))
