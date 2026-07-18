# 01 - Setup

## What / Why

Lua is a small, fast, embeddable scripting language. Unlike most languages in this repository, Lua was designed from day one to be **embedded inside a host application** (written in C/C++) rather than run standalone as a general-purpose tool — its interpreter is a ~250KB core library, not a sprawling runtime. This is why Lua shows up as the scripting layer inside:

- **Game engines** — Roblox, World of Warcraft's UI, Garry's Mod, CryEngine, and many others embed Lua so designers can script gameplay without touching the C++ engine code.
- **Neovim/Vim** — Neovim's configuration and plugin system is native Lua.
- **Redis** — `EVAL` runs Lua scripts server-side for atomic multi-command operations.
- **nginx (OpenResty)** — Lua scripts handle request logic inside the web server itself.

You *can* also run Lua as a standalone scripting language (what this course does), but keep the embeddable design center in mind — it explains many of Lua's choices: no threads (coroutines instead, cheap to embed), a tiny standard library, and tables as the only data structure (easy for a host language to build and inspect).

## Installing Lua on Windows

There is no official Lua installer for Windows from lua.org (they ship source only). This course uses a **portable, self-contained** Lua 5.4.8 binary, matching this repository's established pattern of isolated toolchain installs (see the Ruby and PHP courses for the same approach), obtained from a GitHub-hosted prebuilt-binaries project (`rex-rbx/LuaOnWindows`) rather than the system-wide-installer route:

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

This single `lua.exe` is a statically-linked interpreter — no separate `.dll`, no installer, nothing written outside this repo's `tools/` folder. Every example in this course was run with this exact binary.

## REPL vs. Script Execution

Running `lua` with no arguments drops into an interactive REPL:

```
$ lua
Lua 5.4.8  Copyright (C) 1994-2025 Lua.org, PUC-Rio
> print("hi")
hi
> 2 + 2
4
> ^C
```

(The REPL evaluates expressions and prints results only when you prefix with `=`, e.g. `= 2+2`, in some Lua builds — Lua 5.4's REPL auto-prints bare expression statements too. Statements like `print(...)` calls are the reliable, portable way to see output in scripts.)

Running `lua path/to/file.lua` executes a script top to bottom, same as `ruby file.rb`, `php file.php`, or `python file.py` elsewhere in this repository — no separate compile step for normal use. (`luac` exists to pre-compile to bytecode, but it's optional and not needed for anything in this course.)

## How to Run the Examples

```bash
export PATH="/c/Users/HP/Complete-Programming-Mastery/tools/lua:$PATH"
cd 01-Languages/Lua/03-Variables-and-Data-Types
lua example.lua
```

Every lesson in this course was executed with this exact `lua.exe`; where output is shown in a README, it is real, captured output — never invented.

## Common Beginner Mistakes

- Assuming Lua ships a package manager (`pip`/`gem`/`npm` equivalent) out of the box — it doesn't. LuaRocks is the community standard but is a separate install (see Lesson 15).
- Expecting `lua` to be on `PATH` after "installing" — since there's no installer on Windows, you must add the binary's folder to `PATH` yourself in each shell (or persist it), as shown above.

## Best Practices

- Keep toolchain installs isolated (a project-local `tools/` folder, as above) rather than modifying system `PATH` permanently, especially when multiple language versions might coexist.
- Pin and document the exact Lua version used (5.4.8 here) — Lua 5.1/5.2/5.3/5.4 have real semantic differences (e.g. `..` and bitwise operators, `goto`, integer subtype added in 5.3) that matter for compatibility with embedding hosts like Redis (5.1) or Neovim (5.1-based LuaJIT).

## Interview Questions

1. **Why is Lua popular as an embedded scripting language rather than a standalone one?** Its interpreter is tiny and has a simple, well-documented C API for a host application to expose custom functions/data into Lua and call Lua code back — cheaper to embed than most alternatives, with tables/coroutines chosen specifically because they're simple for a host to implement and reason about.
2. **What's the difference between running `lua script.lua` and `luac`?** `lua` interprets a script directly, compiling to bytecode internally with no output file. `luac` is a separate ahead-of-time compiler that writes the bytecode to a file, useful for distributing code without source or for pre-flighting syntax errors — it's optional, not part of the normal dev loop.
