# 11 - Metatables and OOP

## What / Why

Lua has **no `class` keyword, no inheritance syntax, no built-in object system at all**.
Every "class" you'll ever see in Lua code — including entire frameworks like Roblox's
Instance model or LÖVE's object libraries — is built from the same two primitives:
`setmetatable()` and the `__index` metamethod. This is this course's equivalent of C's
function-pointer-struct "polymorphism": a minimal class system built from scratch, live,
using only what the language actually provides.

## How `__index` Makes "Classes" Work

When Lua looks up a missing key on a table, it checks that table's metatable for an
`__index` entry. If `__index` is itself a table, Lua searches *that* table instead — chain
enough of these together and you get method lookup that looks exactly like inheritance:

```lua
local Animal = {}
Animal.__index = Animal
function Animal.new(name) return setmetatable({name = name}, Animal) end
function Animal:speak() return self.name .. " makes a sound" end

local dog = Animal.new("Rex")
dog:speak()   -- dog has no `speak` key itself -- falls through to Animal via __index
```

## Run It

```bash
cd 01-Languages/Lua/11-Metatables-and-OOP
lua example.lua
```

Real captured output:

```
t's metatable is mt:	true
obj.greeting falls through to defaults:	hello
Rex says Woof
Rex says Woof
Rex says Woof
Rex fetches the ball!
v1 + v2 =	(4, 6)
v1 == vec(1,2):	true
readonly.pi =	3.14159
write blocked:	false	11-Metatables-and-OOP/example.lua:70: attempt to write to read-only table, key: pi
```

## Common Beginner Mistakes

- Forgetting `Class.__index = Class` — without it, instances created via `setmetatable({}, Class)` won't find any methods at all, since there's no `__index` to fall through to.
- Confusing `.` and `:` calls — `obj:method(x)` is sugar for `obj.method(obj, x)`; calling a colon-defined method with a dot (`obj.method(x)`) silently passes `x` as `self` instead of the actual object, a real and common bug.
- Not setting `__tostring` — printing an OOP-style table without it produces an opaque `table: 0x...` instead of readable output (see Lesson 19's best-practice note).

## Best Practices

- Always set `__index = Class` immediately after creating a class table, before defining any methods.
- Define `__tostring` on any table meant to be printed or included in error messages.
- Reserve metatable-based "inheritance" for genuinely hierarchical relationships — for simple data grouping, a plain table is clearer and needs no metatable at all.

## Interview Questions

1. **How does Lua emulate OOP without a `class` keyword?** Via `setmetatable()` and the `__index` metamethod — instance tables are created with a metatable pointing back at a shared "class" table, so method lookups that miss on the instance fall through to the class table automatically.
2. **What's the difference between `obj.method(obj)` and `obj:method()`?** They're equivalent — `:` is pure syntax sugar that implicitly passes `obj` as the first parameter (`self`); using `.` requires passing the receiver manually, and forgetting to do so is a common, easy-to-make bug.
