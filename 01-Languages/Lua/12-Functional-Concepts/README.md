# 12 - Functional Concepts

## Key Points

- Closures (Lesson 06) are the foundation — independent captured state per closure instance, verified live.
- Higher-order functions (`map`/`filter`/`reduce`, hand-rolled since Lua's stdlib doesn't ship them) — functions are ordinary values, so passing/returning them costs nothing special.
- A **table of functions** is Lua's closest analog to a dispatch table / strategy pattern — since functions are storable table values just like anything else.
- `table.sort(list, comparator)` — a real, stdlib higher-order-function usage: the comparator function fully controls sort order, verified live sorting ascending by age then descending by name on the same data.

## Run It

```bash
cd 01-Languages/Lua/12-Functional-Concepts
lua example.lua
```

Real captured output:

```
6	11
doubled:	2,4,6,8,10,12,14,16,18,20
evens:	2,4,6,8,10
sum via reduce:	55
dispatch table add:	7
dispatch table mul:	12
Bob	25
Alice	30
Carol	35
Carol
Bob
Alice
```

## Common Beginner Mistakes

- Assuming Lua ships `map`/`filter`/`reduce` in its stdlib — it doesn't; only `table.sort` (with an optional comparator) exists as a built-in higher-order function over tables, everything else must be hand-rolled or pulled from a library.
- Writing a `table.sort` comparator that isn't a strict, consistent ordering (e.g. using `<=` instead of `<`) — can cause undefined behavior/crashes in Lua's sort implementation.

## Best Practices

- Keep hand-rolled `map`/`filter`/`reduce` helpers in a shared module (Lesson 15) rather than redefining them per-script.
- Prefer a table-of-functions dispatch table over a long `if/elseif` chain when behavior is keyed by a string/enum-like value.

## Interview Questions

1. **Does Lua have built-in `map`/`filter`/`reduce`?** No — only `table.sort` ships as a genuine stdlib higher-order function; `map`/`filter`/`reduce` are commonly hand-rolled or pulled from a small utility library, unlike Ruby's `Enumerable` or Python's built-ins.
2. **How can a table act like a dispatch table / strategy pattern in Lua?** Since functions are ordinary values, a table can map string keys directly to function values (`{add = function(a,b) ... end}`), letting behavior be selected by a runtime key lookup instead of a branching chain.
