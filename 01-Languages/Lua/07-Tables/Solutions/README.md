# Solutions - Tables

Run: `lua example.lua` from this folder. Real, captured output:

```
$ lua example.lua
sum_table =	25
original:	5,2,8,1,9
reversed:	9,1,8,2,5
top scorer:	Bo	95
great	1
fun	1
lua	3
is	2
```

Note the word-frequency loop's `pairs()` iteration order (`great, fun, lua, is`) is **not**
insertion order or alphabetical — Lua does not guarantee any particular `pairs()` order for
hash-part keys, a real, worth-remembering property distinct from `ipairs`'s guaranteed 1..n order.
