# 05 - Control Flow

## Key Points

- `if`/`elseif`/`else`/`end` — no `switch`/`case` in Lua at all (some patterns use table-based dispatch instead, see Lesson 12).
- `while cond do ... end`.
- `repeat ... until cond` — Lua's do-while equivalent, distinctive: the body runs **at least once**, and (unusually) locals declared inside the body are still visible in the `until` condition, since the condition is logically still "inside" the loop's scope.
- Numeric `for var = start, stop[, step] do ... end` — step defaults to 1, and a negative step must be given explicitly to count down.
- Generic `for` iterates via an iterator function: `ipairs` (sequence, 1..n, stops at first `nil`/hole) and `pairs` (every key, any order).
- `break` exists; **there is no `continue` keyword at all** — a real, notable Lua gap. The idiomatic workaround is `goto continue` + a `::continue::` label, or restructuring the loop body as an early-return guard.

## Run It

```bash
cd 01-Languages/Lua/05-Control-Flow
lua example.lua
```

Real captured output:

```
A	B	C	F
while sum 1..5 =	15
repeat iteration	1
repeat iteration	2
repeat iteration	3
repeat runs body before checking condition:	true
1 2 3 4 5 
10 8 6 4 2 
1	apple
2	banana
3	cherry
alice	30
bob	25
1 2 4 5 
```

## Common Beginner Mistakes

- Expecting `continue` to exist — it doesn't; use `goto continue`/`::continue::` or an `if not cond then ... end` guard instead.
- Using `pairs` when you actually want ordered, 1..n array iteration — `pairs` order is unspecified for non-sequence keys; `ipairs` is the right tool for array-part tables.
- Forgetting the step direction for a countdown `for` loop — `for i = 10, 1 do` silently runs **zero** times (default step is +1, so 10 > 1 never advances); the `-1`/`-2` step must be explicit.

## Best Practices

- Prefer `ipairs` for known array-shaped tables and `pairs` only when you genuinely need every key regardless of shape.
- Use `goto continue` sparingly and always with a clearly-named label — it is Lua's only real skip-to-next-iteration mechanism.

## Exercises / Solutions

See [Exercises](Exercises/README.md) and [Solutions](Solutions/README.md).

## Interview Questions

1. **How does `repeat...until` differ from `while`?** `repeat`'s body always executes at least once because the condition is checked *after* the body, and — distinctively — locals declared inside the body remain visible to the `until` condition itself, since the condition is part of the same scope.
2. **How do you skip to the next loop iteration in Lua?** There's no `continue` keyword; the idiomatic approach is `goto continue` with a `::continue::` label at the end of the loop body, or restructuring the body to use an early guard clause instead.
