import Data.Char (toUpper)

greeting :: String
greeting = "Hello"

greetingAsList :: [Char]
greetingAsList = ['H', 'e', 'l', 'l', 'o']

sameValue :: Bool
sameValue = greeting == greetingAsList

shout :: String -> String
shout = map toUpper

countLetter :: Char -> String -> Int
countLetter c = length . filter (== c)

reversedGreeting :: String
reversedGreeting = reverse greeting

main :: IO ()
main = do
    putStrLn ("greeting == greetingAsList: " ++ show sameValue)
    putStrLn ("shout \"hello\" = " ++ shout "hello")
    putStrLn ("countLetter 'l' \"hello world\" = " ++ show (countLetter 'l' "hello world"))
    putStrLn ("reversedGreeting = " ++ reversedGreeting)
    putStrLn ("length \"hello\" = " ++ show (length "hello"))
    putStrLn ("\"hello\" ++ \" \" ++ \"world\" = " ++ ("hello" ++ " " ++ "world"))
    putStrLn ("words \"the quick brown fox\" = " ++ show (words "the quick brown fox"))
    putStrLn ("unwords [\"the\",\"quick\",\"brown\",\"fox\"] = " ++ unwords ["the", "quick", "brown", "fox"])
