-- Strings are immutable in Lua -- every "mutation" method returns a NEW string
local s = "Hello, Lua!"
local upper = s:upper()   -- method-call sugar: s:upper() == string.upper(s)
print(s, "->", upper)
print("original unchanged:", s)

print(string.len(s), #s)          -- length two ways
print(s:sub(1, 5))                 -- substring, 1-based, inclusive on both ends
print(s:sub(-4))                   -- negative index counts from the end
print(s:lower())
print(s:find("Lua"))               -- returns start,end byte indices of first match
print(s:rep(2, " | "))             -- repeat with separator

-- string.format -- printf-style, distinctive syntax vs. Python's f-strings/Ruby's interpolation
local name, score = "Ada", 97.456
print(string.format("%s scored %.1f%%", name, score))
print(string.format("%05d", 42))
print(string.format("%x", 255))

-- Concatenation with .. (see Lesson 04) is the ONLY way to build strings from parts --
-- there is no string interpolation syntax built into Lua at all (a real, notable gap)
print(name .. " scored " .. score)

-- === Lua pattern matching -- NOT full PCRE regex, a smaller custom syntax ===
-- %d digit, %a letter, %s whitespace, + one-or-more, * zero-or-more, - lazy repeat, () capture
local date = "2026-07-19"
local y, m, d = date:match("(%d+)-(%d+)-(%d+)")
print("captured date parts:", y, m, d)

local text = "contact: alice@example.com or bob@test.org"
for email in text:gmatch("%a+@%a+%.%a+") do
  print("found email:", email)
end

local cleaned = ("  spaced out  "):gsub("^%s+", ""):gsub("%s+$", "")
print("trimmed: [" .. cleaned .. "]")

local censored, n = ("badword badword ok"):gsub("badword", "****")
print(censored, "replacements:", n)

-- Lua patterns lack real regex alternation (|) and non-greedy quantifiers beyond `-` --
-- genuinely more limited than PCRE, by design, to keep the matcher tiny and fast.
