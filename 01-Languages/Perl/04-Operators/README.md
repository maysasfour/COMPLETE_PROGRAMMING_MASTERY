# 04 — Operators

[Back to course overview](../README.md) | [Previous: Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## Learning Objectives

- Distinguish `.` (string concat) from `+` (numeric add).
- Distinguish string comparison operators (`eq`/`ne`/`lt`/`gt`) from numeric ones (`==`/`!=`/`<`/`>`).
- Verify live that `"10" == "10.0"` is true but `"10" eq "10.0"` is false, and that string `lt` is lexicographic, not numeric.

## Concept

Perl has **two entirely separate operator sets** for "equal" and "add", because scalars don't carry a fixed type — `==`/`+` force numeric context, `eq`/`.` force string context.

See [`operators.pl`](operators.pl), run with `perl operators.pl`. Output (actual):

```
concat: 105
add:    15
"10" == "10.0" -> true
"10" eq "10.0" -> false
"9" lt "10" (string) -> false
9 < 10 (numeric)         -> true
xxxxx
1 2 1 2 1 2
```

Two things verified live and worth calling out explicitly:

1. `"10" == "10.0"` is **true** — both strings are coerced to the number `10` before comparing.
2. `"10" eq "10.0"` is **false** — `eq` compares the literal characters `"10"` vs `"10.0"`, which differ.
3. A genuine gotcha the interpreter surfaced honestly: `"9" lt "10"` is **false**. String comparison is lexicographic (character by character), and the character `'9'` sorts *after* `'1'`, so `"9"` is considered greater than `"10"` as strings — even though numerically `9 < 10`. This is a classic real-world Perl bug source (e.g. sorting version strings or numeric IDs stored as strings with `lt`/`sort` instead of `<=>`/numeric sort).

## Common beginner mistakes

- Using `==` on strings that aren't guaranteed numeric — Perl will warn (`use warnings` catches this) and treat non-numeric strings as `0`.
- Using `eq` when you meant `==` (or vice versa) — silently wrong results, no error.
- Sorting numeric-looking strings with default `sort` (which is `cmp`/lexicographic) instead of `sort { $a <=> $b }`.

## Best practices

- Use `==`/`!=`/`<`/`>`/`<=`/`>=` only on values you know are numeric.
- Use `eq`/`ne`/`lt`/`gt`/`le`/`ge` for strings, always.
- For sorting numbers stored as strings, always supply `{ $a <=> $b }` explicitly.
