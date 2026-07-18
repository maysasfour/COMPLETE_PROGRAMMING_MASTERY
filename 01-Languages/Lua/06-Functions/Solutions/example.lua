-- 1. closure factory
local function make_multiplier(n)
  return function(x) return x * n end
end
local times3, times5 = make_multiplier(3), make_multiplier(5)
print("times3(4) =", times3(4), " times5(4) =", times5(4), " independent:", times3(4) ~= times5(4))

-- 2. variadic max
local function max_of(...)
  local args = {...}
  local best = args[1]
  for i = 2, #args do
    if args[i] > best then best = args[i] end
  end
  return best
end
print("max_of(3,7,2,9,4) =", max_of(3, 7, 2, 9, 4))

-- 3. safe divide with multiple returns
local function divide(a, b)
  if b == 0 then return nil, false end
  return a / b, true
end
local q1, ok1 = divide(10, 2)
local q2, ok2 = divide(10, 0)
print("divide(10,2) =", q1, ok1)
print("divide(10,0) =", q2, ok2)

-- 4. first + rest
local function first_and_rest(...)
  local args = {...}
  local first = args[1]
  local rest = {}
  for i = 2, #args do table.insert(rest, args[i]) end
  return first, rest
end
local f, r = first_and_rest(1, 2, 3, 4)
print("first =", f, " rest =", table.concat(r, ","))
