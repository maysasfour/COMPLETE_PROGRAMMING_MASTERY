local t = require("testkit")

-- code under test
local function add(a, b) return a + b end
local function is_palindrome(s)
  local rev = s:reverse()
  return s == rev
end

t.test("add() adds two numbers", function()
  t.eq(add(2, 3), 5, "add(2,3)")
  t.eq(add(-1, 1), 0, "add(-1,1)")
end)

t.test("is_palindrome detects palindromes", function()
  t.truthy(is_palindrome("level"), "level is a palindrome")
  t.eq(is_palindrome("lua"), false, "lua is not a palindrome")
end)

t.test("a deliberately failing assertion, to prove the harness reports failures", function()
  t.eq(add(2, 2), 5, "intentionally wrong expectation")
end)

t.test("a test that raises an error, to prove pcall catches it", function()
  error("boom")
end)

local ok = t.summary()
os.exit(ok and 0 or 1)
