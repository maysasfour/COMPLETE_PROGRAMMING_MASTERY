type Config = [(String, String)]

lookupConfig :: String -> Config -> Maybe String
lookupConfig = lookup

lookupPort :: Config -> Maybe Int
lookupPort cfg = do
  raw <- lookupConfig "port" cfg
  case reads raw of
    [(n, "")] -> Just n
    _         -> Nothing

main :: IO ()
main = do
  let goodCfg = [("host", "localhost"), ("port", "8080")]
  let badCfg  = [("host", "localhost"), ("port", "not-a-number")]
  let missingCfg = [("host", "localhost")]
  print (lookupPort goodCfg)
  print (lookupPort badCfg)
  print (lookupPort missingCfg)
