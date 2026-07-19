# 10 — File Handling

[Back to Bash course](../README.md)

## Beginner: Redirection — Verified Live

```bash
$ echo "line1" > out.txt
$ echo "line2" >> out.txt
$ cat out.txt
line1
line2
```

`>` overwrites (truncates) the target file; `>>` appends. Both create the file if it doesn't exist. `<` redirects a file's contents into a command's stdin.

## Reading a File Line by Line with `read` — Verified Live

```bash
$ while read -r line; do echo "read: $line"; done < out.txt
read: line1
read: line2
```

`read -r` reads one line at a time into `line`; `-r` disables backslash-escape interpretation, which is almost always what you want when reading arbitrary file content (without `-r`, a trailing `\` would splice lines together). The `< out.txt` at the end of the `while` feeds the file to the loop's stdin.

## Test Operators — Verified Live

```bash
$ [ -f out.txt ] && echo "out.txt is a file"
out.txt is a file
$ [ -d out.txt ] && echo "is dir" || echo "out.txt is not a dir"
out.txt is not a dir
$ [ -e nonexistent.txt ] && echo "exists" || echo "nonexistent.txt does not exist"
nonexistent.txt does not exist
```

| Operator | Tests |
|---|---|
| `-f path` | is a regular file |
| `-d path` | is a directory |
| `-e path` | exists (any type) |
| `-r path` / `-w path` / `-x path` | readable / writable / executable |
| `-s path` | exists and has size > 0 |

## Honest Limitation: No Built-In JSON

Bash has no native structured-data type at all — everything is text — and correspondingly no built-in JSON parser/serializer. Handling JSON in real Bash scripts means shelling out to an external tool, almost universally **`jq`**, which is not part of Bash itself and must be installed separately. This course's environment did **not** have `jq` installed:

```bash
$ where jq
INFO: Could not find files for the given pattern(s).
```

Lesson 17 (API Integration) shows both the `jq`-based approach (documented, not runnable here) and a real, verified `grep`/`sed`-based fallback for simple flat JSON when `jq` genuinely isn't available — which is honest about being fragile (it breaks on nested/complex JSON) but works for simple cases without any dependency.

## Common Beginner Mistakes

- Using `>` when `>>` was intended, silently destroying existing file content.
- Forgetting `-r` on `read`, causing backslashes in input to be misinterpreted.
- Assuming Bash can parse JSON/YAML/XML natively — it cannot; every real script needs an external tool for structured data.

## Best Practices

- Always use `read -r` unless you specifically want backslash escape processing.
- Prefer `>>` explicitly when appending is intended, to make the intent visible in the script itself.
- Check file existence/type with the correct test operator (`-f` vs `-e` vs `-d`) rather than assuming.

## Interview Questions

1. What's the difference between `>` and `>>`?
2. Why is `read -r` almost always preferred over plain `read`?
3. How does Bash itself handle JSON, and what does a real script typically do instead?
