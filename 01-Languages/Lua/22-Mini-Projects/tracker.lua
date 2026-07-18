-- CLI Task Tracker -- the mini-project.
-- Usage:
--   lua tracker.lua add "Buy milk"
--   lua tracker.lua list
--   lua tracker.lua done 2
--   lua tracker.lua remove 1
--
-- Persistence: a hand-rolled Lua-table serializer + io.open (storage.lua), NOT a real
-- database -- see Lesson 16 for why SQLite wasn't genuinely available in this environment.

local storage = require("storage")

local DB_PATH = "tasks_data.lua"

local function next_id(tasks)
  local max_id = 0
  for _, t in ipairs(tasks) do
    if t.id > max_id then max_id = t.id end
  end
  return max_id + 1
end

local function cmd_add(tasks, title)
  if not title or title == "" then
    print("error: 'add' requires a task title")
    return false
  end
  table.insert(tasks, {id = next_id(tasks), title = title, done = false})
  print("added task #" .. tasks[#tasks].id .. ": " .. title)
  return true
end

local function cmd_list(tasks)
  if #tasks == 0 then
    print("(no tasks yet)")
    return
  end
  for _, t in ipairs(tasks) do
    local mark = t.done and "[x]" or "[ ]"
    print(string.format("%s #%d %s", mark, t.id, t.title))
  end
end

local function find_task(tasks, id)
  for i, t in ipairs(tasks) do
    if t.id == id then return t, i end
  end
  return nil
end

local function cmd_done(tasks, id_str)
  local id = tonumber(id_str)
  if not id then
    print("error: 'done' requires a numeric task id")
    return false
  end
  local task = find_task(tasks, id)
  if not task then
    print("error: no task with id " .. id)
    return false
  end
  task.done = true
  print("marked #" .. id .. " done")
  return true
end

local function cmd_remove(tasks, id_str)
  local id = tonumber(id_str)
  if not id then
    print("error: 'remove' requires a numeric task id")
    return false
  end
  local task, index = find_task(tasks, id)
  if not task then
    print("error: no task with id " .. id)
    return false
  end
  table.remove(tasks, index)
  print("removed #" .. id)
  return true
end

local function main(args)
  local tasks = storage.load(DB_PATH)
  local command = args[1]
  local changed = false

  if command == "add" then
    changed = cmd_add(tasks, args[2])
  elseif command == "list" then
    cmd_list(tasks)
  elseif command == "done" then
    changed = cmd_done(tasks, args[2])
  elseif command == "remove" then
    changed = cmd_remove(tasks, args[2])
  else
    print("usage: lua tracker.lua <add|list|done|remove> [args]")
  end

  if changed then
    local ok, err = storage.save(DB_PATH, tasks)
    if not ok then
      print("warning: failed to save: " .. tostring(err))
    end
  end
end

-- `arg` is Lua's global table of command-line arguments when run as a script
main(arg)
