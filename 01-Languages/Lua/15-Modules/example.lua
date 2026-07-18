-- require() loads a module by name, searching package.path for a matching .lua file,
-- and CACHES the result -- a second require() of the same module returns the same table,
-- it does not re-execute the file.
local mathutils = require("mathutils")

print(mathutils.square(5))
print(mathutils.is_even(4), mathutils.is_even(5))
print(mathutils.PI_APPROX)

-- proof require() caches: the module file runs its top-level code only once
local mathutils2 = require("mathutils")
print("same table object (cached):", mathutils == mathutils2)

print([[

=== LuaRocks, conceptually ===
LuaRocks is the de-facto community package manager for Lua (like RubyGems/pip/npm),
distributing "rocks" (packages) and resolving dependencies via `luarocks install <name>`.
This environment has no verified working LuaRocks install (no system Lua, no verified
internet-based rocks server reachability tested beyond the earlier binary download), so
Lessons 16/17 below are scoped honestly to what's actually installable/runnable here --
this Lesson only uses `require` on a genuinely local, hand-written module file, which
needs no package manager at all.

Legacy note: pre-5.2 code sometimes used `module("name", package.seeall)` at the top of
a file instead of building+returning a table. That pattern is deprecated (removed by
default in 5.2+) specifically because it implicitly created a GLOBAL for the module and
polluted the calling scope with package.seeall -- the same "forgetting `local` leaks
globally" problem from Lesson 03, baked into a former stdlib feature. The
return-a-table idiom used above is the only pattern in current, idiomatic Lua.
]])
