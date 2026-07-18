print("=== 1. Global-leak audit ===")
function leaky_ex()
  audited_leak = "leaked on purpose"
end
leaky_ex()
print("leak proven via _G:", _G.audited_leak)
local function fixed_ex()
  local contained = "stays local"
  return contained
end
print("fixed version returns:", fixed_ex())
print("no leak this time:", _G.contained)

print("\n=== 2. Sum at even 1-based indices ===")
local function sum_even_indices(t)
  local total = 0
  local included = {}
  for i = 2, #t, 2 do
    total = total + t[i]
    table.insert(included, "t[" .. i .. "]=" .. t[i])
  end
  return total, included
end
local total, included = sum_even_indices({10, 20, 30, 40})
print("included:", table.concat(included, ", "))
print("sum:", total)

print("\n=== 3. stats(...) multiple returns ===")
local function stats(...)
  local args = {...}
  local count = #args
  local sum = 0
  for _, v in ipairs(args) do sum = sum + v end
  return count, sum, sum / count
end
local c, s, avg = stats(4, 8, 15, 16, 23, 42)
print(string.format("count=%d sum=%d avg=%.2f", c, s, avg))

print("\n=== 4. Pattern-match key=value parser ===")
local function parse_kv(str)
  local result = {}
  for k, v in str:gmatch("(%a+)=([^;]+)") do
    result[k] = v
  end
  return result
end
local parsed = parse_kv("name=Ada;age=36;city=Lima")
print(parsed.name, parsed.age, parsed.city)

print("\n=== 5. Shape/Circle metatable inheritance ===")
local Shape = {}
Shape.__index = Shape
function Shape.new() return setmetatable({}, Shape) end
function Shape:area() return 0 end

local Circle = setmetatable({}, {__index = Shape})
Circle.__index = Circle
function Circle.new(radius)
  local self = Shape.new()
  self.radius = radius
  return setmetatable(self, Circle)
end
function Circle:area() return self.radius ^ 2 * math.pi end

local generic = Shape.new()
local circle = Circle.new(3)
print("generic shape area:", generic:area())
print(string.format("circle area: %.4f", circle:area()))

print("\n=== 6. Coroutine even-number generator ===")
local function evens_up_to(n)
  return coroutine.wrap(function()
    for i = 1, n do
      if i % 2 == 0 then coroutine.yield(i) end
    end
  end)
end
io.write("evens up to 12: ")
for e in evens_up_to(12) do io.write(e, " ") end
print()

print("\n=== 7. Error-safe parser ===")
local function parse_number(str)
  local n = tonumber(str)
  if not n then
    error("'" .. str .. "' is not a valid number")
  end
  return n
end
local function safe_parse(str)
  local ok, result = pcall(parse_number, str)
  if ok then
    print("parsed:", result)
  else
    print("failed to parse: " .. result)
  end
end
safe_parse("42")
safe_parse("not a number")

print("\n=== 8. Hand-rolled test for is_even ===")
local t = require("testkit")
local function is_even(n) return n % 2 == 0 end
t.test("is_even(4) is true", function() t.truthy(is_even(4), "4 is even") end)
t.test("is_even(4) is deliberately asserted false (should fail)", function()
  t.eq(is_even(4), false, "intentionally wrong expectation")
end)
t.summary()
