# Lua Cheat Sheet

[Back to course overview](README.md)

## Variables and Types (Dynamic, 8 Basic Types)

```lua
local age = 30            -- number (Lua has no separate int/float distinction pre-5.3 quirks)
local price = 19.99        -- number
local name = "Ada"            -- string
local active = true              -- boolean
local nothing = nil                 -- nil -- Lua's one "nothing" value

type(age)      --> "number"
type(nothing)  --> "nil"

-- THE GLOBAL-BY-DEFAULT FOOTGUN: forgetting `local` doesn't scope a variable --
-- it silently creates/overwrites a REAL GLOBAL in `_G`, visible everywhere:
function leaky() leaked = "escaped!" end   -- no `local` -- becomes _G.leaked
leaky()
print(leaked)     --> escaped! (visible OUTSIDE the function)
print(_G.leaked)  --> escaped! (proof it's a real global)

-- Falsy values: ONLY nil and false. 0 and "" are both TRUTHY (unlike C/Python/JS).
```

## Syntax

```lua
-- no semicolons required; `end` closes every block, not { }
if x > 0 then
  print("positive")
elseif x == 0 then
  print("zero")
else
  print("negative")
end

-- single-line comment
--[[ multi-line
     comment ]]

do
  local scoped = "only visible in this block"
end
```

## Operators (Distinctive Ones)

```lua
"a" .. "b"       --> "ab"   -- .. is CONCATENATION, not + (+ is strictly numeric)
5 ~= 6           --> true   -- ~= is "not equal", not !=
17 // 5          --> 3      -- // is floor (integer) division
17 / 5           --> 3.4    -- / is ALWAYS float division since Lua 5.3
2 ^ 10           --> 1024.0 -- ^ is exponentiation, not **
#"hello"         --> 5      -- # is the length operator (strings, array-part tables)
nil or "default" --> "default"  -- and/or short-circuit, return actual operand values

-- NO ++/-- AT ALL:
n = n + 1   -- the only way to increment
```

## Control Flow

```lua
while sum < 100 do sum = sum + 1 end

repeat                      -- do-while equivalent: body runs AT LEAST ONCE
  i = i + 1
until i >= 3                -- locals from the body are visible in `until` itself

for i = 1, 10 do end         -- numeric for: start, stop[, step] -- step defaults to +1
for i = 10, 1, -1 do end       -- countdown needs an EXPLICIT negative step

for i, v in ipairs(arr) do end   -- sequence 1..n, stops at first nil/hole
for k, v in pairs(t) do end        -- every key, unspecified order

-- NO `continue` KEYWORD AT ALL -- workaround:
for i = 1, 10 do
  if i % 2 == 0 then goto continue end
  print(i)
  ::continue::
end
```

## Functions: Closures, Varargs, Multiple Returns

```lua
local function make_counter()
  local count = 0                 -- captured BY REFERENCE (upvalue), not by value
  return function() count = count + 1; return count end
end
local c1, c2 = make_counter(), make_counter()   -- fully independent state each

local function sum_all(...)
  local total = 0
  for _, v in ipairs({...}) do total = total + v end   -- {...} packs varargs into a table
  return total
end
select("#", ...)   -- TRUE arg count, including embedded nils (ipairs stops at first nil)

local function divmod(a, b) return a // b, a % b end   -- MULTIPLE RETURN VALUES
local q, r = divmod(17, 5)   --> 3, 2
-- multi-returns only spread fully in the LAST position of an expression list
```

## Tables (Lua's ONLY Compound Type)

```lua
local arr = {"a", "b", "c"}
arr[1]        --> "a"   -- 1-BASED INDEXING -- the FIRST element, not the second
arr[0]        --> nil   -- a different, usually-unused slot -- NOT an error
#arr          --> 3     -- length -- only well-defined over the contiguous array part

local dict = {name = "Ada", age = 36}       -- dict.name == dict["name"]
local mixed = {1, 2, x = "sparse"}            -- array part + hash part in one table

table.insert(arr, "d")        -- append (or table.insert(arr, pos, "d") to insert at pos)
table.remove(arr, 1)             -- remove at index, shifting others down
table.concat(arr, ",")             -- "a,b,c,d"
table.sort(arr, function(a, b) return a > b end)  -- custom comparator, descending
```

## Strings (Immutable)

```lua
local s = "Hello, Lua!"
s:upper()              -- sugar for string.upper(s) -- returns a NEW string, s unchanged
string.format("%s scored %.1f%%", "Ada", 97.5)   -- printf-style -- NO interpolation syntax exists
string.format("%05d", 42)     --> "00042"

-- Lua PATTERNS -- own lightweight syntax, NOT PCRE regex (no alternation `|`)
s:match("(%d+)-(%d+)")        -- %d digit, %a letter, %s space; () captures
s:gmatch("%w+")                 -- iterator over every match
s:gsub("%d", "*")                 -- replace, returns (new_string, count)
s:find("Lua")                       -- byte start/end indices
```

## Error Handling (No try/catch -- Just Functions)

```lua
local ok, result = pcall(risky_fn, arg)      -- true, result  OR  false, error_message
if not ok then print("failed: " .. result) end

error("plain string error")                   -- raises; unwinds until caught by pcall
error({code = 404, message = "not found"})      -- error() can raise ANY value, not just strings

local ok, result = xpcall(risky_fn, debug.traceback)  -- handler runs while stack is still live
assert(x > 0, "x must be positive")                     -- raises if condition is falsy
```

## Metatables and OOP (No `class` Keyword At All)

```lua
local Animal = {}
Animal.__index = Animal                    -- REQUIRED: makes instances fall through to Animal
function Animal.new(name) return setmetatable({name = name}, Animal) end
function Animal:speak() return self.name .. " makes a sound" end  -- colon = implicit self

local Dog = setmetatable({}, {__index = Animal})   -- "inheritance": chain __index lookups
Dog.__index = Dog
function Dog.new(name) return setmetatable({name = name}, Dog) end
function Dog:speak() return self.name .. " says Woof" end

local rex = Dog.new("Rex")
rex:speak()          -- "Rex says Woof" -- obj:method(x) is sugar for obj.method(obj, x)
                      -- calling with `.` instead of `:` silently breaks `self`!

-- Operator overloading via metamethods:
local mt = {__add = function(a, b) return {x = a.x + b.x} end, __tostring = function(t) return "..." end}
```

## Functional Concepts

```lua
-- No built-in map/filter/reduce -- hand-roll or pull from a small utility module:
local function map(t, fn)
  local out = {}
  for i, v in ipairs(t) do out[i] = fn(v) end
  return out
end

local dispatch = {add = function(a, b) return a + b end, mul = function(a, b) return a * b end}
dispatch["add"](2, 3)   --> 5   -- table-of-functions as a dispatch/strategy pattern
```

## Coroutines (Cooperative, Single-Threaded)

```lua
local co = coroutine.create(function(a, b)
  print(a, b)
  local x = coroutine.yield(a + b)     -- suspends, returns a+b to resume()'s caller
  print("resumed with", x)
end)

coroutine.resume(co, 3, 4)    --> true, 7   (prints 3  4 first)
coroutine.resume(co, 100)     --> resumes co, x = 100
coroutine.status(co)          --> "suspended" / "running" / "dead"

local iter = coroutine.wrap(function()   -- wrap: returns a plain callable, usable in `for`
  for i = 1, 5 do coroutine.yield(i * i) end
end)
for sq in iter do print(sq) end   --> 1 4 9 16 25
```

## Modules

```lua
-- mymodule.lua
local M = {}
function M.greet(name) return "hi " .. name end
return M                              -- idiomatic modern module pattern

-- caller.lua
local mymodule = require("mymodule")   -- caches -- second require returns the SAME table
mymodule.greet("Ada")
```

## Testing (Hand-Rolled -- No Built-In Framework)

```lua
local t = require("testkit")   -- this course's minimal pcall/assert harness

t.test("addition works", function()
  t.eq(2 + 2, 4, "2+2 should be 4")
end)

local ok = t.summary()          -- prints "N passed, M failed" + failure details
os.exit(ok and 0 or 1)            -- CI-friendly: non-zero exit on any failure
```

## File I/O

```lua
local f, err = io.open("data.txt", "r")   -- nil, errmsg on failure -- NOT a pcall-catchable error
if not f then print("failed: " .. err); return end
local contents = f:read("a")                -- read whole file
for line in f:lines() do print(line) end       -- iterate line by line
f:close()                                        -- always close explicitly -- no `with`/`using`
```

## Running Code

```bash
lua script.lua          # runs top to bottom, no build step
lua                        # interactive REPL
luac script.lua               # optional: pre-compile to bytecode (rarely needed)
luarocks install <name>          # community package manager (conceptual in this course)
```
