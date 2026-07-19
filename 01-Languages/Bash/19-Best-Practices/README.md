# 19 — Best Practices

[Back to Bash course](../README.md)

## `set -euo pipefail` Always

Covered in depth in Lesson 09 with a full before/after comparison; the summary rule is: put it on line 2 of every script (right after the shebang) unless you have a specific, documented reason not to.

## Quoting: The Real, Verified Word-Splitting Bug

The prerequisite lesson ([`19-Command-Line-and-Operating-Systems/01-Bash-Basics`](../../../19-Command-Line-and-Operating-Systems/01-Bash-Basics/README.md)) already demonstrated this in depth with real files that have spaces in their names — go read it if you haven't. The short version, re-verified here with a different scenario (a variable rather than command substitution):

```bash
$ file="my report.txt"
$ touch "$file"
$ for word in $file; do echo "piece: '$word'"; done
piece: 'my'
piece: 'report.txt'

$ for word in "$file"; do echo "piece: '$word'"; done
piece: 'my report.txt'
```

Unquoted `$file` in the `for` loop underwent word-splitting on the space, producing two separate iterations from what should have been one filename. Quoting (`"$file"`) fixed it, treating the whole value as a single word. This bug is genuinely dangerous in real scripts operating on `rm $file`, `mv $file $dest`, etc. — an unquoted `rm $file` on a value with a space silently tries to remove two (possibly wrong) paths instead of one.

## Shellcheck (Conceptually)

[ShellCheck](https://www.shellcheck.net/) is the de facto static analysis tool for Bash — it catches exactly this class of bug (missing quotes, `[ ]` misuse, unset-variable risk) before you ever run the script. It wasn't installed in this environment (`where shellcheck` found nothing), so it isn't demonstrated live here, but every script in this course was written with its rules in mind: quote all expansions, avoid useless `cat`, prefer `[[ ]]` over `[ ]` where Bash-only syntax is acceptable, and check exit codes explicitly rather than ignoring them.

## Summary Checklist

- [ ] `set -euo pipefail` at the top of every script.
- [ ] Every variable expansion quoted: `"$var"`, `"${arr[@]}"`.
- [ ] `local` for every function-scoped variable.
- [ ] `trap ... EXIT` for any resource needing guaranteed cleanup.
- [ ] `command -v tool` checks before depending on any external CLI (`jq`, `sqlite3`, etc.).
- [ ] Prefer `$(...)` over legacy backticks for command substitution.
- [ ] Prefer `[[ ]]` over `[ ]` in Bash-only scripts.
- [ ] Run ShellCheck (or read its rules) before considering a script "done."

## Common Beginner Mistakes

- Treating `set -euo pipefail` as optional "extra safety" rather than the default a script should start with.
- Quoting some variables but not others inconsistently, leaving the exact bug this lesson demonstrates lying in wait for the one unquoted case.
- Assuming a script "worked in testing" means it's quote-safe — the bug above only manifests once a value actually contains whitespace or glob characters, which testing often doesn't happen to include.

## Best Practices (Recap)

- Strict mode, quoting, and `local` are the three habits that prevent the overwhelming majority of real Bash bugs.
- Treat any external CLI dependency (`jq`, `sqlite3`, `curl`) as optional and check for it, rather than assuming it's installed everywhere your script runs.
- Read ShellCheck's rule list even if you can't run the tool in a given environment — the reasoning behind each rule is valuable independent of the tool itself.

## Interview Questions

1. Walk through a concrete before/after example of the quoting bug and explain exactly why the unquoted version breaks.
2. Why is `set -euo pipefail` sometimes still not enough to guarantee correct error handling (recall Lesson 09's caveats)?
3. What categories of bug does ShellCheck exist specifically to catch?
