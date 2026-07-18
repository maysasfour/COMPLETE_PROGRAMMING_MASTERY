-- Tables are Lua's ONLY compound data structure -- arrays, dicts, objects, sets, everything.

-- Used as an array (a "sequence"): 1-BASED INDEXING -- a real, live-verified gotcha vs.
-- every 0-based language elsewhere in this repository (C, Python, Ruby, PHP, Java, JS, ...)
local arr = {"a", "b", "c"}
print("arr[1] (first element) =", arr[1])
print("arr[0] (would be first element in 0-based langs) =", arr[0])   -- nil! there is no index 0
print("#arr (length) =", #arr)
print("arr[#arr] (last element) =", arr[#arr])

for i = 1, #arr do
  print("index", i, "->", arr[i])
end

-- Used as a dictionary/object simultaneously -- string keys, dot-sugar for string-literal keys
local person = {name = "Ada", age = 36}
print(person.name, person["age"])
person.age = 37   -- dot access is sugar for person["age"]
print("after birthday:", person.age)

-- A SINGLE table can mix both array part and hash part at once -- genuinely unusual
local mixed = {"first", "second", key = "value", [10] = "sparse"}
print(mixed[1], mixed[2], mixed.key, mixed[10])
print("#mixed is only defined over the contiguous array part:", #mixed)   -- 2, not 4 -- [10] is sparse

-- Nested tables -- how Lua represents structured data (its only way)
local company = {
  name = "Acme",
  employees = {
    {name = "Ada", role = "Engineer"},
    {name = "Bo", role = "Designer"},
  }
}
for _, emp in ipairs(company.employees) do
  print(company.name .. " employs " .. emp.name .. " as " .. emp.role)
end

-- Tables are reference types: assignment copies the reference, not the contents
local t1 = {1, 2, 3}
local t2 = t1
t2[1] = 999
print("t1[1] changed via t2 (same table):", t1[1])

-- table library: insert, remove, concat, sort
local list = {5, 3, 1, 4, 2}
table.insert(list, 6)          -- append to end
table.insert(list, 1, 0)       -- insert at position 1
print("after inserts:", table.concat(list, ","))
table.remove(list, 1)          -- remove first
print("after remove:", table.concat(list, ","))
table.sort(list)
print("sorted:", table.concat(list, ","))

-- Using a table as a set (common Lua idiom -- keys as membership, values as `true`)
local set = {}
for _, fruit in ipairs({"apple", "banana", "apple"}) do
  set[fruit] = true
end
print("apple in set:", set["apple"] ~= nil, "  cherry in set:", set["cherry"] ~= nil)
