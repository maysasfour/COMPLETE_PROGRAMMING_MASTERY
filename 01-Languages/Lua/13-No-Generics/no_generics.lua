local stack = {}
local function push(s, v) table.insert(s, v) end
local function pop(s) return table.remove(s) end

push(stack, 42)
push(stack, "a string")
push(stack, {nested = "table"})
push(stack, print)   -- yes, even a function value

print(pop(stack))
print(pop(stack))
print(pop(stack))
print(pop(stack))
