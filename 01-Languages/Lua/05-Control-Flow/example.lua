-- if / elseif / else / end (no `switch` in Lua at all)
local function grade(score)
  if score >= 90 then
    return "A"
  elseif score >= 80 then
    return "B"
  elseif score >= 70 then
    return "C"
  else
    return "F"
  end
end
print(grade(95), grade(82), grade(71), grade(50))

-- while
local i, sum = 1, 0
while i <= 5 do
  sum = sum + i
  i = i + 1
end
print("while sum 1..5 =", sum)

-- repeat/until: Lua's do-while equivalent -- body ALWAYS runs at least once,
-- and the condition is checked AFTER the body (distinctive: `until` sees locals from the body)
local j = 0
repeat
  j = j + 1
  print("repeat iteration", j)
until j >= 3

-- a repeat/until that proves "runs at least once" even when the condition is already true
local ran_once = false
repeat
  ran_once = true
until true
print("repeat runs body before checking condition:", ran_once)

-- numeric for: for var = start, stop[, step] do ... end
for k = 1, 5 do
  io.write(k, " ")
end
print()

for k = 10, 1, -2 do   -- explicit negative step -- required, unlike languages that infer direction
  io.write(k, " ")
end
print()

-- generic for: iterates via an iterator function -- ipairs (sequence) and pairs (all keys)
local fruits = {"apple", "banana", "cherry"}
for index, value in ipairs(fruits) do
  print(index, value)
end

local ages = {alice = 30, bob = 25}
for key, value in pairs(ages) do
  print(key, value)
end

-- break exists; there is no `continue` keyword at all (a real Lua gap) --
-- the idiomatic workaround is a `goto continue` or restructuring the loop body as a guard clause
for k = 1, 5 do
  if k == 3 then goto continue end
  io.write(k, " ")
  ::continue::
end
print()
