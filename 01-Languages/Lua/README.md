# Lua

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Lua Is

Lua is a small, fast, dynamically-typed scripting language designed from day one to be
**embedded inside a host application** written in C/C++, rather than run standalone as a
general-purpose tool. Its reference interpreter is a ~250KB core library, not a sprawling
runtime — the entire standard library is intentionally minimal (no built-in JSON, HTTP client,
database binding, or test framework), because the language's whole design premise is that a
host application supplies whatever else a script needs. This course runs Lua standalone (as
most of its lessons do), but every design choice — no threads, tables as the only compound
type, a tiny stdlib — traces back to that embeddable-first goal.

## Why / Where It's Used

- **Game engines** — Roblox, World of Warcraft's UI, Garry's Mod, CryEngine, and many others
  embed Lua so designers can script gameplay without touching the underlying C++ engine code.
- **Neovim/Vim** — Neovim's configuration and plugin system is native Lua.
- **Redis** — `EVAL` runs Lua scripts server-side for atomic multi-command operations.
- **nginx (OpenResty)** — Lua scripts handle request logic inside the web server process itself.
- **General embedded scripting** — anywhere an application wants to expose a small, safe,
  sandboxable scripting layer to end users or designers without shipping a full language runtime.

## Advantages

- Tiny, fast, easily embeddable interpreter — the reason it's the de-facto standard scripting
  language bolted onto C/C++ host applications across the games industry and beyond.
- Tables are a genuinely elegant single compound type: array, dictionary, set, and object are
  all the same underlying structure, with no separate container types to learn (Lesson 07).
- First-class functions, closures with real by-reference upvalue capture, and genuine multiple
  return values from a single function call — features many mainstream languages need extra
  syntax (tuples, wrapper types) to approximate (Lesson 06).
- Coroutines give clean, dependency-free cooperative concurrency (generators, producer/consumer
  pipelines) with just three functions (`create`/`resume`/`yield`) and no scheduler at all
  (Lesson 14).
- `pcall`/`xpcall`/`error()` provide error handling as ordinary functions, not special syntax —
  simple to embed and simple to reason about (Lesson 09).

## Disadvantages

- **Global-by-default variable declaration** — forgetting `local` doesn't scope a variable to
  its block; it silently creates or overwrites a real global in `_G`, verified live in this
  course to cause actual data-clobbering bugs between unrelated functions (Lessons 03, 19).
- **1-based indexing** — unlike every other language in this repository, Lua's array
  convention starts at index 1, and the entire standard library (`ipairs`, `#`, `table.insert`)
  assumes it; mixing in 0-based habits produces silently wrong results, not an error (Lesson 07).
- **No `continue` keyword** — only `break` exists; skipping to the next loop iteration needs
  `goto continue` + a label, or restructuring the loop as an early-return guard (Lesson 05).
- **No built-in JSON, HTTP client, or database binding** — all three require third-party
  LuaRocks packages (`dkjson`, `LuaSocket`, `LuaSQL`), none of which were confirmed genuinely
  installable in this environment, so Lessons 16 and 17 stay honestly conceptual rather than
  fabricating live output (Lessons 10, 16, 17).
- **No classes, no generics, no static type system at all** — OOP (Lesson 11) is a
  metatable-based *pattern*, not a language feature, and there is nothing for a hypothetical
  generic/type system to even attach to (Lesson 13).

## How to Install

There is no official Lua installer for Windows from lua.org (source only). This course used a
**portable, self-contained** Lua 5.4.8 binary, matching this repository's established pattern
of isolated toolchain installs (see the Ruby and PHP courses for the same approach):

```bash
mkdir -p /c/Users/HP/Complete-Programming-Mastery/tools/lua
curl -sL -o /c/Users/HP/Complete-Programming-Mastery/tools/lua/lua.exe \
  "https://github.com/rex-rbx/LuaOnWindows/releases/download/5.4.8/lua.exe"

export PATH="/c/Users/HP/Complete-Programming-Mastery/tools/lua:$PATH"   # current shell only
lua -v
```

Verified output on this machine:

```
$ lua -v
Lua 5.4.8  Copyright (C) 1994-2025 Lua.org, PUC-Rio
```

This single `lua.exe` is a statically-linked interpreter — no separate `.dll`, no installer,
nothing written outside this repo's `tools/` folder.

## How to Run the Examples

Every lesson folder has a `README.md` and a runnable `example.lua` (or `example_test.lua` for
Lesson 18). From the repository root:

```bash
export PATH="/c/Users/HP/Complete-Programming-Mastery/tools/lua:$PATH"
cd 01-Languages/Lua/03-Variables-and-Data-Types
lua example.lua
```

No installs are needed for any lesson — Lessons 16 and 17 are intentionally conceptual (no
verified LuaRocks + native-compile toolchain in this environment; see each lesson's README for
why), and the Lesson 22 mini-project uses file-based storage instead of a real database for
the same reason.

## Common Beginner Mistakes

- **Forgetting `local`** — the single most consequential Lua-specific bug source in this
  course; a bare `x = 1` (or even `function f() end`) at any scope creates/overwrites a real
  global in `_G`, silently, with no error (Lessons 03, 19).
- **Porting 0-based indexing habits** — `arr[0]` is simply a different, usually-unused table
  slot in Lua, not an out-of-bounds error, which makes the resulting bug silent rather than loud
  (Lesson 07).
- **Expecting `continue` to exist** — it doesn't; `goto continue`/`::continue::` or an early
  `if not cond then ... end` guard are the idiomatic substitutes (Lesson 05).
- **Assuming `+` concatenates strings** — `+` is strictly numeric in Lua; `..` is the
  concatenation operator, and there is no string-interpolation syntax at all (`..` and
  `string.format` are the only two ways to build a string from parts) (Lessons 04, 08).
- **Confusing `.` and `:` method calls** — `obj:method(x)` is sugar for `obj.method(obj, x)`;
  calling a colon-defined method with a dot silently passes `x` as `self` instead of the real
  object (Lesson 11).

## Best Practices

- Declare every variable with `local` unless a genuine top-level global is intended (rare) —
  and remember `local function name(...)` is the correct form for named local functions, not
  `function name(...)` (which is still global at file scope) (Lessons 03, 19).
- Prefer `ipairs` for known array-shaped tables and `pairs` only when every key regardless of
  shape is genuinely needed (Lesson 05).
- Always set `Class.__index = Class` and define `__tostring` on any metatable-based "class"
  meant to be printed or included in error messages (Lesson 11).
- Keep hand-rolled helpers (`map`/`filter`/`reduce`, a test harness) in a shared module
  (`local M = {}; ...; return M`) rather than redefining them per-script (Lessons 12, 15, 18).
- Reach for `string.format` over chained `..` concatenation once more than 2-3 pieces are
  involved (Lesson 08).

## Interview Questions

1. **What happens if you forget the `local` keyword in Lua?** The variable becomes a global,
   silently created or overwritten in the shared `_G` table, visible from anywhere in the
   program — demonstrated live in Lesson 03 (a value set inside one function readable
   completely outside it) and Lesson 19 (two unrelated functions clobbering the same
   accidental global).
2. **Why is Lua's array indexing 1-based, and does that matter in practice?** By convention,
   not language restriction — you *can* store a value at index 0, but the entire standard
   library (`ipairs`, `#`, `table.insert`/`remove`, `table.concat`) assumes a 1-based, gap-free
   sequence and will silently ignore anything stored at index 0, verified live in Lesson 07.
3. **How does Lua implement OOP without a `class` keyword?** Via `setmetatable()` and the
   `__index` metamethod — when a key lookup misses on a table, Lua checks that table's
   metatable's `__index` (itself often another table) and searches there instead; chaining
   this produces method lookup that behaves like inheritance, entirely as a *pattern*, not a
   language feature (Lesson 11).
4. **How does Lua handle what other languages call exceptions?** Via the ordinary function
   `error()` to raise (any value, not just strings) and `pcall`/`xpcall` to catch — both plain
   functions, not special syntax, and there's no built-in typed exception hierarchy (Lesson 09).
5. **Does Lua have generics, and why not?** No — more fundamentally than this repository's
   other dynamic languages, Lua has no static type system, no compile-time type checking, and
   no classes in the language itself (Lesson 11's OOP is a pattern), so there is nothing for a
   hypothetical generic/type system to even attach to (Lesson 13).
6. **How do Lua coroutines differ from OS threads?** Cooperative, not preemptive — only one
   coroutine ever runs at a time, and it explicitly yields control via `coroutine.yield`; there
   is no parallel execution and no scheduler making preemption decisions (Lesson 14).

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Setup](01-Setup/README.md) | Portable `lua.exe`, REPL vs. script execution, embeddable design |
| 02 | [Syntax](02-Syntax/README.md) | `end`-delimited blocks, optional semicolons, `--` comments |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | 8 basic types, the global-by-default footgun (verified live) |
| 04 | [Operators](04-Operators/README.md) | `..` concatenation, `~=`, `//` vs `/`, no `++`/`--` |
| 05 | [Control Flow](05-Control-Flow/README.md) | `if`/`while`/`repeat...until`, numeric/generic `for`, no `continue` |
| 06 | [Functions](06-Functions/README.md) | First-class functions, by-reference closures, multiple return values, varargs |
| 07 | [Tables](07-Tables/README.md) | Lua's only compound type, 1-based indexing (verified live), array/hash/set patterns |
| 08 | [Strings](08-Strings/README.md) | Immutable strings, `string.format`, Lua pattern matching (not regex) |
| 09 | [Error Handling](09-Error-Handling/README.md) | `pcall`/`xpcall`/`error()` — functions, not syntax; structured (table) errors |
| 10 | [File Handling](10-File-Handling/README.md) | `io.open`/`file:lines`/`file:write`, no built-in JSON (`dkjson` gap documented) |
| 11 | [Metatables and OOP](11-Metatables-and-OOP/README.md) | `setmetatable`/`__index`-based classes, operator overloading, read-only tables |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Hand-rolled `map`/`filter`/`reduce`, `table.sort` with a comparator, dispatch tables |
| 13 | [No Generics](13-No-Generics/README.md) | No static type system at all — untyped tables as Lua's only "generic" mechanism |
| 14 | [Coroutines](14-Coroutines/README.md) | `coroutine.create`/`resume`/`yield`/`wrap`, producer/consumer, generator patterns |
| 15 | [Modules](15-Modules/README.md) | `require` caching, `local M = {}; return M` idiom, LuaRocks (conceptual) |
| 16 | [Database Access](16-Database-Access/README.md) | Conceptual — `LuaSQL`/SQLite; honest note on why no live binding was run |
| 17 | [API Integration](17-API-Integration/README.md) | Conceptual — `LuaSocket`/HTTP; honest note on why no live request was made |
| 18 | [Testing](18-Testing/README.md) | Hand-rolled `pcall`/`assert` test harness (`testkit.lua`), CI-friendly exit codes |
| 19 | [Best Practices](19-Best-Practices/README.md) | The global-leak footgun's real damage, reproduced live; `_G` auditing |
| 20 | [Exercises](20-Exercises/README.md) | 8 standalone problems spanning the whole course |
| 21 | [Solutions](21-Solutions/README.md) | Worked, verified solutions to all 20-Exercises problems |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker — file-based persistence (hand-rolled serializer), hand-rolled test suite |

Also see: [CHEAT-SHEET.md](CHEAT-SHEET.md).

## Suggested Path

Work through 01 → 19 in order. Lesson 05 has an `Exercises`/`Solutions` pair specific to
control flow. Lessons 16 and 17 are worth reading even though they're conceptual — the "honest
gap" reasoning (why the embeddable-scripting niche makes host-owned DB/HTTP layers the norm)
is itself a real, teachable point about Lua's design. After finishing the core course,
[20-Exercises](20-Exercises/README.md)/[21-Solutions](21-Solutions/README.md) offer 8 further
standalone problems spanning the whole course, and
[22-Mini-Projects](22-Mini-Projects/README.md) is a complete CLI Task Tracker worth reading
end-to-end as a real, if small, application.

Lua is not one of the original 12 specified languages (Python through Dart) — it's an addition
from the broader spec's remaining language list, alongside Ruby, C, Haskell, and others built
after the original 12.
