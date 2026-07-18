# 03 - Variables and Data Types

## What / Why

Lua is dynamically typed with 8 basic types (`nil`, `boolean`, `number`, `string`,
`function`, `userdata`, `thread`, `table`) — a variable holds whatever value it's
currently assigned, and can change type freely across its lifetime.

## The Global-by-Default Footgun (Verified Live)

This is Lua's single most consequential beginner trap, worse than most dynamic
languages' equivalents: **forgetting the `local` keyword does not create a variable
scoped to the current block or function — it silently creates (or overwrites) a
GLOBAL variable**, visible from anywhere in the program, stored in the real, inspectable
`_G` table.

```lua
function leaky()
  leaked = "I escaped my function!"   -- no `local` -- becomes _G.leaked
end
leaky()
print(leaked)          --> I escaped my function! (visible OUTSIDE the function)
print(_G.leaked)       --> I escaped my function! (proof it's a real global)
```

## Run It

```bash
cd 01-Languages/Lua/03-Variables-and-Data-Types
lua example.lua
```

Real captured output:

```
nil	boolean	number	number	string	function	table
x is	10	number
x is	now a string	string
an uninitialized local is	nil
leaked is visible outside its function:	I escaped my function!
contained is not visible (it was local):	nil
leaked lives in _G:	I escaped my function!
fixed() returns:	I stay contained
not_leaked is nil at top level (never leaked):	nil
```

## Common Beginner Mistakes

- Forgetting `local` — the footgun above, the single most common real-world Lua bug class in any codebase larger than a one-off script (see Lesson 19 for the fix pattern and a compounding-damage example).
- Assuming `nil` behaves like `0`/`false`/`""` in conditionals — only `nil` and `false` are falsy in Lua; `0` and `""` are both truthy (unlike C, Python, JS).

## Best Practices

- Declare every variable with `local` unless a global is deliberately intended (rare — usually only true top-level module-scope constants in small scripts).
- Declare locals as close as possible to first use, and prefer `do...end` blocks (Lesson 02) to scope temporaries tightly.

## Interview Questions

1. **What happens if you forget `local` in Lua?** The variable becomes a global, silently created or overwritten in the shared `_G` table, visible from anywhere in the program — verified live above, where a variable set inside one function was readable from completely outside it.
2. **Which values are falsy in Lua's conditionals?** Only `nil` and `false` — every other value, including `0` and `""` (empty string), is truthy, a real difference from C, Python, and JavaScript.
