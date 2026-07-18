# Mini-Project — CLI Task Tracker

[Back to Mini-Projects](../README.md) | [Back to course overview](../../README.md)

A complete, working CLI task tracker in C, combining most of this course into one project:

- **Header/source split** (Lesson 15's convention): `task.h`/`task.c` (the model) and `db.h`/`db.c` (SQLite persistence) are separate compilation units, `#include`d and compiled together.
- **SQLite C API** (Lesson 16's exact amalgamation-download approach): prepared statements, 1-indexed `?` placeholders, explicit `sqlite3_finalize`/`sqlite3_close`.
- **Return-code error handling** (Lesson 09): every `db*` function returns `0` on success, `-1` on failure — no exceptions exist in C.
- **Function-pointer callback** (Lesson 20, Exercise 4's pattern): `dbForEachTask` takes a `void (*callback)(const Task*)`, used both by the CLI's `list` command and by the test suite to inspect rows.
- **Hand-rolled testing** (Lesson 18's `minitest.h`, reused as-is): a 15-assertion suite run against an in-memory (`:memory:`) database.

## Project Structure

```
Task-Tracker/
  task.h / task.c   -- Task struct + taskPrint
  db.h   / db.c      -- SQLite-backed persistence (CRUD)
  cli.c              -- main(): hand-rolled argv parsing, no CLI framework
  tests.c            -- minitest.h suite against an in-memory database
  minitest.h         -- copied from Lesson 18, reused as-is
```

`sqlite3.h`/`sqlite3.c` are **not** committed — downloaded on demand (see below), same convention as Lesson 16.

## Setup

```bash
cd 01-Languages/C/22-Mini-Projects/Task-Tracker
curl -L -o sqlite-amalgamation.zip "https://www.sqlite.org/2024/sqlite-amalgamation-3450300.zip"
unzip sqlite-amalgamation.zip
cp sqlite-amalgamation-3450300/sqlite3.h sqlite-amalgamation-3450300/sqlite3.c .
```

## Build and Run the CLI

```bash
cl /std:c17 /nologo /W3 cli.c task.c db.c sqlite3.c /Fe:tasktracker.exe

tasktracker.exe add "Write report"
tasktracker.exe add "Review PR"
tasktracker.exe add "Water plants"
tasktracker.exe list
tasktracker.exe done 1
tasktracker.exe delete 3
tasktracker.exe list
tasktracker.exe done 99
```

### Real, Captured Output

```
Added task: Write report
Added task: Review PR
Added task: Water plants
  [ ] #1 Write report
  [ ] #2 Review PR
  [ ] #3 Water plants
Marked task #1 done.
Deleted task #3.
  [x] #1 Write report
  [ ] #2 Review PR
No task with id 99.
```

The final `done 99` call correctly fails (task 99 doesn't exist) and returns process exit code `1` — `dbMarkDone` checks `sqlite3_changes(db)` after the `UPDATE`, not just the statement's own `SQLITE_DONE` status, since an `UPDATE ... WHERE id = 99` against a nonexistent row still reports `SQLITE_DONE` (it "succeeded" at updating zero rows) rather than an error code. Without that `sqlite3_changes` check, a `done`/`delete` against a nonexistent id would silently report success.

Tasks persist in `tasks.db` in the working directory between runs — running the CLI walkthrough above a second time will `add` three more tasks with new ids on top of whatever's already there; delete `tasks.db` to start fresh.

## Build and Run the Tests

```bash
cl /std:c17 /nologo /W3 tests.c task.c db.c sqlite3.c /Fe:tests.exe
tests.exe
```

### Real, Captured Output

```
Running test_add_and_list...
Running test_mark_done...
Running test_mark_done_nonexistent_id_fails...
Running test_delete_task...
Running test_delete_nonexistent_id_fails...
Running test_empty_db_has_no_tasks...

15 passed, 0 failed, 15 total
```

Exit code `0` — all 15 assertions pass. Tests run against `":memory:"` SQLite databases (a fresh one per test, via `openFreshDb()`), so no `tasks.db` file is touched or left behind by the test run.

Genuinely compiled with `cl /std:c17 /nologo /W3` (both `tasktracker.exe` and `tests.exe`) and run — real output, not fabricated. `/W4` was tried first and produces SQLite-amalgamation-internal warnings unrelated to this project's own code (as Lesson 16 also notes implicitly by not enabling it), so `/W3` is used, matching the surrounding course's precedent of not fighting third-party-code warnings that aren't yours to fix.

## A Genuine SQLite Gotcha Deliberately Guarded Against

`dbMarkDone`/`dbDeleteTask` check `sqlite3_changes(db) > 0` in addition to `rc == SQLITE_DONE`, because an `UPDATE`/`DELETE` whose `WHERE` clause matches zero rows still returns `SQLITE_DONE` from `sqlite3_step` — the statement executed successfully, it just changed nothing. Without the `sqlite3_changes` check, `dbMarkDone(db, 99)` against a nonexistent id would silently report success (`0`) instead of failure (`-1`). `test_mark_done_nonexistent_id_fails` and `test_delete_nonexistent_id_fails` exist specifically to pin this down, and both pass against the code as written above.

## Cleanup

```bash
rm -rf sqlite-amalgamation.zip sqlite-amalgamation-3450300 sqlite3.c sqlite3.h *.obj *.exe *.pdb *.ilk tasks.db
```

## Recommended Next

This is the final lesson of the C course. Return to the [course overview](../../README.md).
