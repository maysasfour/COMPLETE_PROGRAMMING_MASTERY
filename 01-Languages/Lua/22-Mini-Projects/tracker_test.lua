local t = require("testkit")
local storage = require("storage")

local TEST_DB = "test_tasks_data.lua"
os.remove(TEST_DB)   -- ensure a clean slate

t.test("loading a nonexistent storage file returns an empty task list, not an error", function()
  local tasks = storage.load(TEST_DB)
  t.eq(#tasks, 0, "empty task list on first load")
end)

t.test("save() then load() round-trips task data correctly", function()
  local tasks = {
    {id = 1, title = "Buy milk", done = false},
    {id = 2, title = "Write Lua course", done = true},
  }
  local ok = storage.save(TEST_DB, tasks)
  t.truthy(ok, "save() reports success")

  local loaded = storage.load(TEST_DB)
  t.eq(#loaded, 2, "round-tripped task count")
  t.eq(loaded[1].title, "Buy milk", "round-tripped title (task 1)")
  t.eq(loaded[2].done, true, "round-tripped boolean field (task 2)")
end)

t.test("save() correctly escapes a title containing quotes and special characters", function()
  local tasks = {
    {id = 1, title = 'Say "hello" & use a tab\t', done = false},
  }
  storage.save(TEST_DB, tasks)
  local loaded = storage.load(TEST_DB)
  t.eq(loaded[1].title, 'Say "hello" & use a tab\t', "quotes/tab survive a save+load round trip")
end)

t.test("adding a task assigns the next sequential id", function()
  local tasks = {{id = 1, title = "first", done = false}, {id = 5, title = "gap", done = false}}
  local max_id = 0
  for _, task in ipairs(tasks) do
    if task.id > max_id then max_id = task.id end
  end
  t.eq(max_id + 1, 6, "next id accounts for a non-contiguous existing id")
end)

os.remove(TEST_DB)   -- clean up the test's own scratch file

local ok = t.summary()
os.exit(ok and 0 or 1)
