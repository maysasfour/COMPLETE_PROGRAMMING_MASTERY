# 07 - Tables

## What / Why

Tables are Lua's **only** compound data structure — there is no separate array type,
dictionary/hash type, set type, or object type at the language level. Every one of those
concepts is built from the same underlying table, which associates keys (any non-`nil`
value) with values.

## 1-Based Indexing (Verified Live — a Real Gotcha)

Every other language course in this repository (C, Python, Ruby, PHP, Java, JavaScript,
...) uses 0-based indexing. Lua tables used as arrays are conventionally **1-based**:

```lua
local arr = {"a", "b", "c"}
print(arr[1])   --> "a"  -- the FIRST element, not the second
print(arr[0])   --> nil  -- there is no index 0 at all by convention
```

This isn't a language restriction (you *can* store a value at `arr[0]`), but the entire
standard library (`ipairs`, `#`, `table.insert`/`remove`, `table.concat`) assumes and
requires a 1-based, gap-free "sequence" to behave correctly — using 0-based indexing
alongside these functions produces silently wrong results (`#arr` and `ipairs` would
simply ignore anything stored at index 0).

## Run It

```bash
cd 01-Languages/Lua/07-Tables
lua example.lua
```

Real captured output:

```
arr[1] (first element) =	a
arr[0] (would be first element in 0-based langs) =	nil
#arr (length) =	3
arr[#arr] (last element) =	c
index	1	->	a
index	2	->	b
index	3	->	c
Ada	36
after birthday:	37
first	second	value	sparse
#mixed is only defined over the contiguous array part:	2
Acme employs Ada as Engineer
Acme employs Bo as Designer
t1[1] changed via t2 (same table):	999
after inserts:	0,5,3,1,4,2,6
after remove:	5,3,1,4,2,6
sorted:	1,2,3,4,5,6
apple in set:	true	  cherry in set:	false
```

## Common Beginner Mistakes

- Porting 0-based-indexing habits directly — `arr[0]` is simply a different (usually unused) slot, not an error, which makes the bug silent rather than a loud out-of-bounds exception.
- Assuming `#t` gives a mixed table's total entry count — `#` is only well-defined over the contiguous array part; a table with both array entries and a sparse/hash entry (like `mixed[10]` above) reports a length that ignores the sparse key entirely.
- Forgetting tables are reference types — assigning `t2 = t1` aliases the same table; mutating through `t2` is visible through `t1` too, verified live above.

## Best Practices

- Don't mix array-style and sparse/hash-style keys in the same table if you plan to rely on `#`/`ipairs` — keep "array tables" gap-free and 1-based, and use separate tables (or well-understood non-contiguous keys accessed only by `pairs`) otherwise.
- Use `table.insert`/`table.remove` rather than manual index shifting — they correctly maintain the sequence invariants `#`/`ipairs` depend on.

## Exercises / Solutions

See [Exercises](Exercises/README.md) and [Solutions](Solutions/README.md).

## Interview Questions

1. **Why is Lua's 1-based indexing considered a real gotcha for newcomers?** Because every other mainstream language most developers already know (C, Python, Java, JS, Ruby's own `Array` uses 0 too) is 0-based, so `arr[0]` being silently `nil` instead of erroring loudly makes off-by-one mistakes easy to introduce and hard to notice.
2. **How does Lua represent both an array and a dictionary at once?** With a single table type — the same table can have a contiguous integer-keyed "array part" and arbitrary other keys (strings, non-contiguous integers) in its "hash part" simultaneously, demonstrated live above with a table mixing positional and named entries.
