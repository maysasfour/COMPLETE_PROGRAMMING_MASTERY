# 04 - Operators

## Key Points

- `..` is string concatenation — distinctive vs. `+` (used elsewhere for both numeric addition and, in many languages, string concatenation too). Numbers auto-coerce to strings when concatenated.
- `~=` is "not equal" — distinctive vs. `!=` used almost everywhere else in this repository.
- `//` is floor (integer) division; `/` is always float division since Lua 5.3.
- `^` is exponentiation (not `**`).
- `and`/`or`/`not` are keywords, not symbols (`&&`/`||`/`!`) — and `and`/`or` short-circuit, returning one of the actual operand values (not necessarily a boolean), the same idiom as JS's `||` for defaults: `nil or "default value"`.
- **No `++`/`--` at all** — `n = n + 1` is the only way to increment.
- `#` is the length operator, for strings and array-part tables.

## Run It

```bash
cd 01-Languages/Lua/04-Operators
lua example.lua
```

Real captured output:

```
10	4	21	3.5
3
1	1024.0
true	true
true	true	true	true
false	true	false
default value
false
hello world
count: 5
incremented:	6
5	3
```

## Common Beginner Mistakes

- Writing `a != b` out of habit — Lua requires `~=`.
- Writing `"count: " + 5` expecting concatenation — `+` is strictly numeric in Lua and errors on a non-numeric string; `..` is required.
- Writing `n++` — a syntax error; Lua has no increment/decrement operators.

## Best Practices

- Use `x and y or z` only when `y` is guaranteed truthy — if `y` can be `false`/`nil`, this idiom silently picks `z` instead, a classic Lua gotcha; prefer an explicit `if` in that case.

## Interview Questions

1. **What's Lua's string concatenation operator, and why not `+`?** `..` — `+` is reserved strictly for numeric addition and errors (or attempts numeric coercion) rather than concatenating, unlike many C-family/scripting languages that overload `+`.
2. **Does Lua have `++`/`--`?** No — `n = n + 1` / `n = n - 1` are the only ways to increment/decrement; this is a deliberate omission, not an oversight.
