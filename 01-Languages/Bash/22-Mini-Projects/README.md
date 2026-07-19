# 22 — Mini-Project: CLI Task Tracker

[Back to Bash course](../README.md)

## What This Project Is

A complete, working command-line task tracker, built entirely in Bash, persisting tasks to a flat pipe-delimited file (`id|status|description`) rather than a real database. Lesson 16 documented that `sqlite3` is **not installed** in this course's environment; rather than write a database-backed project against a tool that can't actually be run and verified live, this mini-project uses the flat-file approach — a legitimate, honestly-scoped alternative for small, single-user, local persistence — and every command below was genuinely executed.

It draws on nearly every earlier lesson: functions (06), file redirection/`read` (10), `set -euo pipefail` and `trap`-free-but-`mv`-based atomic writes (09), string/array parsing (07/08), and the assert-based test harness (18).

## Files

- `tasktracker.sh` — the CLI itself (`add`, `list`, `done`, `rm`).
- `assert.sh` — the Lesson 18 test harness, reused unmodified.
- `tasktracker_test.sh` — automated tests against the CLI, using an isolated temp data file.

## How Persistence Works

Each task is one line: `id|status|description`. `add` appends a line; `done` rewrites the whole file with the matching row's status flipped to `done` (via a temp file + atomic `mv`, so a crash mid-write can't corrupt the real data file); `rm` filters out the matching line the same way.

## Full CLI Walkthrough — Verified Live

```bash
$ export TASK_DATA_FILE="$PWD/demo_tasks.db"
$ ./tasktracker.sh
Usage: tasktracker.sh <command> [args]
Commands:
  add <description>   Add a new task
  list                 List all tasks
  done <id>            Mark a task as done
  rm <id>              Remove a task

$ ./tasktracker.sh add "Write Bash course lessons"
Added task #1: Write Bash course lessons
$ ./tasktracker.sh add "Run every example live"
Added task #2: Run every example live
$ ./tasktracker.sh add "Update BUILD_STATUS.md"
Added task #3: Update BUILD_STATUS.md
$ ./tasktracker.sh list
ID   STATUS     DESCRIPTION
1    pending    Write Bash course lessons
2    pending    Run every example live
3    pending    Update BUILD_STATUS.md

$ ./tasktracker.sh done 2
Marked task #2 as done
$ ./tasktracker.sh list
ID   STATUS     DESCRIPTION
1    pending    Write Bash course lessons
2    done       Run every example live
3    pending    Update BUILD_STATUS.md

$ ./tasktracker.sh rm 1
Removed task #1
$ ./tasktracker.sh list
ID   STATUS     DESCRIPTION
2    done       Run every example live
3    pending    Update BUILD_STATUS.md

$ ./tasktracker.sh done 99
No such task #99
$ echo "exit: $?"
exit: 1
```

Marking a nonexistent task correctly failed with a clear message and a nonzero exit code, rather than silently succeeding.

## Running the Test Suite — Verified Live

```bash
$ bash tasktracker_test.sh
PASS: add returns confirmation
PASS: second add gets id 2
PASS: list shows 2 tasks
PASS: task 1 marked done
PASS: list shows 1 task after rm
Results: 5 passed, 0 failed
$ echo "exit: $?"
exit: 0
```

The test file sets `TASK_DATA_FILE` to a fresh `mktemp` path and `trap`s its removal on exit, so it never touches your real task data and cleans up after itself even if a test fails midway.

## Try It Yourself

```bash
chmod +x tasktracker.sh
./tasktracker.sh add "My first task"
./tasktracker.sh list
```

By default (no `TASK_DATA_FILE` override), tasks persist to `~/.tasktracker/tasks.db` across runs.

## Possible Extensions

- Add a `priority` field (a fourth `|`-delimited column) and a `list --sort-priority` flag.
- Swap the flat file for real `sqlite3` persistence if/when that CLI is available, reusing the same command interface (`add`/`list`/`done`/`rm`).
- Add a `bats` test suite alongside (or instead of) the hand-rolled harness, per Lesson 18.
