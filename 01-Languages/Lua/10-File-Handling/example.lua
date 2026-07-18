-- io.open / io.read / io.write -- Lua's file I/O

local path = "scratch_test.txt"

-- Writing
local f = io.open(path, "w")
f:write("line one\n")
f:write("line two\n")
f:write("count: " .. 42 .. "\n")
f:close()
print("wrote", path)

-- Reading whole file
local f2 = io.open(path, "r")
local contents = f2:read("a")   -- "a" = whole file (Lua 5.3+; "*a" also works, legacy syntax)
f2:close()
print("--- whole file ---")
io.write(contents)

-- Reading line by line
local f3 = io.open(path, "r")
for line in f3:lines() do
  print("line:", line)
end
f3:close()

-- Appending
local f4 = io.open(path, "a")
f4:write("appended line\n")
f4:close()

local f5 = io.open(path, "r")
print("--- after append ---")
print(f5:read("a"))
f5:close()

-- Handling a missing file: io.open returns nil + error message (NOT an error/exception)
local missing, err = io.open("does_not_exist_xyz.txt", "r")
print("missing file open result:", missing, err)

os.remove(path)
print("cleaned up", path)

print([[

=== JSON: Lua has NO built-in JSON support ===
Same gap as C, C++, and Java's raw stdlib elsewhere in this repository. There is no
`require("json")` that works out of the box. The community-standard third-party solution
is the pure-Lua library `dkjson` (or `cjson` for a faster C-based binding), installed via
LuaRocks (`luarocks install dkjson`). This environment has no working LuaRocks/internet
package install verified, so JSON encode/decode is left conceptual here rather than faked:

  local json = require("dkjson")
  local encoded = json.encode({name = "Ada", age = 36})
  local decoded, pos, err = json.decode(encoded)

If your host application already parses JSON (e.g. a game engine feeding Lua parsed
tables directly), this gap often doesn't matter in practice -- another consequence of
Lua's embeddable design: JSON handling is frequently the HOST's job, not Lua's.
]])
