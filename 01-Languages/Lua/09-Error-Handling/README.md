# 09 - Error Handling

## What / Why

Lua has **no exceptions in the conventional sense** — no `try`/`catch`/`throw` keywords,
no typed exception hierarchy. Errors are raised with the ordinary function `error()` and
caught with the ordinary functions `pcall`/`xpcall` — genuinely just functions, not
special language syntax (unlike `begin/rescue`, `try/catch`, `try/except` elsewhere in
this repository).

## Run It

```bash
cd 01-Languages/Lua/09-Error-Handling
lua example.lua
```

Real captured output:

```
pcall(risky, 16):	true	4.0
pcall(risky, -4):	false	09-Error-Handling/example.lua:6: x must not be negative
pcall on real runtime error:	false	09-Error-Handling/example.lua:20: attempt to perform arithmetic on a nil value
structured error caught:	false	404	not found
xpcall result:	false	handled: 09-Error-Handling/example.lua:6: x must not be negative
assert-based check:	false	09-Error-Handling/example.lua:39: expected a positive number, got -5
```

## Contrast with This Repository's Other Courses

| Language | Mechanism |
|---|---|
| Ruby, Python, PHP, Java, JS, etc. | `begin/rescue`/`try/except`/`try/catch` — language keywords, typed exception hierarchies |
| **Lua** | `pcall`/`xpcall`/`error()` — ordinary functions, no exception type system at all |

`error()` can raise **any value**, not just a string — a table is a common idiom for
structured errors (`error({code=404, message="not found"})`), verified live above.

## Common Beginner Mistakes

- Assuming a runtime error (e.g. `nil + 1`) needs `error()` to be "catchable" — it doesn't; `pcall` catches genuine runtime errors just as readily as explicit `error()` calls, verified live above.
- Forgetting that `pcall` returns `false, message` (not raising further) on failure — code that doesn't check the boolean first return value will silently treat an error message as a normal result.
- Not using `xpcall` when a traceback/cleanup handler is genuinely needed — `pcall`'s handler-less catch loses stack context that `xpcall`'s message handler can capture while the stack is still unwound.

## Best Practices

- Wrap only the narrow risky call in `pcall`, not large blocks of unrelated code, so a failure's source stays obvious.
- Prefer raising structured tables (`error({code=..., message=...})`) over bare strings when calling code needs to branch on error *kind*, not just display a message.

## Interview Questions

1. **How does Lua handle what other languages call exceptions?** Via `error()` to raise (any value, not just strings) and `pcall`/`xpcall` to catch — both are ordinary functions, not special syntax, and there is no built-in typed exception hierarchy to catch selectively by type.
2. **What does `pcall` return?** `true, result...` on success, or `false, error_value` on failure — verified live above with both a caught `error()` call and a genuine uncaught runtime error (`nil + 1`), both correctly reported as `false, <message>`.
