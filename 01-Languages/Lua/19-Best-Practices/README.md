# 19 - Best Practices

## The Global-Leak Gotcha, Revisited With Real Consequences

Lesson 03 introduced the footgun; this lesson shows the actual damage it causes in a
slightly larger program, live: two completely unrelated functions that both forget
`local` for a variable named `result` silently **clobber each other's data** through the
shared `_G` table — a real, reproducible bug class, not a hypothetical one.

## Run It

```bash
cd 01-Languages/Lua/19-Best-Practices
lua example.lua
```

Real captured output:

```
6
global 'result' now polluted:	6
global 'result' clobbered by unrelated code:	oops, now a string
6
no global pollution this time:	nil
globals introduced after that point:	accidentally_global
```

Note the last line: even a top-level `function accidentally_global() end` (no `local`
keyword before `function`) is *also* a global leak — not just plain `variable = value`
assignments — demonstrated live via a `pairs(_G)` before/after diff that catches it.

## Best Practices Demonstrated

1. **Always prefix declarations with `local`** — including `function` definitions, which are implicitly global too unless written `local function name(...)`.
2. **Treat `_G` as a real, inspectable table** to audit accidental global creation — it's an ordinary table like any other, so a before/after `pairs(_G)` diff genuinely detects new globals, shown live above.
3. **Avoid metatable misuse** — don't build `__index` chains so deep that "where did this value come from" becomes a debugging chore, and always define `__tostring` on OOP-style tables (Lesson 11) so `print`/error messages stay readable instead of `table: 0x...`.
4. **Prefer module tables (Lesson 15) over globals** for sharing code between files — the deprecated `module()`/`package.seeall` pattern existed for exactly this failure mode and was removed for it.

## Common Beginner Mistakes

- Believing the global-leak issue only matters in "toy" scripts — verified live above that it causes a genuine, silent data-clobbering bug the moment two independent pieces of code happen to reuse the same sloppy variable name.
- Forgetting that `local function name()` differs from `function name()` — only the former is actually local; the latter is sugar for `name = function() ... end` at whatever scope it appears in, which is global at file top level.

## Interview Questions

1. **What's the single most important Lua-specific best practice, and why?** Always declaring `local` — Lua's global-by-default behavior (Lesson 03) is a real, silent bug source in any codebase larger than a one-off script, demonstrated live in this lesson with two unrelated functions clobbering the same accidental global.
2. **How can you detect accidental global creation in an existing script?** By diffing `pairs(_G)` before and after running the code in question — `_G` is a plain, inspectable table, so any newly-appeared key reveals a leaked global, shown live above catching an accidentally-global top-level `function` definition.
