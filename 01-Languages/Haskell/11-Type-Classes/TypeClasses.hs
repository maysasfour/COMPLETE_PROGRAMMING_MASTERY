class Speaker a where
    speak :: a -> String

data Dog = Dog { dogName :: String }
data Cat = Cat { catName :: String }

instance Speaker Dog where
    speak d = dogName d ++ " says Woof!"

instance Speaker Cat where
    speak c = catName c ++ " says Meow!"

announce :: Speaker a => a -> String
announce x = "Announcement: " ++ speak x

data Priority = Low | Medium | High deriving (Eq, Ord, Show, Enum, Bounded)

comparePriorities :: Bool
comparePriorities = Medium > Low

allPriorities :: [Priority]
allPriorities = [minBound .. maxBound]

class Describable a where
    describe :: a -> String
    describe _ = "No description available"

    shortName :: a -> String

newtype Book = Book { title :: String }

instance Describable Book where
    shortName b = title b

main :: IO ()
main = do
    putStrLn ("speak (Dog \"Rex\") = " ++ speak (Dog "Rex"))
    putStrLn ("speak (Cat \"Tom\") = " ++ speak (Cat "Tom"))
    putStrLn ("announce (Dog \"Rex\") = " ++ announce (Dog "Rex"))
    putStrLn ("Medium > Low: " ++ show comparePriorities)
    putStrLn ("allPriorities = " ++ show allPriorities)
    putStrLn ("show High = " ++ show High)
    let book = Book "Learn You a Haskell"
    putStrLn ("describe (Book \"Learn You a Haskell\") = " ++ describe book)
    putStrLn ("shortName (Book \"Learn You a Haskell\") = " ++ shortName book)
