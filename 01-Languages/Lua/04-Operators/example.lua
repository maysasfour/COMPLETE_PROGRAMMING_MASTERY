-- Arithmetic
print(7 + 3, 7 - 3, 7 * 3, 7 / 2)   -- / is always float division in Lua 5.3+
print(7 // 2)                        -- // is floor (integer) division, distinctive vs. many languages' plain /
print(7 % 3, 2 ^ 10)                 -- % modulo, ^ exponent (not **)

-- Relational
print(1 == 1, 1 ~= 2)   -- ~= is Lua's "not equal", distinctive vs. != elsewhere
print(1 < 2, 2 <= 2, 3 > 2, 3 >= 3)

-- Logical: `and` / `or` / `not` are keywords, not symbols like && || !
print(true and false, true or false, not true)
-- and/or short-circuit and return one of the operands (not necessarily a boolean) -- like JS ||/&&
print(nil or "default value")     -- common idiom for a default
print(false and "unreached")

-- String concatenation: `..` -- NOT `+` (which is reserved for numeric addition)
local greeting = "hello" .. " " .. "world"
print(greeting)
print("count: " .. 5)   -- numbers auto-coerce to strings for concatenation

-- No increment/decrement operators at all -- no ++ or --
local n = 5
n = n + 1   -- this is the only way; `n++` is a syntax error
print("incremented:", n)

-- Length operator `#` -- works on strings and (sequence) tables
print(#"hello", #({1,2,3}))
