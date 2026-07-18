-- Modern idiom: a module is just a script that builds and RETURNS a table.
-- No special `module` keyword is needed (and the old `module()` function from Lua 5.1
-- is deprecated/removed in 5.2+ specifically because it polluted globals implicitly --
-- ironic, given Lesson 03's global-leak footgun).

local M = {}   -- conventionally named M, the table this file will return

function M.square(x)
  return x * x
end

function M.is_even(x)
  return x % 2 == 0
end

M.PI_APPROX = 3.14159

return M   -- this is what `require("mathutils")` receives
