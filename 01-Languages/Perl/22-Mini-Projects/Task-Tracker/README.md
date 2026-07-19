# Mini-Project — CLI Task Tracker

[Back to course overview](../../README.md) | [Previous: Solutions](../../21-Solutions/README.md)

A small command-line task tracker: `add`, `list`, `done`, `remove`. Persistence and testing choices below were both driven by what actually works in this specific Perl 5.38.2 (msys2, Git for Windows) environment, verified live rather than assumed.

## Why file-based JSON persistence, not SQLite

[16-Database-Access](../../16-Database-Access/README.md) confirmed live that neither `DBI` nor `DBD::SQLite` is installed here:

```
$ perl -MDBI -e "print 1"
Can't locate DBI.pm in @INC ...
```

So this project uses `JSON::PP` (core, confirmed bundled — see [10-File-Handling](../../10-File-Handling/README.md)) plus plain file I/O for storage, via [`lib/TaskStore.pm`](lib/TaskStore.pm). This is the same technique used for the "kv store" exercise elsewhere in this course, applied here as the persistence layer for a full CLI tool. `TaskStore` reads/writes a single JSON file (`{ tasks: [...], next_id: N }`) and uses `flock` for basic concurrent-access safety.

## Why tests are run directly with `perl`, not `prove`

[18-Testing](../../18-Testing/README.md) confirmed live that `Test::More` is core and works, but that `prove` in this environment is broken by a missing dependency in its own core distribution (`TAP::Harness::Env`). Reproduced again here:

```
$ prove -v t/task_store.t
Can't locate TAP/Harness/Env.pm in @INC ...
```

The working alternative, also established in Lesson 18: `.t` files are ordinary Perl scripts, so running them directly with `perl` produces the same TAP output without needing the broken `prove` wrapper:

```
$ perl -I lib t/task_store.t
ok 1 - starts with no tasks
...
ok 16 - reloaded task retains done status
1..16
```

## Project layout

```
Task-Tracker/
  task_tracker.pl      # CLI entry point
  lib/TaskStore.pm      # JSON-file-backed persistence layer
  t/task_store.t        # Test::More test suite (16 assertions)
```

## Usage

```bash
cd 01-Languages/Perl/22-Mini-Projects/Task-Tracker
perl task_tracker.pl add "Buy milk"
perl task_tracker.pl list
perl task_tracker.pl done <id>
perl task_tracker.pl remove <id>
```

Tasks persist to `tasks.json` in the current directory by default. Set `TASK_TRACKER_DB=<path>` to use a different file (this is how the test suite avoids clobbering a real `tasks.json`).

## Full CLI walkthrough — actually run

```bash
$ export TASK_TRACKER_DB=demo_tasks.json
$ perl task_tracker.pl add "Buy milk"
added #1: Buy milk
$ perl task_tracker.pl add "Write Perl lesson"
added #2: Write Perl lesson
$ perl task_tracker.pl add "Walk the dog"
added #3: Walk the dog

$ perl task_tracker.pl list
[ ] #1 Buy milk
[ ] #2 Write Perl lesson
[ ] #3 Walk the dog

$ perl task_tracker.pl done 2
completed #2: Write Perl lesson

$ perl task_tracker.pl list
[ ] #1 Buy milk
[x] #2 Write Perl lesson
[ ] #3 Walk the dog

$ perl task_tracker.pl remove 1
removed #1

$ perl task_tracker.pl list
[x] #2 Write Perl lesson
[ ] #3 Walk the dog

$ perl task_tracker.pl done 999
error: no task with id 999

$ perl task_tracker.pl add ""
error: title must not be empty

$ perl task_tracker.pl
Task Tracker -- a small CLI backed by JSON::PP file persistence.

Commands:
  add <title>    add a new task
  list           list all tasks
  done <id>      mark task <id> complete
  remove <id>    delete task <id>
```

Underlying `demo_tasks.json` after the sequence above:

```json
{"tasks":[{"id":2,"title":"Write Perl lesson","done":1},{"id":3,"title":"Walk the dog","done":0}],"next_id":4}
```

## Test suite — actually run

```bash
$ perl -I lib t/task_store.t
ok 1 - starts with no tasks
ok 2 - first task gets id 1
ok 3 - title stored correctly
ok 4 - new task is not done
ok 5 - second task gets id 2
ok 6 - list returns both tasks
ok 7 - complete() marks task done
ok 8 - completed task persists as done in list()
ok 9 - complete() dies on unknown id
ok 10 - remove() deletes the task
ok 11 - remaining task is the right one
ok 12 - remove() dies on unknown id
ok 13 - add() rejects empty title
ok 14 - persisted state reloads correctly from disk
ok 15 - reloaded task has correct title
ok 16 - reloaded task retains done status
1..16
```

All 16 assertions pass, including a reload-from-disk check (`TaskStore->new` against the same path in a fresh instance) that proves persistence genuinely round-trips through the JSON file rather than only working in-memory.

## Common beginner mistakes

- Forgetting to `flock` around reads/writes of a shared file — concurrent CLI invocations could otherwise interleave writes and corrupt the JSON.
- Comparing task ids with `eq` instead of `==` — ids here are integers from `@ARGV`, which arrive as strings; `==` does the right numeric coercion.
- Not distinguishing "no such task" from "task exists but is falsy" — `remove`/`complete` here explicitly `die` on a missing id rather than silently no-op-ing.

## Best practices

- Keep the storage layer (`TaskStore.pm`) separate from the CLI (`task_tracker.pl`) so the persistence logic can be unit-tested without invoking the CLI at all.
- Make the storage path configurable via environment variable so tests never touch the real data file.
- Verify environment assumptions (module availability, `prove` working) with a live one-liner before building a lesson or project around them, rather than assuming a "standard" toolchain is present.
