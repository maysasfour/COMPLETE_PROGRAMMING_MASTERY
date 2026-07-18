age :: Int
age = 30

piApprox :: Double
piApprox = 3.14159

initial :: Char
initial = 'A'

isReady :: Bool
isReady = True

bigNum :: Integer
bigNum = 123456789012345678901234567890  -- far beyond Int's 64-bit range

main :: IO ()
main = do
    -- Shadowing demo: the second `let x = ...` does NOT mutate the first --
    -- it introduces a new binding. Both prints below see x = 5, since the
    -- original binding is genuinely never changed.
    let x = 5
    print x
    print x

    putStrLn ("age: " ++ show age ++ " :: Int")
    putStrLn ("pi_approx: " ++ show piApprox ++ " :: Double")
    putStrLn ("initial: " ++ [initial] ++ " :: Char")
    putStrLn ("isReady: " ++ show isReady ++ " :: Bool")
    putStrLn ("bigNum: " ++ show bigNum)
