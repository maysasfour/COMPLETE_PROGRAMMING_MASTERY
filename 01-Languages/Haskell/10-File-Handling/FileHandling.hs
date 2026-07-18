import Data.Char (toUpper)

main :: IO ()
main = do
    writeFile "notes.txt" "first line\n"
    putStrLn "Wrote notes.txt"

    contents1 <- readFile "notes.txt"
    putStrLn "Contents after write:"
    putStr contents1     -- fully forced by putStr, so the file handle is done with

    appendFile "notes.txt" "second line\n"

    contents2 <- readFile "notes.txt"
    putStrLn "Contents after append:"
    putStr contents2

    putStrLn "Uppercased:"
    -- `contents2` (an ordinary String at this point, already read) can be freely
    -- passed to a pure function -- the IO boundary was already crossed by `<-` above.
    putStr (map toUpper contents2)
