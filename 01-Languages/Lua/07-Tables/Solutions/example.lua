-- 1. sum a table
local function sum_table(t)
  local total = 0
  for i = 1, #t do total = total + t[i] end
  return total
end
local nums = {5, 2, 8, 1, 9}
print("sum_table =", sum_table(nums))

-- 2. reverse without mutating the original
local function reverse_table(t)
  local result = {}
  for i = #t, 1, -1 do
    table.insert(result, t[i])
  end
  return result
end
local rev = reverse_table(nums)
print("original:", table.concat(nums, ","))
print("reversed:", table.concat(rev, ","))

-- 3. top scorer
local function top_scorer(records)
  local best = records[1]
  for _, r in ipairs(records) do
    if r.score > best.score then best = r end
  end
  return best
end
local records = {
  {name = "Ada", score = 88},
  {name = "Bo", score = 95},
  {name = "Cy", score = 72},
}
local top = top_scorer(records)
print("top scorer:", top.name, top.score)

-- 4. word frequency count
local words = {"lua", "is", "fun", "lua", "is", "great", "lua"}
local counts = {}
for _, w in ipairs(words) do
  counts[w] = (counts[w] or 0) + 1
end
for word, count in pairs(counts) do
  print(word, count)
end
