# 22 — Mini-Projects

[Back to course overview](../README.md) | [Previous: Solutions](../21-Solutions/README.md)

> ## Genuinely Compiled, Run, and Tested
>
> Like [21-Solutions](../21-Solutions/README.md), this mini-project **was actually built, run, and tested** against a real Swift 6.1.2 toolchain (`x86_64-unknown-windows-msvc`) — see that folder's "How This Was Verified" section for the full `vcvarsall.bat`/`swiftc` setup story, and this file's own "Bugs Found and Fixed" section below for issues specific to this project.

## The Project: CLI Task Tracker

A single, complete mini-project — a command-line task tracker backed by SQLite — living in [TaskTracker/](TaskTracker/), a real Swift Package Manager package. This mirrors the same mini-project already built for this repository's Python, JavaScript, TypeScript, C#, and Java courses (see `BUILD_STATUS.md`), adapted to Swift's own conventions:

- **Model** (`Sources/TaskTrackerCore/Task.swift`): a `TaskItem` struct (value type, Lesson 11) plus a `Priority` enum (`low`/`medium`/`high`) instead of a free-text priority string — an invalid priority is a compile-time impossibility for any Swift code, not just a runtime validation rule.
- **Persistence** (`Sources/TaskTrackerCore/TaskRepository.swift`): reuses [Lesson 16](../16-Database-Access/README.md)'s exact raw-SQLite3-C-API approach (`OpaquePointer`, `sqlite3_prepare_v2`/`sqlite3_bind_*` parameterized queries, explicit `sqlite3_finalize`), since Swift still has no built-in database access at all.
- **Errors** (`Sources/TaskTrackerCore/TaskTrackerError.swift`): a custom `TaskTrackerError.taskNotFound(Int)`, thrown (not silently ignored) when marking-done/deleting a nonexistent task id.
- **CLI** (`Sources/TaskTracker/main.swift`): hand-rolled `CommandLine.arguments` parsing (`add`/`list`/`done`/`delete`/`stats`), no third-party argument-parsing package.
- **Tests** (`Tests/TaskTrackerCoreTests/TaskTrackerCoreTests.swift`): a 10-test `XCTest` suite (Lesson 18's approach), run against a fresh `:memory:` SQLite database per test via `setUp()`.

Module layout follows [Lesson 15](../15-Modules-and-Packages/README.md)'s conventions: a real `Package.swift` manifest, library code under `Sources/<Target>/`, tests under `Tests/<Target>Tests/`, and `public`/`private` access control used deliberately (`TaskRepository`'s `db` handle is `private`; everything a CLI/test consumer needs is `public`).

## Why This Needed an Adaptation From Lesson 16, Not a Straight Reuse

Lesson 16's `import SQLite3` works as-is on Linux/macOS because Swift's toolchain there bundles a system module map pointing directly at the OS's own `libsqlite3`. **The Windows Swift 6.1.2 toolchain used to verify this course does not bundle that module** — confirmed by searching the entire toolchain install directory for any `sqlite3`-named file and finding none. Rather than silently reuse Lesson 16's `import SQLite3` and have it fail to compile, this mini-project:

1. Downloads the public-domain SQLite "amalgamation" (`sqlite3.c` + `sqlite3.h` — a single-file build of the entire SQLite library, no separate build system) via [`fetch-sqlite3.sh`](TaskTracker/fetch-sqlite3.sh), the same on-demand-download-not-committed pattern this repository's Java course already uses for its JDBC driver JAR (see `.gitignore` — `sqlite3.c`/`sqlite3.h` are excluded there, matching `*.jar`/`vendor/`/`node_modules/` treatment for other courses' external dependencies).
2. Compiles it as a plain SwiftPM C target (`CSQLite3` in [Package.swift](TaskTracker/Package.swift)) — `swift build` invokes the C compiler on `sqlite3.c` itself, no manual `cl.exe`/`lib.exe` step required once `vcvarsall.bat x64` has been run in the same shell.
3. `import CSQLite3` (not `import SQLite3`) from `TaskTrackerCore`, calling the identical C API (`sqlite3_open`, `sqlite3_prepare_v2`, `sqlite3_bind_text`, `sqlite3_step`, `sqlite3_finalize`, ...) Lesson 16 documents — only the import name changed, not the API surface or the parameterized-query safety pattern.

This is a genuine, disclosed deviation from "reuse Lesson 16's exact approach" at the import-statement level, made necessary by a real platform difference discovered while building this project, not an arbitrary choice.

## How to Build and Run

```bash
cd 01-Languages/Swift/22-Mini-Projects/TaskTracker

# 1. Fetch the SQLite amalgamation source (not committed -- see .gitignore)
bash fetch-sqlite3.sh

# 2. Initialize the Visual Studio C/C++ build environment (Windows-specific -- see
#    21-Solutions/README.md's "How This Was Verified" for why this is needed at all),
#    then build
call "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
swift build

# 3. Run the CLI (TASKTRACKER_DB defaults to ./tasks.db if unset)
.build\x86_64-unknown-windows-msvc\debug\TaskTracker.exe add "Write report" --priority high
.build\x86_64-unknown-windows-msvc\debug\TaskTracker.exe list

# 4. Run the test suite
swift test
```

On macOS/Linux, the real system `libsqlite3` could be used instead of vendoring the amalgamation (closer to Lesson 16's original intent) -- adapt `Package.swift`'s `CSQLite3` target to a `.systemLibrary` target with a `module.modulemap` pointing at the system header/library, and skip `fetch-sqlite3.sh` entirely. This was not tested on those platforms in this session (no macOS/Linux machine was available), and is worth confirming there before fully trusting it, similar in spirit to `05-Mobile-Development`'s Android-only-not-iOS disclosure.

## Real CLI Walkthrough (Actual Captured Output)

Every command below was actually run against the built `TaskTracker.exe`, in order, against a fresh database file (deleted before this walkthrough started):

```
=== add ===
Added task #1: Write the mini-project README [high]
Added task #2: Buy groceries [low]
Added task #3: Review pull request [medium]

=== list (before) ===
[ ] #1 !!! Write the mini-project README
[ ] #2 !   Buy groceries
[ ] #3 !!  Review pull request

=== done 1 ===
Marked task #1 done.

=== list (after done) ===
[x] #1 !!! Write the mini-project README
[ ] #2 !   Buy groceries
[ ] #3 !!  Review pull request

=== stats ===
Total: 3  Done: 1  Pending: 2

=== delete 2 ===
Deleted task #2.

=== list (after delete) ===
[x] #1 !!! Write the mini-project README
[ ] #3 !!  Review pull request

=== done on missing id (expect error) ===
Error: No task with id 999 exists.

=== delete on missing id (expect error) ===
Error: No task with id 999 exists.

=== no args (expect usage) ===
Task Tracker -- a tiny CLI backed by SQLite (Lesson 16's raw C API approach)

Usage:
  tasktracker add <title> [--priority low|medium|high]
  tasktracker list
  tasktracker done <id>
  tasktracker delete <id>
  tasktracker stats

=== stats (final) ===
Total: 2  Done: 1  Pending: 1
```

The task-id numbering, done/pending counts, and error messages above are exactly what a fresh run produces -- not hand-computed or predicted.

## Real Test Suite Output (Actual Captured Output)

```
Test Suite 'All tests' started at 2026-07-18 18:44:01.692
Test Suite 'TaskTrackerCoreTests' started at 2026-07-18 18:44:01.781
Test Case 'TaskTrackerCoreTests.testAddTaskDefaultsToMediumPriority' passed (0.016 seconds)
Test Case 'TaskTrackerCoreTests.testAddTaskReturnsAssignedId' passed (0.001 seconds)
Test Case 'TaskTrackerCoreTests.testAllTasksIsEmptyForFreshDatabase' passed (0.001 seconds)
Test Case 'TaskTrackerCoreTests.testAllTasksReturnsInInsertionOrder' passed (0.001 seconds)
Test Case 'TaskTrackerCoreTests.testDeleteOnMissingIdThrows' passed (0.001 seconds)
Test Case 'TaskTrackerCoreTests.testDeleteRemovesTask' passed (0.001 seconds)
Test Case 'TaskTrackerCoreTests.testEachRepositoryInstanceIsIsolated' passed (0.001 seconds)
Test Case 'TaskTrackerCoreTests.testMarkDoneOnMissingIdThrows' passed (0.001 seconds)
Test Case 'TaskTrackerCoreTests.testMarkDoneUpdatesExistingTask' passed (0.001 seconds)
Test Case 'TaskTrackerCoreTests.testStatsCountsTotalDoneAndPending' passed (0.386 seconds)
Test Suite 'TaskTrackerCoreTests' passed at 2026-07-18 18:44:02.190
	 Executed 10 tests, with 0 failures (0 unexpected) in 0.408 (0.408) seconds
```

All 10 tests passed on the first fully-corrected run (see "Bugs Found and Fixed" below for what needed correcting along the way).

## Bugs Found and Fixed

Building this mini-project surfaced two genuine, real issues — neither smoothed over:

1. **No bundled `SQLite3` module on Windows.** Confirmed by recursively searching the entire Swift toolchain installation directory for any file with "sqlite3" in its name and finding zero matches — unlike Lesson 16's assumption (accurate for Linux/macOS, where this course's honesty notice already flags the whole course as unverified). Fixed by vendoring the SQLite amalgamation source as a SwiftPM C target instead of a system library — see "Why This Needed an Adaptation" above.

2. **`SQLITE_TRANSIENT` is not importable as a Swift constant on this toolchain.** Lesson 16's `Example.swift` binds strings with `sqlite3_bind_text(stmt, 1, title, -1, nil)` — passing `nil` (equivalent to `SQLITE_STATIC`) as the destructor, which tells SQLite the bound pointer stays valid at least until the statement is stepped/reset, with no internal copy made. A throwaway test in this session confirmed passing `nil` *happens* to work correctly here (Swift's temporary C-string bridge for a `String` argument apparently outlives the call in this toolchain's implementation), but that's an implementation detail, not a documented guarantee — genuinely different from the safe, well-defined `SQLITE_TRANSIENT` alternative (which tells SQLite to copy the string data immediately). Attempting to reference `SQLITE_TRANSIENT` directly failed to compile outright:
   ```
   error: cannot find 'SQLITE_TRANSIENT' in scope
   ```
   unlike Apple platforms, where Clang's importer specially recognizes this exact `(sqlite3_destructor_type)-1` macro pattern and exposes it as a usable constant. Fixed in [`TaskRepository.swift`](TaskTracker/Sources/TaskTrackerCore/TaskRepository.swift) by manually reconstructing it: `unsafeBitCast(-1, to: sqlite3_destructor_type.self)` — verified, by rebuilding and rerunning both the CLI walkthrough and the full test suite afterward, to behave identically to the (already-working) `nil` version while resting on defined behavior instead of an unconfirmed assumption about bridging lifetimes.

## Cleanup

All build artifacts (`.build/`, `*.exe`, `*.obj`, `*.pdb`, `*.ilk`, `*.lib`, `*.exp`, `*.db`, `walkthrough.db`, `tasks.db`) were removed from this folder after verification, and are excluded from version control via the repository root `.gitignore` (`.build/`, `*.exe`, `*.obj`, `*.pdb`, `*.ilk`, `*.db`, `*.sqlite`, plus this project's own vendored `sqlite3.c`/`sqlite3.h`, which `fetch-sqlite3.sh` regenerates on demand).

## Suggested Next Lesson

This is the final folder in the Swift course. Return to the [course overview](../README.md) for the full lesson index, or revisit [20-Exercises](../20-Exercises/README.md)/[21-Solutions](../21-Solutions/README.md).
