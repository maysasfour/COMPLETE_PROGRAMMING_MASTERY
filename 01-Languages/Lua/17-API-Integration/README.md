# 17 - API Integration

## Honest Status of This Lesson

Like Lesson 16, this lesson is **conceptual rather than a live HTTP call against a real
endpoint**. Lua's standard library ships no HTTP client at all (another consequence of the
minimal, embeddable-first core). The community-standard library, `LuaSocket` (with the
`http` submodule, often paired with `LuaSec` for HTTPS), is distributed via LuaRocks — and
as in Lesson 16, no verified working LuaRocks + native-compile setup was confirmed available
in this environment, so a genuine network call was not fabricated here.

## What the Interface Looks Like (Conceptual)

```lua
-- Conceptual: requires `luasocket` (and `luasec` for https://), via LuaRocks
local http = require("socket.http")
local ltn12 = require("ltn12")

local response_body = {}
local ok, status_code = http.request{
  url = "https://api.example.com/users/1",
  method = "GET",
  sink = ltn12.sink.table(response_body),
}

if ok and status_code == 200 then
  local body = table.concat(response_body)
  print(body)   -- would need dkjson (Lesson 10) to parse if the response is JSON
else
  print("request failed:", status_code)
end
```

## Why This Gap Is Consistent With Lua's Design

Same theme as Lesson 16: in Lua's primary real-world niche (embedded scripting inside a
host application), HTTP calls are frequently made by the HOST, with results handed to Lua
as already-parsed tables — e.g. a game client's network layer, or Redis/nginx's own I/O
subsystem, rather than the Lua script opening sockets directly. Standalone Lua CLI tools
that need to make their own HTTP calls (this lesson's literal scenario) are a real but
non-default use case requiring `luasocket`, exactly analogous to how C's course documents
needing libcurl for the same reason.

## Interview Questions

1. **What library would a standalone Lua script use to make an HTTP GET request?** `LuaSocket`'s `socket.http` module (`http.request{...}`), typically paired with `LuaSec` for HTTPS support — neither ships with core Lua.
2. **Why does Lua not ship an HTTP client the way Ruby ships `Net::HTTP`?** Lua's standard library is intentionally minimal to stay small and embeddable; networking, like database access, is treated as something the embedding host or a separate C-backed library provides, not a core-language responsibility.
