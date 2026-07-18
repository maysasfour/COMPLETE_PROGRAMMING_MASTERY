import Data.List (foldl')
import System.CPUTime (getCPUTime)
import Text.Printf (printf)

-- Part A: genuinely infinite, lazily-generated Fibonacci sequence.
-- fibs is defined self-referentially: each element is the sum of the previous
-- two, computed only as far as demanded -- `take 15` never forces the "rest"
-- of the (conceptually endless) list.
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

-- Part B: foldl (+) 0 builds an unevaluated chain of thunks (one nested
-- "(+)" application per element) before ever adding anything, because
-- foldl is lazy in its accumulator -- for a 5-million-element list this
-- risks a stack overflow / large memory blowup. foldl' (Data.List) forces
-- the accumulator at each step, so it runs in constant extra space.
timeIt :: String -> IO Int -> IO ()
timeIt label action = do
  start <- getCPUTime
  result <- action
  end <- getCPUTime
  let seconds = fromIntegral (end - start) / (10 ^ (12 :: Int)) :: Double
  printf "%s = %d (%.3fs CPU time)\n" label result seconds

main :: IO ()
main = do
  print (take 15 fibs)

  let n = 5000000 :: Int
  timeIt "foldl  sum" (return $! foldl (+) 0 [1 .. n])
  timeIt "foldl' sum" (return $! foldl' (+) 0 [1 .. n])
