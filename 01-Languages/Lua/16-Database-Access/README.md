# 16 - Database Access

## Honest Status of This Lesson

This lesson is **conceptual, not a live-run database example**, and that's a deliberate,
documented decision rather than a gap glossed over. Reasoning:

- There is no database binding in Lua's standard library at all — Lua ships essentially no I/O beyond `io`/`os`, by design (small embeddable core).
- The community-standard SQLite binding is `LuaSQL` (`luasql-sqlite3`), distributed via LuaRocks. This environment has no verified working LuaRocks installation with a functioning native-compile toolchain for a C extension (unlike the Ruby course, which had a precompiled native `sqlite3` gem readily available for Windows). Compiling a Lua/C binding from source was not attempted as "genuinely installable" in the sense this brief asks for — it would require a C compiler + SQLite headers, an environment not confirmed present here.
- Rather than fabricate example output from a library that was never actually run, this lesson stays conceptual, matching how this repository's C course handles hard-to-obtain libraries: document the real interface, be explicit about what wasn't run.

## Why This Gap Is Actually Normal for Lua

This is a legitimate, not merely convenient, thing to note: Lua's whole design premise is
**embedding inside a host application**. In the real world (game engines, Redis, nginx/OpenResty,
Neovim), the *host* almost always owns the database or persistent-storage layer — Lua scripts
call back into host-exposed functions (`redis.call("SET", ...)`, a game engine's save-game API,
etc.) rather than opening their own SQL connection. Standalone Lua-with-SQLite is a real but
comparatively minority use case compared to Ruby/Python/PHP, where the language itself is
commonly the entire application.

## What the Interface Looks Like (Conceptual)

```lua
-- Conceptual: requires `luasql.sqlite3`, installed via `luarocks install luasql-sqlite3`
local sqlite3 = require("luasql.sqlite3")
local env = sqlite3.sqlite3()
local conn = env:connect("tasks.db")

conn:execute([[
  CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    done INTEGER DEFAULT 0
  )
]])

-- Parameterized queries: LuaSQL's API does not have first-class placeholders like
-- Ruby's sqlite3 gem (`?` binding) -- values are typically escaped manually or via
-- conn:escape(), a real, documented ergonomic gap vs. this repo's other DB lessons.
local title = conn:escape("Buy milk")
conn:execute("INSERT INTO tasks (title) VALUES ('" .. title .. "')")

local cursor = conn:execute("SELECT id, title, done FROM tasks")
local row = cursor:fetch({}, "a")
while row do
  print(row.id, row.title, row.done)
  row = cursor:fetch(row, "a")
end

cursor:close()
conn:close()
env:close()
```

## What Lesson 22 Actually Does Instead

Because a real DB binding was not confirmed working in this environment, the Lesson 22
mini-project (CLI Task Tracker) uses **file-based persistence with a hand-rolled Lua-table
serializer** (`io.open` + `string.format` to write valid Lua table syntax back to disk, then
`load()` to read it back as executable Lua and turn it into a table again) — a genuinely
idiomatic Lua pattern in embedded/scripting contexts where a full SQL engine is overkill,
not a fallback to be ashamed of. See Lesson 22's README for the real, run-for-real version.

## Interview Questions

1. **Why doesn't Lua have built-in database access?** Its standard library is deliberately minimal — Lua targets embeddability first, so most I/O beyond basic file/OS calls is left to the host application or third-party C bindings (LuaSQL, LuaRocks-distributed), not baked into the core language.
2. **In a game engine context, who usually owns the database — the Lua scripts or the host engine?** Typically the host engine/application — Lua scripts call back into host-exposed save/load functions rather than opening their own SQL connections, reflecting Lua's embedding-first design.
