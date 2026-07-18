-- === The global-leak gotcha (Lesson 03), its real consequences, and the fix, revisited ===

-- BAD: forgetting `local` inside a loop-heavy or larger codebase can silently create/overwrite
-- globals that collide with unrelated code elsewhere in a large program -- a real, hard-to-debug
-- class of bug in any Lua codebase bigger than a single small script.
function process_bad(items)
  for i = 1, #items do
    result = items[i] * 2   -- no `local` -- overwrites/creates a GLOBAL named `result` EVERY call
  end
  return result   -- "works" here, but `result` is now a shared, mutable global landmine
end

print(process_bad({1, 2, 3}))
print("global 'result' now polluted:", _G.result)

-- Consequence: a second, unrelated function using the same sloppy convention silently
-- clobbers the first's data if it also forgets `local`:
function unrelated_bad()
  result = "oops, now a string"   -- same global name, completely different logic path
end
unrelated_bad()
print("global 'result' clobbered by unrelated code:", _G.result)

-- GOOD: always declare `local` -- confines the variable to its actual scope, no collision risk
local function process_good(items)
  local result
  for i = 1, #items do
    result = items[i] * 2
  end
  return result
end
print(process_good({1, 2, 3}))
print("no global pollution this time:", _G.result_good)   -- nil, as expected -- never created

-- A cheap, real safety net: after loading, check what NEW globals a script introduced
local before = {}
for k in pairs(_G) do before[k] = true end

function accidentally_global() end   -- top-level `function name()` is ALSO a global leak

local leaked_names = {}
for k in pairs(_G) do
  if not before[k] then table.insert(leaked_names, k) end
end
print("globals introduced after that point:", table.concat(leaked_names, ", "))

print([[

=== Summary of Best Practices Demonstrated ===
1. Always prefix variable declarations with `local` -- including top-level `function` defs,
   which are ALSO implicitly global unless written `local function name(...)`.
2. Treat _G as a real, inspectable table (it's a table like any other) to audit accidental
   global creation -- shown above via a before/after pairs(_G) diff.
3. Avoid metatable misuse: don't attach __index chains so deep that debugging "where did
   this value come from" becomes a chore, and always set __tostring on OOP-style tables
   (Lesson 11) so print()/error() output stays readable instead of "table: 0x...".
4. Prefer returning a table from a module file (Lesson 15) over relying on globals to share
   code between files -- the deprecated module()/package.seeall pattern existed for exactly
   this failure mode and was removed for it.
]])
