# Bash

[Back to Languages overview](../README.md) | [Back to repo root](../../README.md)

## What Bash Is

Bash (the "Bourne Again SHell") is the default interactive shell and scripting language on most Linux distributions and macOS (pre-Catalina), and ships as part of Git Bash / WSL on Windows. It is not a general-purpose programming language in the way Python or Ruby are — it is a command interpreter first, with scripting features layered on top so that sequences of commands can be automated, tested, and reused. There is no compiler and no separate build step: `bash script.sh` reads and executes a script's text directly, line by line, every run.

**Prerequisite / related lesson:** this repository already has a focused, single-topic lesson on a classic Bash gotcha — unquoted word-splitting — at [`19-Command-Line-and-Operating-Systems/01-Bash-Basics`](../../19-Command-Line-and-Operating-Systems/01-Bash-Basics/README.md). Read that first if you are completely new to shells; it is not repeated here. This course goes much deeper: functions, arrays, string manipulation, error handling, file I/O, process management, testing, and a full mini-project, treating Bash as a genuine (if unusual) scripting language rather than a single interactive habit.

## Why / Where It's Used

- **System administration and DevOps** — startup scripts, cron jobs, CI/CD pipeline steps (most GitHub Actions / GitLab CI "run" steps are Bash), Docker `ENTRYPOINT` scripts.
- **Build and release automation** — gluing together compilers, linters, test runners, and deployment tools that each have their own CLI.
- **Environment setup** — `.bashrc`/`.bash_profile`, installer scripts (`curl | bash` one-liners), dotfile management.
- **Data pipeline glue** — chaining `grep`/`sed`/`awk`/`curl`/`jq` into a single reproducible pipeline for quick text/log processing.
- **Portable "duct tape"** — Bash is present on nearly every Unix-like machine by default, making it the lowest-common-denominator automation language even when a "real" language would otherwise be preferred.

## Advantages

- Zero installation and zero build step on virtually every Unix-like system; scripts run immediately.
- Unmatched for orchestrating other command-line programs — piping (Lesson 12) and redirection (Lesson 10) are first-class, not bolted on.
- Genuine, real parallelism available cheaply via background jobs (`&`), `wait`, and `xargs -P`, verified live with real timing in Lesson 14.
- Extremely low overhead for small, one-off automation tasks compared to writing (and maintaining a runtime for) a Python/Ruby equivalent.
- `set -euo pipefail` plus `trap` give a genuine, if manually-opted-into, error-handling discipline (Lesson 09).

## Disadvantages

- **Everything is a string.** There is no real type system (Lesson 03) and no compile-time checking at all — most bugs are only caught at runtime, if at all.
- Arithmetic requires special syntax (`$(( ))`/`let`) — bare `+` on `$a + $b` concatenates strings instead of adding (a genuine, verified gotcha in Lesson 04).
- No true return values from functions — only 0–255 exit codes (Lesson 06); getting "real" data out requires command substitution `$(...)`, which is easy to misuse.
- Unquoted variable/command expansion silently word-splits and glob-expands, a frequent source of production bugs (see the linked prerequisite lesson, and Lesson 19).
- No built-in JSON, no built-in HTTP client, no built-in database driver, no package manager for scripts themselves (Lessons 15–17) — everything routes through external CLI tools (`curl`, `jq`, `sqlite3`), which may or may not be installed.
- Poor at anything CPU-bound or requiring real data structures beyond arrays/associative arrays (Lesson 07); nobody writes a JSON parser or a web server in Bash.

## Install Instructions

- **Linux**: pre-installed on almost every distribution (`bash --version` to check).
- **macOS**: ships with an old Bash 3.2 by default (licensing reasons); install a modern version with `brew install bash`.
- **Windows**: use Git Bash (bundled with [Git for Windows](https://git-scm.com/download/win)) or WSL (`wsl --install`). All examples in this course were run with Git Bash's `GNU bash, version 5.2.37(1)-release (x86_64-pc-msys)` on Windows.

## How to Run the Examples

Every code block in this course was actually executed with real Bash and its real output pasted in — nothing is simulated. To run an example yourself:

```bash
chmod +x script.sh   # make it executable (Lesson 01)
./script.sh          # run it
# or, without chmod:
bash script.sh
```

## Common Beginner Mistakes

1. **Forgetting spaces inside `[ ]`.** `[$x -gt 3 ]` is a syntax error / "command not found" — `[` is a real command (a synonym for `test`) and needs whitespace around every token (Lesson 02).
2. **Using `=`/`==` for numbers.** `[ "$a" = "$b" ]` compares strings; `10 = 9` is false but so is `2 = 2.0` — always use `-eq`/`-lt`/`-gt`/etc. for numbers (Lesson 04).
3. **Expecting `return` to hand back data.** `return` only sets a 0–255 exit code; to capture computed text, use `$(function_name ...)` (Lesson 06).
4. **Leaving variables unquoted.** `for f in $(ls dir)` or `rm $file` breaks the moment a value contains a space or glob character (prerequisite lesson; revisited in Lesson 19).
5. **Assuming a script fails loudly.** Without `set -e`, a failing command in the middle of a script is silently ignored and the script keeps going (Lesson 09).

## Best Practices (summary — full detail in Lesson 19)

- Start every script with `set -euo pipefail`.
- Quote every variable expansion: `"$var"`, not `$var`.
- Use `local` inside functions to avoid leaking variables into the global scope.
- Prefer `$(...)` over backticks for command substitution.
- Use `trap ... EXIT` for guaranteed cleanup of temp files.

## Table of Contents

| # | Lesson | Focus |
|---|--------|-------|
| 01 | [Setup](01-Setup/README.md) | Shebang, execution methods, `chmod +x` |
| 02 | [Syntax](02-Syntax/README.md) | Keywords not braces, whitespace rules |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) | Strings-only, `$VAR` vs `${VAR}`, `export` |
| 04 | [Operators](04-Operators/README.md) | Arithmetic vs string concatenation, comparison operators |
| 05 | [Control Flow](05-Control-Flow/README.md) | `if`/`case`/`for`/`while`/`until` |
| 06 | [Functions](06-Functions/README.md) | Exit codes vs real return values, `local` |
| 07 | [Arrays](07-Arrays/README.md) | Indexed and associative arrays, slicing |
| 08 | [Strings](08-Strings/README.md) | Parameter expansion, `printf` |
| 09 | [Error Handling](09-Error-Handling/README.md) | `$?`, `set -euo pipefail`, `trap` |
| 10 | [File Handling](10-File-Handling/README.md) | Redirection, `read`, test operators, JSON honesty |
| 11 | [Process Management](11-Process-Management/README.md) | `&`, `wait`, subshells, process substitution |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) | Functions as values, piping as composition |
| 13 | [No Generics](13-No-Generics/README.md) | Why generics don't apply here |
| 14 | [Concurrency](14-Concurrency/README.md) | Background jobs, `xargs -P`, real timing |
| 15 | [Modules and Sourcing](15-Modules-and-Sourcing/README.md) | `source`, no package manager |
| 16 | [Database Access](16-Database-Access/README.md) | `sqlite3` CLI (honest availability check) |
| 17 | [API Integration](17-API-Integration/README.md) | `curl` + `jq`/text fallback |
| 18 | [Testing](18-Testing/README.md) | Hand-rolled assert harness |
| 19 | [Best Practices](19-Best-Practices/README.md) | Strict mode, quoting, shellcheck |
| 20 | [Exercises](20-Exercises/README.md) | 8 practice problems |
| 21 | [Solutions](21-Solutions/README.md) | Verified solutions |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) | CLI Task Tracker (flat-file) |

## Interview Questions

1. Why can't a Bash function return a computed string the way `return` does in Python? How do you get one out?
2. What's the difference between `$var`, `"$var"`, and `${var}`? When would quoting change behavior?
3. Why does `[ "10" -gt "9" ]` succeed but `[ "10" \> "9" ]` (lexical) not necessarily agree with numeric expectations for larger numbers?
4. What does `set -euo pipefail` do, term by term, and why is it called "strict mode"?
5. What's the difference between running a script with `./script.sh` versus `source script.sh`?
6. How would you run four independent shell commands in parallel and wait for all of them?
7. Why does Bash have no generics, and does that limitation ever actually matter in practice?
8. What's the practical difference between an indexed array and an associative array in Bash 4+?
