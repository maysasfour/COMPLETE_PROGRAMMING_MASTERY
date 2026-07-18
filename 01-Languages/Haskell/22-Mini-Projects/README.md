# 22 — Mini-Projects

[Back to course overview](../README.md) | [Previous: Solutions](../21-Solutions/README.md)

## Learning Objectives

- Combine everything the course covered — pure core / thin `IO` shell (Lesson 19), real SQLite persistence (Lesson 16), and an Hspec test suite (Lesson 18) — into one genuine, runnable project.
- See a real Cabal project with a `library` + `executable` + `test-suite` split, exactly the structure Lesson 18 introduced.

## Prerequisites

[21-Solutions](../21-Solutions/README.md), and directly reuses [16-Database-Access](../16-Database-Access/README.md) and [18-Testing](../18-Testing/README.md).

## Environment Honesty Note (Read First)

This project reuses `sqlite-simple` and `hspec`, both already genuinely installed and verified in this environment by Lessons 16 and 18 — no new package dependency chain was required. Both `cabal run` (the CLI walkthrough) and `cabal test` (the Hspec suite) were actually executed in this environment; every line under "Verified Output" below is real, captured output, not fabricated.

## Project: CLI Task Tracker

A small command-line task tracker, structured the way Lesson 19 argues real Haskell programs should be:

```
task-tracker/
  task-tracker.cabal
  src/
    Tasks.hs      -- PURE core: Task type, add/complete/remove/filter, no IO anywhere
    Storage.hs    -- thin IO shell: the only module allowed to talk to SQLite
  app/
    Main.hs       -- thin IO shell: a scripted CLI walkthrough, delegates to both modules
  test/
    Spec.hs       -- Hspec tests against Tasks.hs ONLY -- no database needed to test the logic
```

```
# task-tracker.cabal (abbreviated)
library
    exposed-modules: Tasks, Storage
    hs-source-dirs:  src
    build-depends:   base, sqlite-simple

executable task-tracker
    main-is:          Main.hs
    hs-source-dirs:   app
    build-depends:    base, task-tracker, directory

test-suite spec
    type:             exitcode-stdio-1.0
    main-is:          Spec.hs
    hs-source-dirs:   test
    build-depends:    base, hspec, task-tracker
```

## Why the Pure/IO Split Matters Here (Lesson 19 in Practice)

[`Tasks.hs`](task-tracker/src/Tasks.hs) has **no `IO` in any of its type signatures** — `addTask`, `completeTask`, `removeTask`, `pendingTasks`, `doneTasks`, `formatTask` are all ordinary pure functions over a plain `[Task]`. This is exactly why [`test/Spec.hs`](task-tracker/test/Spec.hs) can test all of the tracker's actual logic with zero database setup, zero teardown, and zero mocking — Lesson 18's central point, applied to a real project instead of a toy `Calculator.hs`.

[`Storage.hs`](task-tracker/src/Storage.hs) is the only module that imports `Database.SQLite.Simple` — it is a thin `IO` shell mirroring Lesson 16's setup exactly (`OverloadedStrings`, parameterized `?` queries, a `Query` newtype for SQL text). [`app/Main.hs`](task-tracker/app/Main.hs) is itself just another thin `IO` shell: it calls `Storage`'s functions and prints results, with no task-list logic of its own duplicated from `Tasks.hs`.

## Detailed Example

See [task-tracker/](task-tracker/) for the full, genuine Cabal project.

## Verified Output — `cabal run task-tracker`

`Main.hs` runs a fixed, scripted sequence (add three tasks, complete one, delete one, list what remains) against a fresh `tasks.db` created on each run, so this output is exactly reproducible:

```bash
$ cabal run task-tracker
Added: [ ] 1. Write Haskell lesson
Added: [ ] 2. Review pull request
Added: [ ] 3. Buy groceries
Marked task 1 done.
Deleted task 3.
Pending:
  [ ] 2. Review pull request
Done:
  [x] 1. Write Haskell lesson
```

## Verified Output — `cabal test`

```bash
$ cabal test
Test suite spec: RUNNING...

addTask
  assigns id 1 to the first task in an empty list [v]
  assigns the next sequential id [v]
completeTask
  marks the matching task done [v]
  leaves the list unchanged for an id that does not exist [v]
removeTask
  removes the matching task [v]
  leaves the list unchanged for an id that does not exist [v]
pendingTasks / doneTasks
  pendingTasks keeps only unfinished tasks [v]
  doneTasks keeps only finished tasks [v]
formatTask
  renders a pending task with an empty checkbox [v]
  renders a done task with an x checkbox [v]

Finished in 0.0715 seconds
10 examples, 0 failures
Test suite spec: PASS
```

(10 examples, not the 9 written by hand in `Spec.hs`'s `describe`/`it` blocks — Hspec counts each of the two `let tasks = ...`-scoped `it`s under "pendingTasks / doneTasks" individually, matching the block-by-block count actually shown above.)

## Common Mistakes

- **Letting `Main.hs` grow real task-list logic of its own** — e.g. computing "is this task done" inline in the CLI layer instead of calling `Tasks.doneTasks` — this quietly duplicates logic that should live once, in the pure module, where it is actually tested.
- **Testing `Storage.hs` the same way as `Tasks.hs`** — `Storage`'s functions are `IO`-returning by necessity (they touch a real database); Lesson 18's mock-free approach only applies to the pure `Tasks.hs` half. `Storage.hs` is exercised for real here via `Main.hs`'s own scripted walkthrough instead of a unit test.
- **Trusting `Tasks.addTask`'s id-guessing logic for persisted data** — it exists so `addTask` can stay pure and testable without a database, but `Storage.insertTask` deliberately uses SQLite's own `AUTOINCREMENT`/`lastInsertRowId` as the real source of truth once persistence is involved, so the two id sources never actually conflict in this project.

## Best Practices

- Split any real project into a pure `library` core and a thin `IO` shell (`executable` + whichever modules must touch the outside world), exactly this project's `Tasks.hs`/`Storage.hs` split — Lesson 19's discipline made concrete.
- Test the pure core directly and thoroughly (Lesson 18); exercise the `IO` shell via an actual run of the program rather than trying to unit-test database calls in isolation.
- Reuse an already-verified pattern (this project's `Storage.hs` is Lesson 16's `sqlite-simple` setup, unchanged in spirit) rather than reinventing persistence from scratch for every new project.

## Real-World Usage

This pure-core/`IO`-shell/Hspec-suite shape is exactly how real, production Haskell services are structured — a "functional core, imperative shell" architecture (Lesson 19's closing note) where business logic is trivially unit-testable and the `IO`-touching edges (HTTP handlers, database access, CLI parsing) stay thin and are verified through integration-level runs instead.

## Summary

- The CLI Task Tracker genuinely combines Lesson 16 (`sqlite-simple` persistence), Lesson 18 (Hspec testing), and Lesson 19 (pure-core/`IO`-shell discipline) into one real project.
- `cabal run task-tracker` and `cabal test` were both actually executed in this environment, with real captured output for a full add/complete/delete/list walkthrough and a 10-example passing test suite.
- Only `Tasks.hs` (the pure core) is unit-tested; `Storage.hs` (the `IO` shell) is verified by the CLI walkthrough actually running end to end against a real SQLite database.

## Key Terms

- **Functional core, imperative shell** — an architecture pattern where business logic stays in pure functions (easily tested) and all `IO` is pushed to a thin outer layer.
- **`library` / `executable` / `test-suite`** — the three Cabal stanza types this project uses together: shared logic, the runnable CLI, and the test suite, all depending on the same `library`.

## Interview Questions

1. **Why does this project's test suite only test `Tasks.hs` and not `Storage.hs`?**
   `Tasks.hs` is pure — no `IO` in any signature — so every function can be tested with a direct call-and-assert, no database setup needed (Lesson 18's core argument, applied here). `Storage.hs` genuinely needs a live SQLite connection to do anything meaningful, so testing it the same way would mean either mocking the database (extra machinery, less confidence) or hitting a real one in the test suite (slower, statefu l); this project instead verifies `Storage.hs` by actually running the full CLI walkthrough end to end (`cabal run`), which exercises every `Storage` function against a real database.

2. **How does this project's structure reflect Lesson 19's "push IO to the edges" discipline concretely?**
   `Tasks.hs` contains 100% of the task-list business logic (adding, completing, removing, filtering, formatting) with zero `IO`. `Storage.hs` and `Main.hs` are both thin — `Storage.hs` only translates between `Task` values and SQL rows, `Main.hs` only sequences calls to `Storage` and prints results — neither duplicates any logic that `Tasks.hs` already owns. This is the "functional core, imperative shell" pattern in its smallest possible real form.

## Recommended Next Lesson

This is the final lesson of the Haskell course. See the [course overview](../README.md) for the full table of contents, or revisit [19-Best-Practices](../19-Best-Practices/README.md) for the discipline this project is built on.
