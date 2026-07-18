-- File-based persistence using a hand-rolled Lua-table serializer.
-- No SQLite binding was confirmed genuinely installable in this environment (see Lesson 16),
-- so this mini-project uses io.open + a serializer that writes valid Lua table SYNTAX to
-- disk, then reads it back by running it through `load()` -- an idiomatic Lua technique
-- (the saved file is literally executable Lua source that evaluates to a table).

local M = {}

-- Turn a Lua value into Lua source text representing it (handles the shapes this
-- project actually needs: numbers, strings, booleans, and array-of-tables).
local function serialize(value, indent)
  indent = indent or ""
  local t = type(value)
  if t == "string" then
    return string.format("%q", value)
  elseif t == "number" or t == "boolean" then
    return tostring(value)
  elseif t == "table" then
    local parts = {"{\n"}
    for _, v in ipairs(value) do
      table.insert(parts, indent .. "  " .. serialize(v, indent .. "  ") .. ",\n")
    end
    table.insert(parts, indent .. "}")
    return table.concat(parts)
  else
    error("cannot serialize value of type " .. t)
  end
end

-- A single task is itself a table -- serialize it as {id=.., title=.., done=..}
local function serialize_task(task)
  return string.format(
    "{id = %d, title = %s, done = %s}",
    task.id, string.format("%q", task.title), tostring(task.done)
  )
end

function M.save(path, tasks)
  local f, err = io.open(path, "w")
  if not f then return false, err end
  f:write("return {\n")
  for _, task in ipairs(tasks) do
    f:write("  " .. serialize_task(task) .. ",\n")
  end
  f:write("}\n")
  f:close()
  return true
end

function M.load(path)
  local f = io.open(path, "r")
  if not f then
    return {}   -- no file yet -- start with an empty task list, not an error
  end
  f:close()
  -- `loadfile` compiles the file as a Lua chunk and returns a callable that,
  -- when invoked, executes it -- since the file's content is `return {...}`,
  -- calling the chunk evaluates to the table itself.
  local chunk, load_err = loadfile(path)
  if not chunk then
    return {}, "corrupt storage file: " .. tostring(load_err)
  end
  local ok, data = pcall(chunk)
  if not ok then
    return {}, "error executing storage file: " .. tostring(data)
  end
  return data
end

return M
