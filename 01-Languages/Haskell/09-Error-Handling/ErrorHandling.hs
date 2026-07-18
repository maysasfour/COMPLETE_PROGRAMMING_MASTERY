import Control.Exception (evaluate, try, SomeException)

safeDivide :: Int -> Int -> Maybe Int
safeDivide _ 0 = Nothing
safeDivide a b = Just (a `div` b)

describe :: Maybe Int -> String
describe Nothing  = "no result"
describe (Just x) = "result: " ++ show x

doubled :: Maybe Int -> Maybe Int
doubled = fmap (* 2)

withDefault :: Maybe Int -> Int
withDefault = maybe 0 id

data ValidationError = TooYoung | TooOld deriving Show

validateAge :: Int -> Either ValidationError Int
validateAge age
  | age < 0   = Left TooYoung
  | age > 150 = Left TooOld
  | otherwise = Right age

safeHead :: [a] -> Maybe a
safeHead []      = Nothing
safeHead (x : _) = Just x

main :: IO ()
main = do
    putStrLn ("safeDivide 10 2 = " ++ show (safeDivide 10 2))
    putStrLn ("safeDivide 10 0 = " ++ show (safeDivide 10 0))
    putStrLn ("describe (safeDivide 10 2) = " ++ describe (safeDivide 10 2))
    putStrLn ("describe (safeDivide 10 0) = " ++ describe (safeDivide 10 0))
    putStrLn ("doubled (Just 5) = " ++ show (doubled (Just 5)))
    putStrLn ("withDefault Nothing = " ++ show (withDefault Nothing))
    putStrLn ("validateAge (-1) = " ++ show (validateAge (-1)))
    putStrLn ("validateAge 200 = " ++ show (validateAge 200))
    putStrLn ("validateAge 30 = " ++ show (validateAge 30))
    putStrLn ("safeHead [1,2,3] = " ++ show (safeHead [1, 2, 3 :: Int]))
    putStrLn ("safeHead ([] :: [Int]) = " ++ show (safeHead ([] :: [Int])))

    -- Prove `head []` really does crash, catching the exception explicitly
    -- (Control.Exception, previewed here -- Lesson 10 covers IO/exceptions properly)
    -- rather than letting it take down the whole program.
    result <- try (evaluate (head ([] :: [Int]))) :: IO (Either SomeException Int)
    case result of
        Left _  -> putStrLn "head [] would crash: True"
        Right _ -> putStrLn "head [] would crash: False"
