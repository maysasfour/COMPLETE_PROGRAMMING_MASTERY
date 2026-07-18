{-# LANGUAGE OverloadedStrings #-}
-- The thin IO shell -- the only module in this project allowed to touch SQLite.
-- Reuses Lesson 16's sqlite-simple setup exactly (same OverloadedStrings requirement,
-- same parameterized-query discipline) rather than inventing a new persistence approach.
module Storage
  ( initDb
  , loadTasks
  , insertTask
  , setTaskDone
  , deleteTask
  ) where

import Database.SQLite.Simple
import Tasks (Task (..))

initDb :: FilePath -> IO Connection
initDb path = do
  conn <- open path
  execute_ conn
    "CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, done INTEGER NOT NULL)"
  return conn

loadTasks :: Connection -> IO [Task]
loadTasks conn = do
  rows <- query_ conn "SELECT id, name, done FROM tasks ORDER BY id" :: IO [(Int, String, Int)]
  return [Task tid name (done /= 0) | (tid, name, done) <- rows]

-- Returns the inserted task's real id -- `lastInsertRowId` gives SQLite's own
-- AUTOINCREMENT value, since Tasks.addTask's own id-guessing logic is only used
-- for the pure, database-free unit tests, not for anything actually persisted.
insertTask :: Connection -> String -> IO Task
insertTask conn name = do
  execute conn "INSERT INTO tasks (name, done) VALUES (?, ?)" (name, 0 :: Int)
  rid <- lastInsertRowId conn
  return (Task (fromIntegral rid) name False)

setTaskDone :: Connection -> Int -> IO ()
setTaskDone conn tid = execute conn "UPDATE tasks SET done = 1 WHERE id = ?" (Only tid)

deleteTask :: Connection -> Int -> IO ()
deleteTask conn tid = execute conn "DELETE FROM tasks WHERE id = ?" (Only tid)
