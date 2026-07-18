{-# LANGUAGE OverloadedStrings #-}
import Database.SQLite.Simple
import System.Directory (removeFile, doesFileExist)

main :: IO ()
main = do
    -- start from a clean file each run, so this demo is repeatable
    exists <- doesFileExist "tasks.db"
    if exists then removeFile "tasks.db" else pure ()

    conn <- open "tasks.db"
    execute_ conn "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, done INTEGER)"
    putStrLn "Created table."

    execute conn "INSERT INTO tasks (title, done) VALUES (?, ?)" ("Buy milk" :: String, 0 :: Int)
    putStrLn "Inserted task: Buy milk"

    allTasks <- query_ conn "SELECT id, title, done FROM tasks" :: IO [(Int, String, Int)]
    putStrLn ("All tasks: " ++ show allTasks)

    execute conn "UPDATE tasks SET done = 1 WHERE id = ?" (Only (1 :: Int))
    putStrLn "Marked done: 1"

    afterUpdate <- query_ conn "SELECT id, title, done FROM tasks" :: IO [(Int, String, Int)]
    putStrLn ("After update: " ++ show afterUpdate)

    execute conn "DELETE FROM tasks WHERE id = ?" (Only (1 :: Int))
    afterDelete <- query_ conn "SELECT id, title, done FROM tasks" :: IO [(Int, String, Int)]
    putStrLn ("After delete: " ++ show afterDelete)

    close conn
