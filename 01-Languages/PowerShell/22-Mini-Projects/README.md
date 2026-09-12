# 22 - Mini-Projects

[Back to course overview](../README.md) | [Previous: Solutions](../21-Solutions/README.md)

## TaskTracker - a Real CLI Task Tracker

A small, complete, module-backed CLI task tracker - the capstone project pulling together
functions, error handling, classes-of-thinking-in-terms-of-records via `[PSCustomObject]`,
JSON persistence, and Pester testing from across the whole course.

- [TaskTracker.psm1](TaskTracker/TaskTracker.psm1) - the module: `Get-TaskStorePath`,
  `Initialize-TaskStore`, `Get-TaskList`, `Save-TaskList`, `Add-Task`, `Get-Task`,
  `Complete-Task`, `Remove-Task`.
- [tracker.ps1](TaskTracker/tracker.ps1) - the CLI entry point (`add`/`list`/`complete`/`remove`).
- [TaskTracker.Tests.ps1](TaskTracker/TaskTracker.Tests.ps1) - the Pester test suite.

## Why File-Based JSON, Not SQLite

[16-Database-Access](../16-Database-Access/README.md) already found, honestly, that no
SQLite engine (no `System.Data.SQLite`, no `PSSQLite` module) is genuinely available in this
environment. This project persists tasks as JSON instead
(`ConvertTo-Json`/`ConvertFrom-Json`, per [10-Files-and-IO](../10-Files-and-IO/README.md)),
the same honest deviation already used by the JSON round-trip in
[21-Solutions](../21-Solutions/README.md).

## Requirements

- A `Task` has `Id` (auto-incrementing integer), `Title` (string), `Done` (bool), and
  `Created` (ISO-8601 timestamp string).
- `add <title>` creates a new task and prints its assigned Id.
- `list` prints every task with an `[x]`/`[ ]` status marker.
- `complete <id>` marks a task done; throws a clear error for an unknown Id.
- `remove <id>` deletes a task; throws a clear error for an unknown Id.
- Storage must survive across separate process invocations (real persistence, not an
  in-memory list that resets every run).

## Two Real Gotchas Found and Fixed While Building This

Both are documented directly in the module's own comments (`TaskTracker.psm1`), not hidden:

1. **The comma-operator array-unwrapping gotcha.** `Get-TaskList` reads the JSON store via
   `ConvertFrom-Json`. When the store holds exactly one task, `ConvertFrom-Json` returns a
   *single* `PSCustomObject`, not a 1-element array - and PowerShell's own output-stream
   auto-enumeration means even `return @($items)` still unwraps it back down to a bare
   object once it crosses the function boundary. The fix needs the comma operator
   (`return ,$arr`) specifically for the 1-element case - but applying the comma
   *unconditionally* was a second real bug caught while testing this fix: it wraps an
   already-correct multi-element array in an extra, spurious outer array. The final code
   branches explicitly on `$arr.Count -eq 1`.
2. **`[AllowEmptyCollection()]` for a `Mandatory` array parameter.** `Save-TaskList` takes a
   `Mandatory` `[array]$Tasks`. Removing the last remaining task legitimately needs to save
   an *empty* array - but PowerShell treats binding an empty collection to a `Mandatory`
   parameter as if nothing was supplied at all, throwing
   `ParameterBindingValidationException`. `[AllowEmptyCollection()]` is required to make
   that call succeed.

## How to Run

```powershell
cd 01-Languages\PowerShell\22-Mini-Projects\TaskTracker
powershell -File tracker.ps1 add "Buy milk"
powershell -File tracker.ps1 list
powershell -File tracker.ps1 complete 1
powershell -File tracker.ps1 remove 2
```

## Verified Live: Full CLI Walkthrough

Actually run end-to-end in this environment (Windows PowerShell 5.1,
`powershell -NoProfile -ExecutionPolicy Bypass -File tracker.ps1 ...`), against a fresh
task store (the default `$env:TEMP\ps-tasktracker\tasks.json`, deleted before this run and
cleaned up again afterward):

```
--- add 'Buy milk' ---
Added task #1: Buy milk
--- add 'Write PowerShell README' ---
Added task #2: Write PowerShell README
--- list ---
[ ] #1 Buy milk
[ ] #2 Write PowerShell README
--- complete 1 ---
Completed task #1: Buy milk
--- list after complete ---
[x] #1 Buy milk
[ ] #2 Write PowerShell README
--- remove 2 ---
Removed task #2
--- list after remove ---
[x] #1 Buy milk
--- complete 99 (error path) ---
No task with Id 99 found.
At ...\TaskTracker.psm1:97 char:24
+     if (-not $found) { throw "No task with Id $Id found." }
+                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : OperationStopped: (No task with Id 99 found.:String) [], RuntimeException
    + FullyQualifiedErrorId : No task with Id 99 found.
```

The `complete 99` invocation exits with a non-zero exit code (an uncaught `throw` in a
top-level script is a terminating error) - correct, expected CLI behavior for an invalid Id,
not a bug.

## Verified Live: Pester Test Suite

Pester **3.4.0** is genuinely installed in this environment (confirmed with
`Get-Module -ListAvailable Pester` before assuming it, rather than guessing) - the same
version already used by [18-Testing](../18-Testing/README.md), so the test file uses
Pester 3's legacy `Should Be`/`Should Throw` syntax throughout (not the `Should -Be` syntax
from Pester 5+, which would not parse the same way against this installed version). Each
test runs against an isolated `$env:TEMP\ps-tasktracker-tests\<new guid>.json` file
(`BeforeEach`/`AfterEach`), so tests never interfere with each other or with real state a
user may have built up via `tracker.ps1`.

```powershell
Invoke-Pester -Script '.\TaskTracker.Tests.ps1'
```

```
Describing TaskTracker
 [+] starts with an empty list 1.69s
 [+] adds a task and assigns Id 1 517ms
 [+] increments Id for successive tasks 154ms
 [+] marks a task complete 91ms
 [+] throws when completing a nonexistent task 175ms
 [+] removes a task 215ms
 [+] persists tasks across separate Get-TaskList calls (real file-based persistence) 134ms
Tests completed in 2.98s
Passed: 7 Failed: 0 Skipped: 0 Pending: 0 Inconclusive: 0
```

All 7 tests pass, including a genuine persistence check (task written by one `Add-Task`
call is read back by a separate `Get-TaskList` call against the same file path).

## Common Beginner Mistakes

- Forgetting `[AllowEmptyCollection()]` on a `Mandatory` array parameter, then being
  confused by a `ParameterBindingValidationException` when trying to save an empty list.
- Assuming `ConvertFrom-Json` always returns an array - it silently returns a bare object
  for a single-element JSON array, breaking `.Count`/foreach assumptions downstream.
- Wrapping an already-correctly-shaped array result in `@()` a second time at the call
  site "just to be safe," which actually re-nests it into a broken shape.

## Best Practices

- Keep the module (`TaskTracker.psm1`, pure logic + persistence) separate from the CLI
  entry point (`tracker.ps1`, argument parsing + user-facing output) - the module can be
  imported and tested (see the Pester suite) without going through the CLI at all.
- Test error paths explicitly (`Should Throw`), not just the happy path.
- Use isolated, per-test temp files for anything file-based, so tests are order-independent
  and never corrupt real user data.

## Recommended Next Lesson

This is the last lesson in the PowerShell course. See the
[course overview](../README.md) for a recap, or the
[Ruby mini-project](../../Ruby/22-Mini-Projects/README.md) /
[Perl mini-project](../../Perl/22-Mini-Projects/README.md) for how the same kind of CLI
task tracker looks in other languages covered by this repository.
