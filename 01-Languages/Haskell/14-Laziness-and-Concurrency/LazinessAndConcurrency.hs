import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar

crashes :: Int
crashes = error "this should never actually run!"

constDemo :: Int
constDemo = const 42 crashes   -- `crashes` passed in, but `const` never looks at it

firstOnly :: (Int, Int)
firstOnly = (1, crashes)       -- second element is "poisoned," but never forced below

proofFst :: Int
proofFst = fst firstOnly

forcedDemo :: Int
forcedDemo = 5 `seq` 42

strictApply :: Int
strictApply = id $! (2 + 2)

concurrencyDemo :: IO String
concurrencyDemo = do
    mvar <- newEmptyMVar
    _ <- forkIO $ do
        threadDelay 10000
        putMVar mvar "done from another thread"
    takeMVar mvar

main :: IO ()
main = do
    putStrLn ("constDemo (const 42 crashes) = " ++ show constDemo)
    putStrLn ("proofFst (fst (1, crashes)) = " ++ show proofFst)
    putStrLn "No crash happened -- the `error` calls above were genuinely never evaluated."

    putStrLn ("forcedDemo = " ++ show forcedDemo)
    putStrLn ("strictApply = " ++ show strictApply)

    result <- concurrencyDemo
    putStrLn ("concurrency demo result: " ++ result)
