# 09 — Error Handling

[Back to Bash course](../README.md)

## Beginner: `$?` and Bash's Default (Lack of) Error Handling — Verified Live

By default, Bash does **not** stop when a command fails — it just moves to the next line:

```bash
$ cat loose.sh
#!/usr/bin/env bash
echo "start"
mightfail_command_typo
echo "this still runs even though the command above failed"
echo "undefined var: [$UNDEFVAR]"

$ bash loose.sh
start
loose.sh: line 3: mightfail_command_typo: command not found
this still runs even though the command above failed
undefined var: []
$ echo "exit code: $?"
exit code: 0
```

Two things went wrong silently here: the typo'd command failed, but the script kept running anyway; and `$UNDEFVAR`, which was never set, silently expanded to an empty string rather than erroring. The script's overall exit code was even `0` (success) — the exit code reported is that of the *last* command run (`echo`), not the failed one in the middle.

## The Fix: `set -euo pipefail` ("Strict Mode") — Verified Live

```bash
$ cat strict.sh
#!/usr/bin/env bash
set -euo pipefail
echo "start"
mightfail_command_typo
echo "this should NOT print"

$ bash strict.sh
start
strict.sh: line 4: mightfail_command_typo: command not found
$ echo "exit code: $?"
exit code: 127
```

With `set -euo pipefail` at the top:

- `-e` — exit immediately if any command fails (nonzero exit), instead of continuing.
- `-u` — treat any reference to an unset variable as an error, instead of silently substituting an empty string.
- `-o pipefail` — in a pipeline (`a | b | c`), the whole pipeline's exit status is the *first* nonzero exit code among its stages, instead of just the last stage's (without this, `false | true` reports success).

The failing script now stopped immediately after the typo'd command, and "this should NOT print" never ran — the exit code `127` ("command not found") propagated as the script's real exit status.

## `trap` for Guaranteed Cleanup — Verified Live

```bash
$ cat trapdemo.sh
#!/usr/bin/env bash
tmpfile=$(mktemp)
trap 'echo "cleaning up $tmpfile"; rm -f "$tmpfile"' EXIT
echo "working with $tmpfile"
echo "data" > "$tmpfile"
cat "$tmpfile"

$ bash trapdemo.sh
working with /tmp/tmp.hNr6KAvUFt
data
cleaning up /tmp/tmp.hNr6KAvUFt
```

`trap '...' EXIT` registers a command to run whenever the script exits — whether it finishes normally, hits `set -e`, or is interrupted (`trap ... INT` for Ctrl+C specifically). This guarantees the temp file gets removed even if the script fails partway through, which a plain `rm` at the bottom of the script would not (it would never be reached on an early failure).

## Common Beginner Mistakes

- Assuming Bash scripts "crash" on error like most other languages — they silently continue unless `set -e` is used.
- Adding `set -e` but not `set -u`, missing typo'd or unset variables that quietly evaluate to empty strings.
- Forgetting that `set -e` has well-known exceptions (a failing command inside an `if` condition, or on the left side of `&&`/`||`, does **not** trigger it) — strict mode is a strong default, not a hard guarantee.

## Best Practices

- Start every real script with `set -euo pipefail`.
- Use `trap ... EXIT` for any resource that needs guaranteed cleanup (temp files, background processes, lock files).
- Check `$?` explicitly right after a command when you need to branch on success/failure but don't want the whole script to exit on that particular failure (temporarily disable `-e` locally, or use `if cmd; then ... fi`, which doesn't trigger `-e` regardless).

## Interview Questions

1. What does each of `-e`, `-u`, and `-o pipefail` individually protect against?
2. Why does `set -e` alone not catch a reference to an undefined variable?
3. Why is `trap ... EXIT` more reliable than cleanup code at the bottom of the script?
