# 08 — Strings

[Back to course overview](../README.md) | [Previous: Collections](../07-Collections/README.md)

## Learning Objectives

- Verify live that interpolation happens only in double-quoted strings, not single-quoted.
- Use `=~`, `m//`, and `s///` for regex matching and substitution.

## Concept

See [`strings.pl`](strings.pl), run with `perl strings.pl`. Output (actual):

```
double: Hello World
single: Hello $name
found number: 42
word count: 9
original:  The quick brown fox jumps over 42 lazy dogs
censored:  The quick brown cat jumps over 42 lazy dogs
date swap: 19/07/2026
```

- `"Hello $name\n"` interpolates `$name` and expands `\n` — double quotes.
- `'Hello $name'` prints the literal characters `$name` — single quotes never interpolate or expand escapes (other than `\'` and `\\`).
- `$text =~ /(\d+)/` binds a regex match against `$text`; capture groups populate `$1`, `$2`, ... after a successful match.
- `($text =~ /(\w+)/g)` in list context (assigned to `@words`) returns *all* matches, not just the first.
- `s/fox/cat/` performs a substitution and returns true/false (number of substitutions); `(my $censored = $text) =~ s/.../.../ ` is the idiom for "substitute into a *copy*" without mutating the original.
- The date-swap example shows capture groups `$1`/`$2`/`$3` reused directly inside the replacement string.

## Common beginner mistakes

- Expecting `'...'` (single quotes) to interpolate variables — it never does.
- Forgetting `/g` when you want *all* matches instead of just the first.
- Mutating the original string accidentally with `$text =~ s/.../.../ ` instead of substituting into a copy.

## Best practices

- Use single quotes for genuinely literal strings (regex patterns pasted as-is, shell commands) to avoid accidental interpolation of `$`/`@`.
- Use double quotes when you actually need interpolation; don't default to double quotes everywhere out of habit if `use warnings` is flagging unintended interpolation of `@` in strings containing literal `@` (e.g. email addresses) — escape with `\@` or use single quotes.
