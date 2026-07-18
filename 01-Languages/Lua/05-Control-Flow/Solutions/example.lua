-- 1. FizzBuzz
local function fizzbuzz(n)
  for i = 1, n do
    if i % 15 == 0 then print("FizzBuzz")
    elseif i % 3 == 0 then print("Fizz")
    elseif i % 5 == 0 then print("Buzz")
    else print(i) end
  end
end
print("--- fizzbuzz(15) ---")
fizzbuzz(15)

-- 2. repeat...until a 6 is rolled
math.randomseed(42)   -- deterministic for reproducible output
print("--- dice rolls ---")
local rolls = 0
local roll
repeat
  roll = math.random(1, 6)
  rolls = rolls + 1
  print("roll " .. rolls .. ": " .. roll)
until roll == 6
print("took " .. rolls .. " rolls to get a 6")

-- 3. ipairs with index
print("--- words ---")
local words = {"lua", "is", "fun"}
for i, w in ipairs(words) do
  print(i, w)
end

-- 4. odd numbers only, via goto (no continue in Lua)
print("--- odds via goto ---")
for i = 1, 10 do
  if i % 2 == 0 then goto continue end
  io.write(i, " ")
  ::continue::
end
print()
