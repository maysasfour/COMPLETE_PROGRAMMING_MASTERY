-- A minimal, hand-rolled assert-based test harness.
-- Lua has no de-facto-standard built-in test framework (like C's course documents for C) --
-- Busted is the closest thing to a community standard, but it's a LuaRocks install, not
-- built in, so this lesson builds a tiny one from scratch using only pcall + assert.

local M = {}
local passed, failed = 0, 0
local failures = {}

function M.eq(actual, expected, label)
  if actual == expected then
    passed = passed + 1
  else
    failed = failed + 1
    table.insert(failures, string.format("%s: expected %s, got %s", label or "?", tostring(expected), tostring(actual)))
  end
end

function M.truthy(value, label)
  M.eq(not not value, true, label)
end

function M.test(name, fn)
  local ok, err = pcall(fn)
  if not ok then
    failed = failed + 1
    table.insert(failures, name .. " raised an error: " .. tostring(err))
  end
end

function M.summary()
  print(string.format("\n%d passed, %d failed", passed, failed))
  if #failures > 0 then
    print("Failures:")
    for _, f in ipairs(failures) do
      print("  - " .. f)
    end
  end
  return failed == 0
end

return M
