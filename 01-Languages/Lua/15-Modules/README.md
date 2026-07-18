# 15 - Modules

## Key Points

- `require("modulename")` loads and **caches** a module — a second `require` of the same name returns the cached table without re-running the file, verified live.
- Modern idiom: a module file builds a local table (`M`), attaches functions/values to it, and `return M` at the end — no special keyword needed.
- Legacy `module("name", package.seeall)` pattern (pre-5.2) is deprecated/removed by default in 5.2+ specifically because it implicitly created a **global** for the module and polluted the caller's scope — the same "forgetting `local` leaks globally" problem from Lesson 03, baked into a former stdlib feature.
- LuaRocks is the community-standard package manager (conceptually, like RubyGems/pip/npm) — `luarocks install <name>` — not used for this lesson, which relies only on a genuinely local module file needing no package manager.

## Run It

```bash
cd 01-Languages/Lua/15-Modules
lua example.lua
```

Real captured output:

```
25
true	false
3.14159
same table object (cached):	true

=== LuaRocks, conceptually ===
...
```

(full conceptual note included in the script's own output — see `example.lua`)

## Common Beginner Mistakes

- Assuming `require` re-runs the module file every call — it doesn't; the first `require` executes and caches the returned table, and every subsequent `require` of the same name returns that cached table, verified live above.
- Using the deprecated `module()` pattern from old tutorials/StackOverflow answers — it's removed by default in Lua 5.2+ and pollutes globals even when it did work.

## Best Practices

- Always use the `local M = {}; ... ; return M` pattern for new modules — the only idiomatic approach in current Lua.
- Keep `package.path` search locations explicit/documented in larger projects, since `require`'s default search rules can silently pick up an unintended same-named file.

## Interview Questions

1. **What does `require` do the second time it's called with the same module name?** Returns the already-cached table from the first call without re-executing the module file — verified live above by comparing two `require("mathutils")` results with `==`.
2. **Why was the old `module()` function removed from Lua 5.2+ by default?** Because it implicitly created a global variable for the module and injected `package.seeall` into the calling scope, silently polluting globals — exactly the failure mode Lesson 03's `local`-omission footgun describes, baked into a former standard-library feature.
