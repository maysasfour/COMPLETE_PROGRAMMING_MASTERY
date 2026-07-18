-- Function declaration -- `function name(...) ... end`, first-class values under the hood
local function add(a, b)
  return a + b
end
print("add(2,3) =", add(2, 3))

-- Functions are first-class: assignable, passable, returnable
local mul = function(a, b) return a * b end
print("mul(4,5) =", mul(4, 5))

local function apply(fn, a, b)
  return fn(a, b)
end
print("apply(add,2,3) =", apply(add, 2, 3))
print("apply(mul,2,3) =", apply(mul, 2, 3))

-- Closures: a function captures its enclosing local variables by reference, not by value
local function make_counter()
  local count = 0
  return function()
    count = count + 1
    return count
  end
end
local counter1 = make_counter()
local counter2 = make_counter()
print(counter1(), counter1(), counter1())   -- 1 2 3 -- own private `count`
print(counter2())                            -- 1 -- independent closure, proves no shared state

-- Variadic functions: `...` collects all extra arguments
local function sum_all(...)
  local total = 0
  for _, v in ipairs({...}) do
    total = total + v
  end
  return total
end
print("sum_all(1,2,3,4) =", sum_all(1, 2, 3, 4))

-- select('#', ...) gets the true argument count, including nils that ipairs would skip
local function count_args(...)
  return select("#", ...)
end
print("count_args(1,nil,3) =", count_args(1, nil, 3))   -- 3, not 1 or 2 -- ipairs would stop at the nil

-- === MULTIPLE RETURN VALUES -- genuinely distinctive vs. most languages in this repo ===
local function divmod(a, b)
  return a // b, a % b
end
local q, r = divmod(17, 5)
print("17 // 5, 17 % 5 =", q, r)

-- Extra return values are silently discarded if not captured
local only_q = divmod(17, 5)
print("only_q (extra discarded) =", only_q)

-- Multiple returns spread as arguments to another call, but ONLY in the last-argument position
local function three() return 1, 2, 3 end
print("three() spread as args:", three())
print("three() truncated to 1 when not last:", three(), "next")
