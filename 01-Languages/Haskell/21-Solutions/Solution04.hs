class Summary a where
  shortSummary :: a -> String
  longSummary  :: a -> String
  longSummary x = "Details: " ++ shortSummary x   -- default implementation

data Book  = Book  { bookTitle :: String, bookRating :: Int }
data Movie = Movie { movieTitle :: String, movieRating :: Int }

instance Summary Book where
  shortSummary b = bookTitle b ++ " (" ++ show (bookRating b) ++ "/10)"
  -- longSummary relies entirely on the default above

instance Summary Movie where
  shortSummary m = movieTitle m ++ " (" ++ show (movieRating m) ++ "/10)"
  longSummary m = "Now showing: " ++ shortSummary m ++ " -- a custom override, not the default"

main :: IO ()
main = do
  let b = Book "Learn You a Haskell" 9
  let m = Movie "The Matrix" 10
  putStrLn (shortSummary b)
  putStrLn (longSummary b)   -- uses the default
  putStrLn (shortSummary m)
  putStrLn (longSummary m)   -- uses Movie's override
