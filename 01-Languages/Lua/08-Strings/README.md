# 08 - Strings

## Key Points

- Strings are immutable — every "mutating" method (`:upper()`, `:gsub()`, ...) returns a **new** string, verified live (`s` is unchanged after calling `s:upper()`).
- `s:method(...)` is sugar for `string.method(s, ...)` — colon-call syntax on strings (Lua treats strings as having an implicit metatable pointing at the `string` library).
- `string.format` is Lua's printf-style formatter (`%s`, `%d`, `%.1f`, `%05d`, `%x`, ...) — there is **no built-in interpolation syntax** (`"#{x}"`/f-strings) at all; `..` concatenation (Lesson 04) and `string.format` are the only two ways to build a string from parts.
- Lua pattern matching (`:match`, `:gmatch`, `:gsub`, `:find`) is Lua's own lightweight matching syntax — `%d`/`%a`/`%s`, `+`/`*`/`-` (lazy) quantifiers, `()` captures — **not PCRE regex**. It genuinely lacks alternation (`|`) and several PCRE features, by deliberate design (keeps the matcher tiny).

## Run It

```bash
cd 01-Languages/Lua/08-Strings
lua example.lua
```

Real captured output:

```
Hello, Lua!	->	HELLO, LUA!
original unchanged:	Hello, Lua!
11	11
Hello
Lua!
hello, lua!
8	10
Hello, Lua! | Hello, Lua!
Ada scored 97.5%
00042
ff
Ada scored 97.456
captured date parts:	2026	07	19
found email:	alice@example.com
found email:	bob@test.org
trimmed: [spaced out]
**** **** ok	replacements:	2
```

## Common Beginner Mistakes

- Assuming Lua patterns support regex alternation (`cat|dog`) — they don't; matching either of two alternatives requires two separate `:match` calls or a character class if the alternatives are single characters.
- Forgetting that `%.` in a pattern is a literal dot (patterns use `%` to escape magic characters, not `\`) — a genuine, easy-to-miss syntax difference from PCRE/most regex flavors.

## Best Practices

- Reach for `string.format` over chained `..` concatenation once more than 2-3 pieces are involved — much more readable, and handles numeric formatting (`%.2f`, `%05d`) that plain concatenation cannot.
- For anything beyond simple patterns (nested groups, real alternation, lookaheads), consider whether a third-party PCRE binding (e.g. `lrexlib`) is actually warranted rather than fighting Lua patterns.

## Interview Questions

1. **Are Lua patterns the same as regular expressions?** No — Lua's pattern matching is a smaller, custom, non-PCRE syntax built into `string.find`/`match`/`gmatch`/`gsub`, deliberately simpler (no alternation `|`, limited quantifiers) to keep the matcher tiny for embedding.
2. **Does Lua support string interpolation like `"#{name}"` or f-strings?** No — Lua has no interpolation syntax at all; `..` concatenation and `string.format` are the only two ways to build a string from parts, a real, notable gap versus Ruby/Python/JS in this repository.
