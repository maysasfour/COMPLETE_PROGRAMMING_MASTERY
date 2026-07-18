# 10 - File Handling

## Key Points

- `io.open(path, mode)` returns a file handle (or `nil, errmsg` on failure — **not** an error/exception, verified live) — modes `"r"`, `"w"`, `"a"`, etc., same convention as C's `fopen`.
- `file:read("a")` reads the whole file; `file:lines()` iterates line by line; `file:write(...)` writes.
- **No built-in JSON** — same real gap as C, C++, and Java's raw stdlib elsewhere in this repository. `dkjson` is the community-standard third-party pure-Lua library (via LuaRocks), documented honestly here rather than assumed installed.

## Run It

```bash
cd 01-Languages/Lua/10-File-Handling
lua example.lua
```

Real captured output:

```
wrote	scratch_test.txt
--- whole file ---
line one
line two
count: 42
line:	line one
line:	line two
line:	count: 42
--- after append ---
line one
line two
count: 42
appended line

missing file open result:	nil	does_not_exist_xyz.txt: No such file or directory
cleaned up	scratch_test.txt
```

(The example creates `scratch_test.txt`, uses it, and removes it via `os.remove` at the end — no stray files are left behind.)

## Common Beginner Mistakes

- Treating `io.open`'s failure as an error to `pcall` around — it isn't; a missing file returns `nil` plus an error string as a normal return value, and code must check for `nil` explicitly (verified live above), not wrap the open call in `pcall`.
- Assuming JSON support is built in — `require("json")` fails with no LuaRocks-installed library; `dkjson`/`cjson` must be installed separately.

## Best Practices

- Always check `io.open`'s first return value for `nil` before using the handle.
- Always `:close()` file handles explicitly (Lua has no `with`/`using`-style automatic resource cleanup) — or wrap file operations in `pcall` combined with an explicit close in both success and failure paths if a leak-proof pattern is needed.

## Interview Questions

1. **What does `io.open` return when the file doesn't exist?** `nil` plus an error message string, as an ordinary return value — not a raised error, so it should be checked explicitly rather than caught with `pcall`, verified live above.
2. **Does Lua support JSON natively?** No — same gap as C/C++/Java's stdlibs elsewhere in this repository; the community-standard solution is the third-party `dkjson` library via LuaRocks, not a core-language feature.
