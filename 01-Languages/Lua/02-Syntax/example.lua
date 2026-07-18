-- This is a single-line comment (double-hyphen)

--[[
  This is a multi-line comment block.
  No semicolons are required to end statements (unlike C/Java/PHP).
]]

print("no semicolon needed")   -- semicolons are legal but optional as statement separators
print("two"); print("statements one line")  -- ; is allowed to visually separate statements on one line

-- Blocks are delimited with keywords, ending in `end` -- like Ruby, unlike C-family curly braces
if true then
  print("if-block needs 'then' ... 'end'")
end

local i = 0
while i < 3 do
  i = i + 1
end
print("while loop ended, i =", i)

-- Indentation is not significant (unlike Python) -- purely a style convention
    print("this line is indented oddly but still runs fine")

do
  -- `do ... end` on its own creates a new anonymous local scope
  local scoped = "only visible inside this do block"
  print(scoped)
end
-- print(scoped) here would error: scoped is out of scope
