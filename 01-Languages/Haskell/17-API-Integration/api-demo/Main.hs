{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
import Network.HTTP.Simple
import Data.Aeson (FromJSON, decode)
import GHC.Generics (Generic)

data Todo = Todo
  { todoId        :: Int
  , todoTitle     :: String
  , todoCompleted :: Bool
  } deriving (Show, Generic)

instance FromJSON Todo   -- DERIVED via Generic -- aeson infers the field mapping automatically

fetchTodo :: IO (Maybe Todo)
fetchTodo = do
    response <- httpLBS "https://jsonplaceholder.typicode.com/todos/1"
    return (decode (getResponseBody response))

main :: IO ()
main = do
    response <- httpLBS "https://jsonplaceholder.typicode.com/todos/1"
    putStrLn ("Status: " ++ show (getResponseStatusCode response))
    todo <- fetchTodo
    print todo

    notFound <- httpLBS "https://jsonplaceholder.typicode.com/nonexistent-path-404"
    putStrLn ("Status for a 404 path: " ++ show (getResponseStatusCode notFound))
