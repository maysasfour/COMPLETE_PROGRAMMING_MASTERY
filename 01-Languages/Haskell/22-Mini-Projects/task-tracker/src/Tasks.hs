-- Pure task-list logic -- no IO anywhere in this module (Lesson 19's discipline).
-- Because nothing here touches the database or the console, every function is
-- testable by direct call-and-assert (Lesson 18), with the actual persistence
-- layer (Storage.hs) kept as a thin IO shell around this pure core.
module Tasks
  ( Task (..)
  , addTask
  , completeTask
  , removeTask
  , pendingTasks
  , doneTasks
  , formatTask
  ) where

data Task = Task
  { taskId   :: Int
  , taskName :: String
  , taskDone :: Bool
  } deriving (Show, Eq)

-- Appends a new task with the next available id (max existing id + 1, or 1 for an empty list).
-- Computing the id here (rather than letting SQLite's AUTOINCREMENT be the only source of
-- truth) keeps this function pure and testable without a database at all.
addTask :: String -> [Task] -> [Task]
addTask name tasks = tasks ++ [Task nextId name False]
  where
    nextId = if null tasks then 1 else maximum (map taskId tasks) + 1

-- Total: marks a task done by id if it exists, otherwise returns the list unchanged
-- (no partial function, no crash on an unknown id -- Lesson 19's central discipline).
completeTask :: Int -> [Task] -> [Task]
completeTask tid = map markIfMatch
  where
    markIfMatch t
      | taskId t == tid = t { taskDone = True }
      | otherwise        = t

removeTask :: Int -> [Task] -> [Task]
removeTask tid = filter ((/= tid) . taskId)

pendingTasks :: [Task] -> [Task]
pendingTasks = filter (not . taskDone)

doneTasks :: [Task] -> [Task]
doneTasks = filter taskDone

formatTask :: Task -> String
formatTask (Task tid name done) =
  "[" ++ (if done then "x" else " ") ++ "] " ++ show tid ++ ". " ++ name
