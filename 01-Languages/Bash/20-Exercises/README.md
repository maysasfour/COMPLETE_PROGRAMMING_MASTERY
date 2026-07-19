# 20 — Exercises

[Back to Bash course](../README.md)

These span the whole course. Solutions with real, verified output are in [21-Solutions](../21-Solutions/README.md).

1. **Setup**: Write and run a script that prints your Bash version and the current working directory, made executable with `chmod +x`.
2. **Operators**: Write a script that takes two numbers as `$1`/`$2` and prints whether the first is numerically greater, less than, or equal to the second — using the correct numeric operators.
3. **Control Flow**: Write a script that loops from 1 to 20 and, using `case`, prints "low" (1–7), "mid" (8–14), or "high" (15–20) for each number.
4. **Functions**: Write a function `to_uppercase` that takes a string and prints its uppercase form; capture and print the result for three different input strings.
5. **Arrays**: Given an array of filenames (some with `.txt`, some with `.sh`), build two new arrays — one of just the `.txt` files, one of just the `.sh` files — using parameter expansion to check suffixes.
6. **Error Handling**: Write a script with `set -euo pipefail` and a `trap` that creates a temp file, deliberately fails partway through (e.g., calls a nonexistent command), and prove via output that the trap still ran.
7. **File Handling + Strings**: Write a script that reads a file of `key=value` lines and prints each as `key -> value`, skipping blank lines.
8. **Mini-Integration**: Write a script that calls `curl` against `https://jsonplaceholder.typicode.com/todos/2`, checks the HTTP status code, and extracts the `"completed"` field's value using `grep`/`sed` (since this course's environment has no `jq`).
