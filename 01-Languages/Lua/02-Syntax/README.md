# 02 - Syntax

## What / Why

Lua's surface syntax is close to Ruby's in this repository: keyword-delimited blocks
(`end`, not `{}`), optional statement terminators, and comments starting with `--`.

## Key Points

- No semicolons required between statements — newlines (or nothing at all) separate them. Semicolons are legal but purely optional, occasionally used to visually separate statements crammed on one line.
- Every block — `if`, `while`, `for`, `function`, `do` — is closed with the keyword `end`, not curly braces.
- Single-line comments: `-- comment`. Multi-line comments: `--[[ ... ]]`.
- Indentation is not significant (unlike Python) — a pure style convention, verified live by a deliberately oddly-indented line that still runs.
- `do ... end` alone creates an anonymous scoping block, useful for confining a `local` to a specific region.

## Run It

```bash
cd 01-Languages/Lua/02-Syntax
lua example.lua
```

Real captured output:

```
no semicolon needed
two
statements one line
if-block needs 'then' ... 'end'
while loop ended, i =	3
this line is indented oddly but still runs fine
only visible inside this do block
```

## Common Beginner Mistakes

- Writing `if cond { ... }` out of C-family muscle memory — Lua requires `if cond then ... end`.
- Forgetting `then` after an `if`/`while`/`for` condition — a syntax error, easy to miss coming from Python (which uses `:`).

## Best Practices

- Use `do...end` to intentionally scope a `local` when you want to guarantee it can't leak past a specific region, even inside a larger function.
- Prefer consistent 2-space (or your team's chosen) indentation even though it's not enforced — readability matters more with no compiler-enforced structure.

## Interview Questions

1. **Does Lua require semicolons?** No — they're optional statement separators, occasionally used to visually group statements on one line, but newlines alone are sufficient.
2. **How does Lua delimit blocks?** With the `end` keyword closing whatever block-opening keyword started it (`if...end`, `while...end`, `for...end`, `function...end`), not curly braces.
