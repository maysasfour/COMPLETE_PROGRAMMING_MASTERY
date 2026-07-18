# Solutions - Functions

Run: `lua example.lua` from this folder. Real, captured output:

```
$ lua example.lua
times3(4) =	12	 times5(4) =	20	 independent:	true
max_of(3,7,2,9,4) =	9
divide(10,2) =	5.0	true
divide(10,0) =	nil	false
first =	1	 rest =	2,3,4
```

Note `divide(10,2)` prints `5.0` — Lua 5.3+'s `/` always returns a float, even for evenly-divisible operands, a real, visible consequence of the integer/float subtype split introduced in 5.3.
