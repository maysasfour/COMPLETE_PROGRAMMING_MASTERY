# 05 — Control Flow

[Back to Bash course](../README.md)

## Beginner: `if`/`elif`/`fi`

```bash
x=5
if [ "$x" -gt 10 ]; then
  echo "big"
elif [ "$x" -gt 3 ]; then
  echo "medium"
else
  echo "small"
fi
```

## `case`/`esac` — Verified Live

```bash
$ fruit="apple"
$ case "$fruit" in
>   apple) echo "it's an apple" ;;
>   banana) echo "it's a banana" ;;
>   *) echo "unknown" ;;
> esac
it's an apple
```

Each pattern ends with `)`, the matching branch ends with `;;`, and `*` is the catch-all default — closer to a pattern-match than a C `switch`, since patterns can include globs (`ba*)`) and alternation (`apple|apricot)`).

## `for`, `while`, `until` — Verified Live

```bash
$ for i in 1 2 3; do echo "for: $i"; done
for: 1
for: 2
for: 3

$ n=0; while [ $n -lt 3 ]; do echo "while: $n"; n=$((n+1)); done
while: 0
while: 1
while: 2

$ n=0; until [ $n -ge 3 ]; do echo "until: $n"; n=$((n+1)); done
until: 0
until: 1
until: 2
```

`while` loops while its condition is true; `until` loops while its condition is **false** (i.e., until it becomes true) — the two are mirror images of each other, and either can always be rewritten as the other with a negated condition.

## Common Beginner Mistakes

- Forgetting `;;` at the end of each `case` branch — without it, Bash won't know where one pattern's commands end and the next pattern begins.
- Iterating `for i in $(seq 1 "$n")` when `for ((i=1;i<=n;i++))` (C-style, also valid in Bash) avoids spawning an external `seq` process.
- Confusing `while`/`until` — reaching for `while ! cond` when `until cond` says the same thing more directly.

## Best Practices

- Prefer `case` over long `if`/`elif` chains when matching one variable against several fixed patterns — it reads cleaner and is genuinely a different (pattern-matching) construct.
- Use `for f in dir/*` (glob) rather than `for f in $(ls dir)` (word-split, see the prerequisite lesson) whenever iterating over files.

## Interview Questions

1. What terminates a `case` branch, and what happens if you omit it?
2. Rewrite a `while` loop as an equivalent `until` loop.
3. Why is `for f in dir/*.txt` generally safer than `for f in $(ls dir/*.txt)`?

## Exercises and Solutions

See [Exercises](../20-Exercises/README.md) items 1–2 and their [Solutions](../21-Solutions/README.md).
