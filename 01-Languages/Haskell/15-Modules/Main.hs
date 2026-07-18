import MathUtils (add, multiply)
import Data.List (sort)
import qualified Data.Map as Map

main :: IO ()
main = do
    putStrLn ("add 2 3 = " ++ show (add 2 3))
    putStrLn ("multiply 2 3 = " ++ show (multiply 2 3))
    putStrLn ("sorted [3,1,2] = " ++ show (sort [3, 1, 2 :: Int]))

    let m = Map.fromList [("a", 1 :: Int), ("b", 2)]
    putStrLn ("Map lookup \"b\" = " ++ show (Map.lookup "b" m))
