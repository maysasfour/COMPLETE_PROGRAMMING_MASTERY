-- Closures revisited: functions as stateful, independent objects (see also Lesson 06)
local function make_adder(n)
  return function(x) return x + n end
end
local add5 = make_adder(5)
local add10 = make_adder(10)
print(add5(1), add10(1))   -- 6, 11 -- independent captured `n`

-- Higher-order functions: functions taking/returning functions
local function map(list, fn)
  local result = {}
  for i, v in ipairs(list) do result[i] = fn(v) end
  return result
end

local function filter(list, predicate)
  local result = {}
  for _, v in ipairs(list) do
    if predicate(v) then table.insert(result, v) end
  end
  return result
end

local function reduce(list, fn, initial)
  local acc = initial
  for _, v in ipairs(list) do acc = fn(acc, v) end
  return acc
end

local nums = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local doubled = map(nums, function(x) return x * 2 end)
local evens = filter(nums, function(x) return x % 2 == 0 end)
local total = reduce(nums, function(a, b) return a + b end, 0)
print("doubled:", table.concat(doubled, ","))
print("evens:", table.concat(evens, ","))
print("sum via reduce:", total)

-- A table of functions (Lua's closest analog to a dispatch table / strategy pattern) --
-- since functions are ordinary values, they're storable as table values just like anything else
local operations = {
  add = function(a, b) return a + b end,
  sub = function(a, b) return a - b end,
  mul = function(a, b) return a * b end,
}
print("dispatch table add:", operations["add"](3, 4))
print("dispatch table mul:", operations.mul(3, 4))

-- table.sort with a custom comparator function -- a genuine higher-order-function use in stdlib
local people = {
  {name = "Carol", age = 35},
  {name = "Alice", age = 30},
  {name = "Bob", age = 25},
}
table.sort(people, function(a, b) return a.age < b.age end)
for _, p in ipairs(people) do print(p.name, p.age) end

-- sort descending by name, proving the comparator is genuinely swappable
table.sort(people, function(a, b) return a.name > b.name end)
for _, p in ipairs(people) do print(p.name) end
