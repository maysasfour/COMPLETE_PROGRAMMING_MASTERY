-- Lua has NO built-in `class` keyword at all -- no classes, no inheritance syntax, nothing.
-- The entire ecosystem emulates OOP using metatables + the __index metamethod.
-- This is this course's equivalent of C's function-pointer-struct "polymorphism".

-- Step 1: a plain table can have a metatable attached via setmetatable()
local t = {}
local mt = {}
setmetatable(t, mt)
print("t's metatable is mt:", getmetatable(t) == mt)

-- Step 2: __index -- when a key is missing on a table, Lua consults its metatable's __index
-- (if __index is a table, that table is searched; if a function, it's called instead)
local defaults = {greeting = "hello"}
local obj = setmetatable({}, {__index = defaults})
print("obj.greeting falls through to defaults:", obj.greeting)

-- === Building a minimal class system from scratch, live ===
local Animal = {}
Animal.__index = Animal   -- Animal serves as both the "class table" AND its own metatable's __index

function Animal.new(name, sound)
  local self = setmetatable({}, Animal)
  self.name = name
  self.sound = sound
  return self
end

function Animal:speak()   -- `:` sugar declares an implicit first param `self`
  return self.name .. " says " .. self.sound
end

local dog = Animal.new("Rex", "Woof")
print(dog:speak())        -- dog:speak() is sugar for Animal.speak(dog)
print(dog.speak(dog))     -- proves the equivalence directly

-- Inheritance: a subclass's metatable __index points at the parent class
local Dog = setmetatable({}, {__index = Animal})   -- Dog inherits Animal's methods
Dog.__index = Dog

function Dog.new(name)
  local self = Animal.new(name, "Woof")
  return setmetatable(self, Dog)
end

function Dog:fetch()
  return self.name .. " fetches the ball!"
end

local rex = Dog.new("Rex")
print(rex:speak())   -- inherited from Animal
print(rex:fetch())   -- defined on Dog

-- Operator overloading via metamethods: __add, __tostring, __eq, __lt, etc.
local Vector = {}
Vector.__index = Vector
Vector.__add = function(a, b) return setmetatable({x = a.x + b.x, y = a.y + b.y}, Vector) end
Vector.__tostring = function(v) return "(" .. v.x .. ", " .. v.y .. ")" end
Vector.__eq = function(a, b) return a.x == b.x and a.y == b.y end

local function vec(x, y) return setmetatable({x = x, y = y}, Vector) end
local v1, v2 = vec(1, 2), vec(3, 4)
local v3 = v1 + v2   -- calls Vector.__add
print("v1 + v2 =", tostring(v3))   -- calls Vector.__tostring
print("v1 == vec(1,2):", v1 == vec(1, 2))   -- calls Vector.__eq

-- __newindex: intercept WRITES to missing keys (e.g. to enforce read-only tables)
local readonly = setmetatable({}, {
  __index = {pi = 3.14159},
  __newindex = function(t, k, v)
    error("attempt to write to read-only table, key: " .. tostring(k))
  end
})
print("readonly.pi =", readonly.pi)
local ok, err = pcall(function() readonly.pi = 4 end)
print("write blocked:", ok, err)
