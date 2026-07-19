# 08 — Strings

[Back to Bash course](../README.md)

## Beginner: Parameter Expansion for String Manipulation — Verified Live

Bash has no string "methods" in the object-oriented sense — string manipulation happens through parameter expansion syntax on `${var...}`:

```bash
$ s="Hello-World.txt"
$ echo "${s%.txt}"
Hello-World
$ echo "${s#Hello-}"
World.txt
$ echo "${s/World/Bash}"
Hello-Bash.txt
$ echo "${s^^}"
HELLO-WORLD.TXT
$ echo "${s,,}"
hello-world.txt
```

| Expression | Meaning |
|---|---|
| `${s%pattern}` | remove the shortest match of `pattern` from the **end** |
| `${s%%pattern}` | remove the **longest** match from the end |
| `${s#pattern}` | remove the shortest match from the **start** |
| `${s##pattern}` | remove the longest match from the start |
| `${s/find/replace}` | replace the **first** occurrence |
| `${s//find/replace}` | replace **all** occurrences |
| `${s^^}` / `${s,,}` | uppercase / lowercase the whole string |
| `${s^}` / `${s,}` | uppercase / lowercase just the first character |
| `${#s}` | length of the string |
| `${s:offset:length}` | substring |

These are genuinely important because they let common string tasks (stripping an extension, extracting a basename, case conversion) happen without spawning an external process (`sed`, `awk`, `tr`) — meaningfully faster in a loop over many strings.

## `printf` for Formatted Output — Verified Live

`echo` has no real formatting story; `printf` (same format-string idea as C's `printf`) fills that gap:

```bash
$ printf "%-10s|%5d\n" "item" 42
item      |   42
```

`%-10s` left-justifies a string in a 10-character field; `%5d` right-justifies an integer in a 5-character field — useful for aligned table-style output (used in the Lesson 22 mini-project's task listing).

## Common Beginner Mistakes

- Confusing `#`/`##` (from the start) with `%`/`%%` (from the end) — easy to get backwards.
- Forgetting that `${s/find/replace}` only replaces the **first** match, then being surprised `${s//find/replace}` (double slash) is needed for all matches.
- Reaching for `sed`/`awk` for simple substitutions that parameter expansion already handles natively, adding an unnecessary external process.

## Best Practices

- Prefer built-in parameter expansion over spawning `sed`/`awk`/`cut` for simple, single-string operations.
- Use `printf` instead of `echo` whenever exact formatting (padding, precision, escape sequences) matters — `echo`'s behavior across shells/flags is less consistent.
- Quote `"${s}"` throughout to avoid re-triggering word-splitting on the result of any expansion.

## Interview Questions

1. What's the difference between `${s%pattern}` and `${s%%pattern}`?
2. How would you replace all occurrences of a substring versus just the first?
3. Why might you choose `printf` over `echo` for producing a report line?
