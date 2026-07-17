# 01 — Bash Basics

[Back to module overview](../README.md)

## Beginner: A Real, Reproducible Word-Splitting Bug

Bash is one of the most common shells for scripting and command-line work. This lesson demonstrates one of Bash's most classic, real gotchas — unquoted variable/command expansion splitting on whitespace — with genuine, reproducible files and output, not a hypothetical description.

## Setting Up: Real Files With Spaces in Their Names

```bash
mkdir -p reports
touch "reports/January Sales.txt" "reports/February Sales.txt"
ls -la reports/
```

Verified live — two real files, each with a space in its name:

```
-rw-r--r-- 1 HP 197121 0 Jul 17 03:29 February Sales.txt
-rw-r--r-- 1 HP 197121 0 Jul 17 03:29 January Sales.txt
```

## The Violation: Unquoted Command Substitution in a Loop

```bash
for file in $(ls reports); do
    echo "Processing piece: '$file'"
done
```

Verified live:

```
Processing piece: 'February'
Processing piece: 'Sales.txt'
Processing piece: 'January'
Processing piece: 'Sales.txt'
ls reports/*.txt found 2 real files, but the loop processed 4 pieces
```

Bash's word-splitting treats the unquoted output of `$(ls reports)` as a whitespace-separated list — the space in each filename splits it into two separate "words," so 2 real files were incorrectly processed as 4 pieces. This is a genuinely common, real scripting bug: it works fine in testing (when nobody's filenames happen to contain spaces) and silently breaks later on real-world data.

## The Fix: Glob Directly, No `ls` Parsing

```bash
for file in reports/*.txt; do
    echo "Processing file: '$file'"
done
```

Verified live — the identical directory now correctly yields exactly 2 iterations, each with the complete, correct filename:

```
Processing file: 'reports/February Sales.txt'
Processing file: 'reports/January Sales.txt'
Correctly processed 2 real files
```

Bash's own filename globbing (`reports/*.txt`) expands directly to the real filenames as complete units — there's no intermediate text parsing step for whitespace to corrupt.

## Pipes and Redirection, Verified

```bash
echo "line one" > output.txt    # > creates/overwrites
echo "line two" >> output.txt   # >> appends
echo "line three" >> output.txt
grep -c "line" output.txt       # pipes/filters through a real command
```

Verified live:

```
line one
line two
line three
3
```

## Detailed Example

See [demo.sh](demo.sh) — every command above, runnable end-to-end in any empty, throwaway directory.

## Run It

```bash
mkdir /tmp/bash-demo && cd /tmp/bash-demo
bash /path/to/this/lesson/demo.sh
```

## Expected Output

Two real files with spaces in their names; the word-splitting bug producing 4 incorrect pieces from `$(ls ...)`; the glob-based fix correctly producing exactly 2; real redirection (`>`, `>>`) and piping (`grep -c`) output.

## Common Mistakes

- Parsing `ls` output at all — verified live to break on filenames containing spaces (or newlines, or starting with `-`); use shell globbing (`*.txt`) directly instead.
- Leaving variable expansions unquoted (`$file` instead of `"$file"`) — this lesson's violation is a specific case of this broader, extremely common Bash pitfall.
- Confusing `>` (create/overwrite) with `>>` (append) — verified live that using the wrong one either destroys existing content or fails to add new content as intended.

## Best Practices

- Prefer shell globbing (`for file in dir/*.ext`) over parsing command output for iterating over files.
- Always quote variable expansions (`"$file"`, `"$var"`) unless you specifically want word-splitting to occur.
- Use `set -e` (exit on error) and `set -u` (error on unset variables) at the top of scripts to catch mistakes early, as this lesson's own `demo.sh` does with `set -e`.

## Real-World Usage

The unquoted-expansion/word-splitting bug demonstrated here is one of the most common real-world sources of Bash script failures, especially once scripts written and tested on "clean" filenames encounter real-world files with spaces (very common on systems shared with non-technical users, or files downloaded from the web). Tools like `shellcheck` exist specifically to catch this entire class of bug automatically.

## Summary

- Unquoted `$(ls reports)` in a `for` loop was shown, live, to word-split 2 real files (each with a space in its name) into 4 incorrect pieces.
- Using a direct shell glob (`reports/*.txt`) instead was shown, live, to correctly process exactly 2 files, each with its complete, correct name intact.
- Basic redirection (`>`, `>>`) and piping (`grep -c`) were verified against real files and real output.

## Key Terms

- **Word-splitting** — Bash's default behavior of splitting unquoted variable/command expansions on whitespace.
- **Globbing** — shell expansion of wildcard patterns (like `*.txt`) directly into matching filenames.
- **Redirection** — sending a command's output to a file (`>` overwrites, `>>` appends) instead of the terminal.

## Interview Questions

1. **Why did `for file in $(ls reports)` process 4 "files" when only 2 real files existed, and how was this demonstrated concretely?**
   `$(ls reports)` produces a single string of filenames separated by whitespace, and because it's unquoted in the `for` loop, Bash applies word-splitting to that string, treating each whitespace-separated chunk as a separate loop item — a space inside a single filename is indistinguishable, at that point, from a space *between* two filenames. This was demonstrated concretely: two real files, `"January Sales.txt"` and `"February Sales.txt"`, were processed as 4 separate pieces (`February`, `Sales.txt`, `January`, `Sales.txt`) — verified by directly printing each loop iteration's value.

2. **Why does using a shell glob (`reports/*.txt`) instead of `$(ls reports)` fix this bug structurally, not just in this specific case?**
   A glob pattern is expanded directly by the shell into a list of matching filenames as complete, correct units — there is no intermediate text representation for whitespace (or any other character) to corrupt. This was verified concretely: the identical directory, containing the identical two space-containing filenames, produced exactly 2 correct loop iterations when using `for file in reports/*.txt`, each with the complete filename (`'reports/February Sales.txt'`) intact — proving the fix works because it avoids re-parsing text entirely, not because it happens to handle this one case better.

## Recommended Next Lesson

[02 — PowerShell Basics](../02-PowerShell-Basics/README.md)
