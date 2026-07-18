# 21 - Solutions

Worked, verified solutions to all [20-Exercises](../20-Exercises/README.md) problems.
`testkit.lua` is copied in from Lesson 18 so exercise 8 can `require` it directly.

## Run It

```bash
cd 01-Languages/Lua/21-Solutions
lua example.lua
```

Real, captured output (exercise 8 deliberately includes one failing test case, to prove
the harness genuinely detects it rather than only demonstrating the happy path):

```
=== 1. Global-leak audit ===
leak proven via _G:	leaked on purpose
fixed version returns:	stays local
no leak this time:	nil

=== 2. Sum at even 1-based indices ===
included:	t[2]=20, t[4]=40
sum:	60

=== 3. stats(...) multiple returns ===
count=6 sum=108 avg=18.00

=== 4. Pattern-match key=value parser ===
Ada	36	Lima

=== 5. Shape/Circle metatable inheritance ===
generic shape area:	0
circle area: 28.2743

=== 6. Coroutine even-number generator ===
evens up to 12: 2 4 6 8 10 12

=== 7. Error-safe parser ===
parsed:	42
failed to parse: example.lua:86: 'not a number' is not a valid number

=== 8. Hand-rolled test for is_even ===

1 passed, 1 failed
Failures:
  - intentionally wrong expectation: expected false, got true
```
