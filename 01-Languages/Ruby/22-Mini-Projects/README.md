# 22 — Mini-Projects

[Back to course overview](../README.md) | [Previous: Solutions](../21-Solutions/README.md)

## CLI Task Tracker

A complete, small command-line application combining most of this course's lessons: `sqlite3`-backed persistence (Lesson 16), a custom `TaskNotFoundError < StandardError` (Lesson 09), `attr_reader`/`alias_method` for a predicate-style `done?` reader (Lessons 11, 19), `require_relative` wiring together multiple files (Lesson 15), and a Minitest suite run against a fresh in-memory database per test (Lesson 18).

### Structure

```
TaskTracker/
  cli.rb                          -- the command-line entry point
  lib/
    task.rb                       -- plain Task value object
    task_not_found_error.rb        -- custom StandardError subclass
    task_repository.rb             -- all SQLite access, parameterized queries only
  test/
    task_repository_test.rb        -- 10 Minitest tests, in-memory DB, full isolation
```

### Commands

```bash
cd 01-Languages/Ruby/22-Mini-Projects/TaskTracker
ruby cli.rb add "Buy milk"
ruby cli.rb list
ruby cli.rb done 2
ruby cli.rb delete 3
ruby cli.rb stats
```

### Real, Captured CLI Walkthrough

```
--- add ---
Added: [ ] #1 Buy milk
Added: [ ] #2 Write Ruby course
Added: [ ] #3 Walk the dog
--- list ---
[ ] #1 Buy milk
[ ] #2 Write Ruby course
[ ] #3 Walk the dog
--- done 2 ---
Completed: [x] #2 Write Ruby course
--- list after done ---
[ ] #1 Buy milk
[x] #2 Write Ruby course
[ ] #3 Walk the dog
--- stats ---
Total: 3  Done: 1  Pending: 2
--- delete 3 ---
Deleted task #3
--- list after delete ---
[ ] #1 Buy milk
[x] #2 Write Ruby course
--- done on missing id ---
Error: no task found with id 999
--- add empty title ---
Error: title must not be empty
--- stats final ---
Total: 2  Done: 1  Pending: 1
```

Every line above came from actually running `ruby cli.rb <command>` against a real, temporary `tasks.db` SQLite file created in this folder — including the two deliberate error cases (a missing task id passed to `done`, and an empty task title passed to `add`), both correctly caught and reported via the custom `TaskNotFoundError`/`ArgumentError` rather than crashing with a raw stack trace. The temporary `tasks.db` was deleted after this walkthrough — running `ruby cli.rb add ...` again starts from a fresh, empty database (the app creates the table via `CREATE TABLE IF NOT EXISTS` on first run).

### Real, Captured Test Run

```bash
ruby test/task_repository_test.rb
```

```
Run options: --seed 56386

# Running:

..........

Finished in 0.172587s, 57.9416 runs/s, 98.5008 assertions/s.

10 runs, 17 assertions, 0 failures, 0 errors, 0 skips
```

10/10 tests pass, each run against a fresh `:memory:` SQLite database (via `setup`/`teardown`), covering: adding a task (and rejecting an empty/whitespace-only title), listing in insertion order, finding a task (and raising `TaskNotFoundError` for a missing id), completing a task (and raising for a missing id), deleting a task (and raising for a missing id), and `stats` reporting correct total/done/pending counts.

## Design Notes

- **`sqlite3` over `Marshal`/flat files** — a real relational store makes `stats` (aggregate counts) and future filtering trivial, and directly reuses Lesson 16's parameterized-query discipline (every single query in `TaskRepository` uses a `?` placeholder for any value that isn't a hardcoded literal).
- **`TaskRepository#find` is called internally by `complete`/`delete`** before attempting the actual mutation, so a missing id fails fast with a clear `TaskNotFoundError` rather than silently updating/deleting zero rows.
- **The CLI layer (`cli.rb`) contains zero SQL** — it only calls `TaskRepository`'s public methods and handles the two expected error types (`TaskNotFoundError`, `ArgumentError`) with a friendly message instead of a raw backtrace, while any genuinely unexpected error still surfaces normally (deliberately not blanket-rescued).
- **In-memory SQLite (`:memory:`) for tests** gives each test full isolation with zero temp-file cleanup needed, while the real CLI use a genuine on-disk file (`tasks.db`, deleted after this README's own verification walkthrough).

## Recommended Next Step

This is the last section of the course — see the [course README](../README.md) for the suggested overall path, or revisit any lesson via the [CHEAT-SHEET](../CHEAT-SHEET.md).
