# 22 - Mini-Projects

## What This Is

A CLI Task Tracker — a small but complete Lua program spanning most of the course: tables
as the task data structure (Lesson 07), string formatting (Lesson 08), file I/O (Lesson 10),
modules (Lesson 15), and a hand-rolled test harness (Lesson 18). Four files:

| File | Role |
|---|---|
| `tracker.lua` | The CLI entry point — parses `arg`, dispatches to `add`/`list`/`done`/`remove` |
| `storage.lua` | Persistence module — a hand-rolled Lua-table serializer + `io.open`/`loadfile` |
| `testkit.lua` | The same minimal `pcall`-based test harness from Lesson 18, copied in so tests need no external dependency |
| `tracker_test.lua` | Tests for `storage.lua`'s save/load round-trip behavior |

## Why File-Based Storage, Not SQLite

Lesson 16 documents why a real SQLite binding (`LuaSQL`) wasn't confirmed genuinely
installable in this environment (no verified native-compile toolchain). Rather than fabricate
a database layer never actually run, this project persists tasks with `storage.lua`: it
serializes the task list as literal, valid Lua source (`return { {id = 1, title = "...", done
= false}, ... }`) to `tasks_data.lua`, then reads it back on the next run via `loadfile()` —
compiling the saved file as a Lua chunk and calling it, since the file's own content evaluates
to the table. This is a genuinely idiomatic Lua technique (not a workaround), used because Lua
has no built-in serialization format of its own.

## Requirements

- Add a task with a title (`add`).
- List all tasks with a `[ ]`/`[x]` done marker and numeric id (`list`).
- Mark a task done by id (`done`).
- Remove a task by id (`remove`).
- Persist tasks between runs in `tasks_data.lua` (created next to wherever `tracker.lua` is run from).
- Ids are assigned sequentially based on the current max id (so they stay unique even after removals leave gaps).
- Missing/invalid arguments (no title, non-numeric id, unknown id) print a clear error and don't crash or corrupt the saved file.

## How to Run

```bash
export PATH="/c/Users/HP/Complete-Programming-Mastery/tools/lua:$PATH"
cd 01-Languages/Lua/22-Mini-Projects

lua tracker.lua add "Buy milk"
lua tracker.lua list
lua tracker.lua done 2
lua tracker.lua remove 1
```

## Real Captured Walkthrough

```
$ lua tracker.lua add "Buy milk"
added task #1: Buy milk
$ lua tracker.lua add "Write Lua course"
added task #2: Write Lua course
$ lua tracker.lua add "Ship it"
added task #3: Ship it

$ lua tracker.lua list
[ ] #1 Buy milk
[ ] #2 Write Lua course
[ ] #3 Ship it

$ lua tracker.lua done 2
marked #2 done
$ lua tracker.lua list
[ ] #1 Buy milk
[x] #2 Write Lua course
[ ] #3 Ship it

$ lua tracker.lua remove 1
removed #1
$ lua tracker.lua list
[x] #2 Write Lua course
[ ] #3 Ship it
```

### Error Handling, Verified Live

```
$ lua tracker.lua add
error: 'add' requires a task title
$ lua tracker.lua done abc
error: 'done' requires a numeric task id
$ lua tracker.lua done 999
error: no task with id 999
$ lua tracker.lua remove 999
error: no task with id 999
$ lua tracker.lua
usage: lua tracker.lua <add|list|done|remove> [args]
```

None of these error paths write to `tasks_data.lua` — the file is only saved when a command
actually changes the task list (`changed == true`), verified above: `tasks_data.lua` after the
successful run above contains exactly the two remaining tasks:

```lua
return {
  {id = 2, title = "Write Lua course", done = true},
  {id = 3, title = "Ship it", done = false},
}
```

## Test Suite

```bash
lua tracker_test.lua; echo "exit code: $?"
```

Real captured output:

```
7 passed, 0 failed
exit code: 0
```

Covers: loading a nonexistent storage file returns an empty list (not an error); `save()` then
`load()` round-trips task data correctly (count, title, boolean field); a title containing
quotes and a tab character survives a save+load round trip intact (proving `%q`-based
serialization escapes correctly, not just plain concatenation); and next-id assignment
correctly skips past a non-contiguous existing id (e.g. ids `{1, 5}` produce next id `6`, not `2`).

## Common Beginner Mistakes

- Assuming `tasks_data.lua` is a data format (JSON/CSV-like) — it's literally executable Lua
  source; hand-editing it incorrectly (e.g. leaving off a closing `}`) makes `loadfile` fail,
  handled gracefully here by falling back to an empty task list rather than crashing.
- Forgetting that `next_id` must scan for the current *max* id, not just use `#tasks + 1` —
  after a removal, `#tasks + 1` can collide with an id still in use (e.g. removing id 1 from
  `{1,2,3}` leaves `{2,3}`, where `#tasks + 1` is 3, already taken).

## Best Practices Demonstrated

- Only write to disk when something actually changed (`changed` flag in `tracker.lua`'s
  `main`), avoiding an unnecessary save (and unnecessary disk I/O) on every `list` call.
- Validate and convert user input (`tonumber(id_str)`) before using it, printing a specific
  error message rather than letting a `nil` propagate into a comparison and fail obscurely.
- Keep the test harness (`testkit.lua`) dependency-free and copied locally, consistent with
  Lesson 18's guidance for small/embedded Lua projects.

## Interview Questions

1. **Why does this project serialize tasks as executable Lua source instead of a plain data
   format like JSON?** Lua ships no built-in JSON/serialization library (Lesson 10), and no
   verified-working third-party JSON or SQLite binding was available in this environment
   (Lesson 16). Writing valid Lua table syntax to disk and reading it back via `loadfile()` is
   a genuinely idiomatic Lua technique that needs nothing beyond the base language.
2. **How does `next_id` avoid assigning a duplicate id after tasks have been removed?** It
   scans all existing tasks for the current maximum id and returns `max + 1`, rather than using
   `#tasks + 1` — the latter would collide with a still-in-use id whenever a removal leaves a
   non-contiguous set of ids (e.g. `{2, 3}` after removing id 1 from `{1, 2, 3}`).
