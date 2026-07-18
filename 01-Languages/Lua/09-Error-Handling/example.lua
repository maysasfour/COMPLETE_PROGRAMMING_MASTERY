-- Lua has no try/catch/exception hierarchy at all -- unlike EVERY other language course
-- in this repository. Errors are raised with error() and caught with pcall/xpcall.

local function risky(x)
  if x < 0 then
    error("x must not be negative")   -- raises a Lua error, unwinding the stack like an exception
  end
  return math.sqrt(x)
end

-- pcall = "protected call" -- runs a function, catching any error() or runtime error
-- returns (true, result...) on success, or (false, error_message) on failure
local ok, result = pcall(risky, 16)
print("pcall(risky, 16):", ok, result)

local ok2, err = pcall(risky, -4)
print("pcall(risky, -4):", ok2, err)   -- ok2 is false, err is the error message string

-- Uncaught runtime errors (not just error() calls) are ALSO catchable via pcall
local ok3, err3 = pcall(function() return nil + 1 end)
print("pcall on real runtime error:", ok3, err3)

-- error() can raise any value, not just a string -- often a table for structured errors
local function structured_fail()
  error({code = 404, message = "not found"})
end
local ok4, err4 = pcall(structured_fail)
print("structured error caught:", ok4, err4.code, err4.message)

-- xpcall lets you supply a custom handler, e.g. to attach a traceback before the stack unwinds
local function handler(err)
  return "handled: " .. tostring(err)
end
local ok5, msg5 = xpcall(risky, handler, -1)
print("xpcall result:", ok5, msg5)

-- assert() is a shorthand: raises an error if its first argument is falsy
local function must_positive(x)
  assert(x > 0, "expected a positive number, got " .. tostring(x))
  return x
end
local ok6, err6 = pcall(must_positive, -5)
print("assert-based check:", ok6, err6)

print([[
CONTRAST vs. this repo's other courses:
  Ruby/PHP/Python/Java: begin/rescue, try/catch, try/except -- exceptions are a first-class
  language construct with typed hierarchies (StandardError, Exception subclasses, etc).
  Lua: error()/pcall()/xpcall() are ordinary functions, not keywords (except `error` itself
  isn't even a keyword -- it's a global function you could theoretically overwrite).
  There is no exception TYPE system at all -- error() can raise a string, a table, anything.
]])
