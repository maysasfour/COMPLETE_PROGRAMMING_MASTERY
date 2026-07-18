-- Tests only the pure Tasks module -- exactly Lesson 18's point: because
-- Tasks.hs has no IO in any of its signatures, every case here is a direct
-- call-and-assert, no database mocking/setup/teardown required at all.
-- Storage.hs (the IO shell) is exercised for real by app/Main.hs's own
-- scripted walkthrough instead (see the README's Verified Output section).
import Test.Hspec
import Tasks

main :: IO ()
main = hspec $ do
  describe "addTask" $ do
    it "assigns id 1 to the first task in an empty list" $
      addTask "First" [] `shouldBe` [Task 1 "First" False]

    it "assigns the next sequential id" $
      addTask "Second" [Task 1 "First" False] `shouldBe` [Task 1 "First" False, Task 2 "Second" False]

  describe "completeTask" $ do
    it "marks the matching task done" $
      completeTask 1 [Task 1 "First" False, Task 2 "Second" False]
        `shouldBe` [Task 1 "First" True, Task 2 "Second" False]

    it "leaves the list unchanged for an id that does not exist" $
      completeTask 99 [Task 1 "First" False] `shouldBe` [Task 1 "First" False]

  describe "removeTask" $ do
    it "removes the matching task" $
      removeTask 1 [Task 1 "First" False, Task 2 "Second" False] `shouldBe` [Task 2 "Second" False]

    it "leaves the list unchanged for an id that does not exist" $
      removeTask 99 [Task 1 "First" False] `shouldBe` [Task 1 "First" False]

  describe "pendingTasks / doneTasks" $ do
    let tasks = [Task 1 "A" True, Task 2 "B" False, Task 3 "C" True]
    it "pendingTasks keeps only unfinished tasks" $
      pendingTasks tasks `shouldBe` [Task 2 "B" False]

    it "doneTasks keeps only finished tasks" $
      doneTasks tasks `shouldBe` [Task 1 "A" True, Task 3 "C" True]

  describe "formatTask" $ do
    it "renders a pending task with an empty checkbox" $
      formatTask (Task 1 "Write tests" False) `shouldBe` "[ ] 1. Write tests"

    it "renders a done task with an x checkbox" $
      formatTask (Task 2 "Ship it" True) `shouldBe` "[x] 2. Ship it"
