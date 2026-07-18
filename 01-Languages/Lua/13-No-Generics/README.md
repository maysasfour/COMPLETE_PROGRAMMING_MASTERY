# 13 - No Generics (Because There's No Static Type System At All)

## The Honest Answer

Lua has **no generics**, but the reason is more fundamental than in this repository's other
dynamically-typed courses (Ruby, PHP, Python): those languages at least have classes and
a notion of a value's *type* being meaningfully checked at various points. Lua has:

- No static type system whatsoever — not even optional annotations in the base language.
- No compile-time type checking — `lua` never rejects a program for type mismatches before running it.
- No generic/template syntax (`<T>`, templates, `Comparable<T>`) — there has never been anything to parameterize, because there's no type-checked container class to parameterize in the first place.

This is a stricter version of the gap Python, Ruby, and PHP's courses each document — those
languages, at least, could theoretically retrofit type hints (Python's `typing`, PHP's type
declarations) onto a class-based container. Lua has no classes in the language at all (Lesson
11's metatable-based classes are a *pattern*, not a language feature), so there is nothing
for a hypothetical type system to even attach to.

## The Actual Mechanism: Untyped Tables, Always

A single Lua table happily holds any mix of types with zero complaint — this **is** Lua's generic
mechanism, present by default, with no opt-in:

```lua
local stack = {}
local function push(s, v) table.insert(s, v) end
local function pop(s) return table.remove(s) end

push(stack, 42)
push(stack, "a string")
push(stack, {nested = "table"})
push(stack, print)   -- yes, even a function value

print(pop(stack))   -- function: ...
print(pop(stack))   -- table: 0x...
print(pop(stack))   -- a string
print(pop(stack))   -- 42
```

Run for real:

```
$ lua no_generics.lua
function: 00007ff7dd2c2020
table: 00000220a6b4a4e0
a string
42
```

There is no `Stack<T>` to declare, and no way to constrain `stack` to only accept numbers even
if you wanted to — the language provides no hook for it. Any type discipline must be enforced
manually (e.g. a runtime `type(v) == "number"` check inside `push`), the same "duck typing is
the whole story" situation Ruby's Lesson 13 and Python/PHP describe, just with the type-hint
escape hatch those languages have also removed.

## Contrast Table

| Language (this repo) | Generics? | Type-checked container alternative |
|---|---|---|
| Java, C#, Kotlin, TypeScript, Rust, Go, Swift, Dart | Yes, real `<T>` syntax | N/A |
| C, C++ (pre-templates style) | No / templates (C++) | `void*` + manual casting (C) |
| Python, Ruby, PHP | No | Duck typing + optional runtime type hints |
| **Lua** | **No, and no type system to hint at all** | Untyped tables, always, by default |

## Best Practices

- Validate argument shapes explicitly with `type(x)` checks at a function's public boundary if a mismatch would cause a confusing failure deep inside — Lua will not catch it for you, ever.
- Document expected table "shapes" (which keys, which types) in comments near constructors, since there is no type system to encode this — a discipline problem, same as Python/Ruby/PHP but with less tooling support (no `typing` module equivalent in core Lua).

## Interview Questions

1. **Why doesn't Lua have generics?** Because it has no static type system at all — generics exist in other languages to let the type checker verify container contents at compile time; with no compile-time type checking in Lua, there's nothing for a generic parameter to constrain.
2. **How does Lua achieve what generics give other languages?** Every table is untyped by default — the same table can hold any mix of value types with zero declaration, demonstrated live above with a `Stack` holding a number, a string, a table, and a function simultaneously.
