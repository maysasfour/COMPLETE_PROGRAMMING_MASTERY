data RegError = EmptyName | InvalidAge | WeakPassword deriving Show

checkName :: String -> Either RegError String
checkName n
  | null n    = Left EmptyName
  | otherwise = Right n

checkAge :: Int -> Either RegError Int
checkAge a
  | a >= 13 && a <= 120 = Right a
  | otherwise           = Left InvalidAge

checkPassword :: String -> Either RegError String
checkPassword p
  | length p >= 8 = Right p
  | otherwise     = Left WeakPassword

validateUser :: String -> Int -> String -> Either RegError (String, Int, String)
validateUser name age password = do
  n <- checkName name
  a <- checkAge age
  p <- checkPassword password
  return (n, a, p)

main :: IO ()
main = do
  print (validateUser "Ada" 30 "hunter22")
  print (validateUser "" 30 "hunter22")
  print (validateUser "Ada" 5 "hunter22")
  print (validateUser "Ada" 30 "short")
