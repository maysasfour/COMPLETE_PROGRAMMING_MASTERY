-- Thin CLI/IO layer -- delegates all persistence to Storage and all list
-- formatting/logic that CAN be pure to Tasks. This walkthrough runs a fixed
-- scripted sequence of commands (add/complete/list/delete) rather than reading
-- interactive stdin, so `cabal run` produces the exact same real, captured
-- output every time -- see the README's "Verified Output" section.
module Main (main) where

import Storage
import Tasks (Task, formatTask, pendingTasks, doneTasks)
import System.Directory (removeFile, doesFileExist)
import Control.Monad (forM_, when)

dbPath :: FilePath
dbPath = "tasks.db"

printAll :: [Task] -> IO ()
printAll tasks = do
  putStrLn "Pending:"
  forM_ (pendingTasks tasks) (putStrLn . ("  " ++) . formatTask)
  putStrLn "Done:"
  forM_ (doneTasks tasks) (putStrLn . ("  " ++) . formatTask)

main :: IO ()
main = do
  -- fresh database each run, so this walkthrough's output is reproducible
  exists <- doesFileExist dbPath
  when exists (removeFile dbPath)

  conn <- initDb dbPath

  t1 <- insertTask conn "Write Haskell lesson"
  t2 <- insertTask conn "Review pull request"
  t3 <- insertTask conn "Buy groceries"
  putStrLn ("Added: " ++ formatTask t1)
  putStrLn ("Added: " ++ formatTask t2)
  putStrLn ("Added: " ++ formatTask t3)

  setTaskDone conn 1
  putStrLn "Marked task 1 done."

  deleteTask conn 3
  putStrLn "Deleted task 3."

  tasks <- loadTasks conn
  printAll tasks
