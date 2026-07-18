-- Lua has 8 basic types: nil, boolean, number, string, function, userdata, thread, table
print(type(nil), type(true), type(1), type(1.5), type("s"), type(print), type({}))

-- Dynamic typing: a variable can hold any type, and can change type across its life
local x = 10
print("x is", x, type(x))
x = "now a string"
print("x is", x, type(x))

-- nil is Lua's "no value" -- like null/None/nil elsewhere, and also how Lua represents "undefined"
local undefined_var
print("an uninitialized local is", undefined_var)   -- nil

-- === THE GLOBAL-BY-DEFAULT FOOTGUN ===
-- Forgetting `local` does NOT create a local variable scoped to this block/function --
-- it silently creates (or overwrites) a GLOBAL variable visible everywhere.
function leaky()
  leaked = "I escaped my function!"   -- no `local` keyword -- this is now _G.leaked
end

function safe()
  local contained = "I stay inside my function"
end

leaky()
safe()
print("leaked is visible outside its function:", leaked)
-- print(contained) would error: contained is nil (it was truly local, and out of scope anyway)
print("contained is not visible (it was local):", contained)

-- Proof this is a genuine global: it's sitting in the _G table
print("leaked lives in _G:", _G.leaked)

-- The fix: always declare `local` unless a global is deliberately intended
function fixed()
  local not_leaked = "I stay contained"
  return not_leaked
end
print("fixed() returns:", fixed())
print("not_leaked is nil at top level (never leaked):", not_leaked)
