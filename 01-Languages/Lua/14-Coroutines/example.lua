-- Coroutines: Lua's distinctive concurrency primitive -- cooperative, single-threaded,
-- NOT OS threads (there is no thread/GIL story at all -- only one coroutine ever runs at a time,
-- and control passes explicitly via yield/resume, never preemptively).
-- Comparable to Python generators / PHP Fibers / Kotlin coroutines, but simpler: no scheduler,
-- no async/await sugar -- just create/resume/yield as plain functions.

-- Basic create/resume/yield
local co = coroutine.create(function(a, b)
  print("coroutine started with", a, b)
  local x = coroutine.yield(a + b)     -- pauses here, returns a+b to the resumer
  print("resumed with x =", x)
  local y = coroutine.yield(x * 2)
  print("resumed again with y =", y)
  return "done, y was " .. y
end)

print(coroutine.status(co))                 -- "suspended" -- created but not started
print(coroutine.resume(co, 3, 4))            -- true, 7 (3+4) -- runs until first yield
print(coroutine.status(co))                  -- "suspended" -- paused at yield
print(coroutine.resume(co, 100))             -- true, 200 -- resumes with x=100, yields x*2
print(coroutine.resume(co, 999))             -- true, "done, y was 999" -- runs to completion
print(coroutine.status(co))                  -- "dead" -- coroutine has finished
print(coroutine.resume(co))                  -- false, "cannot resume dead coroutine"

-- === Producer/Consumer demo -- a real, live-run cooperative pipeline ===
local function producer()
  return coroutine.create(function()
    for i = 1, 5 do
      local item = "item-" .. i
      print("[producer] making " .. item)
      coroutine.yield(item)   -- hand control back to consumer with this item
    end
  end)
end

local function consumer(prod)
  while true do
    local ok, item = coroutine.resume(prod)
    if coroutine.status(prod) == "dead" then
      print("[consumer] producer finished")
      break
    end
    print("[consumer] received " .. tostring(item))
  end
end

local prod_co = producer()
consumer(prod_co)

-- coroutine.wrap: same as create, but returns a plain function (calling it resumes;
-- errors propagate as real Lua errors instead of a false,err pair) -- common idiom for
-- turning a coroutine into an "iterator" usable directly in a generic for loop
local function range_iter(n)
  return coroutine.wrap(function()
    for i = 1, n do
      coroutine.yield(i * i)
    end
  end)
end

io.write("squares via coroutine.wrap iterator: ")
for square in range_iter(5) do
  io.write(square, " ")
end
print()
