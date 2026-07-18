# 06 - Functions

## Key Points

- Functions are first-class values — assignable to variables, passable as arguments, returnable from other functions, storable in tables (Lesson 12).
- Closures capture enclosing locals **by reference**, not by value — verified live: two independent counters created from the same factory function maintain fully separate captured state.
- Variadic functions use `...` to collect extra arguments; `{...}` packs them into a table, and `select("#", ...)` gives the true argument count (including embedded `nil`s that `ipairs` would stop at).
- **Multiple return values** — genuinely distinctive vs. most languages in this repository (which need a tuple/struct/array wrapper): `return a, b` really returns two independent values, capturable as `local x, y = f()`. Extra values are silently discarded if the caller doesn't capture them, and multi-returns only spread fully when they're in the *last* argument/expression position — verified live with `three()` truncating to a single value except when called last.

## Run It

```bash
cd 01-Languages/Lua/06-Functions
lua example.lua
```

Real captured output:

```
add(2,3) =	5
mul(4,5) =	20
apply(add,2,3) =	5
apply(mul,2,3) =	6
1	2	3
1
sum_all(1,2,3,4) =	10
count_args(1,nil,3) =	3
17 // 5, 17 % 5 =	3	2
only_q (extra discarded) =	3
three() spread as args:	1	2	3
three() truncated to 1 when not last:	1	next
```

## Common Beginner Mistakes

- Using `#{...}` to count variadic arguments — a `nil` in the middle breaks the sequence length; `select("#", ...)` is the correct tool, verified live (`count_args(1, nil, 3)` correctly reports 3, not 1 or 2).
- Assuming a multi-return call spreads everywhere it appears — it only spreads in the final position of an expression list; everywhere else it's truncated to its first value, verified live above.

## Best Practices

- Prefer `local function name(...)` over `name = function(...)` for named functions — it also correctly allows the function to call itself recursively by name (a plain `local name = function()` assignment doesn't have `name` in scope inside its own body yet at definition time).
- Use multiple return values for genuinely related outputs (e.g. quotient+remainder) instead of manufacturing a table just to return two things — idiomatic Lua leans on this feature.

## Interview Questions

1. **How do Lua closures capture variables?** By reference to the actual local variable (an "upvalue"), not by value — proven live above where two separate counters created from the same factory function maintain fully independent state, since each call to the factory creates a fresh `count` local.
2. **What happens to extra values from a multi-return function call that isn't the last item in an expression list?** They're truncated to a single value — only in the final position of a list (last argument to a call, last element of a table constructor, etc.) do all returned values spread out.
