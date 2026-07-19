# 22 — Mini-Projects

[Back to course overview](../README.md) | [Previous: Solutions](../21-Solutions/README.md)

## CLI Task Tracker

A complete, working command-line task tracker persisting to a real SQLite database via raw JDBC, tested with a real MUnit suite. This mini-project combines nearly every prior lesson: `case class` (11), `Option` (09), pattern matching (05/09), `PreparedStatement`-based JDBC persistence (16), and MUnit testing via a standalone runner (18).

See [CLI-Task-Tracker/](CLI-Task-Tracker/) for all source files.

### Architecture

- **[Task.scala](CLI-Task-Tracker/Task.scala)** — the immutable `case class Task(id: Int, description: String, done: Boolean)` domain model.
- **[TaskRepository.scala](CLI-Task-Tracker/TaskRepository.scala)** — the persistence layer: `initSchema`, `add`, `list`, `complete`, `delete`, `findById`, all using `PreparedStatement` for any user-supplied data (never string concatenation), exactly as Lesson 16 demonstrates.
- **[Cli.scala](CLI-Task-Tracker/Cli.scala)** — the entry point. Each invocation opens `tasks.db`, runs exactly one command (`add`/`list`/`complete`/`delete`) from `args`, then exits — simulating a real CLI tool used across separate terminal invocations, with `tasks.db` on disk persisting state between them.
- **[TaskRepositorySuite.scala](CLI-Task-Tracker/TaskRepositorySuite.scala)** — a real MUnit suite (7 tests) exercising the repository against a fresh in-memory SQLite database per test, including a dedicated SQL-injection-safety test.
- **[RunTests.scala](CLI-Task-Tracker/RunTests.scala)** — the same standalone MUnit runner approach as Lesson 18, since this course has no sbt project.

### Requirements

- `sqlite-jdbc` and `slf4j-api` (Lesson 16) on the classpath for both the CLI and the tests.
- MUnit and its transitive dependencies (Lesson 18) on the classpath for the tests only.

Fetch both via Coursier:

```bash
cs fetch org.xerial:sqlite-jdbc:3.45.1.0
cs fetch org.scalameta:munit_3:1.0.0
```

### Build

```bash
cd 01-Languages/Scala/22-Mini-Projects/CLI-Task-Tracker

# Compile the app + tests together against every dependency's classpath:
scalac -classpath "<sqlite-jdbc-jar>;<slf4j-api-jar>;<munit-jars...>" \
  Task.scala TaskRepository.scala Cli.scala TaskRepositorySuite.scala RunTests.scala
```

### Run the CLI — a Full Walkthrough

Each command is a separate invocation (as a real CLI tool would be used), with `tasks.db` persisting state on disk between them:

```bash
java -cp ".;<sqlite-jdbc-jar>;<slf4j-api-jar>;<scala3-library_3-jar>;<scala-library-2.13-jar>" taskTrackerCli add Buy groceries
java -cp "..." taskTrackerCli add Write Scala mini-project
java -cp "..." taskTrackerCli add Review pull request
java -cp "..." taskTrackerCli list
java -cp "..." taskTrackerCli complete 2
java -cp "..." taskTrackerCli list
java -cp "..." taskTrackerCli delete 1
java -cp "..." taskTrackerCli list
java -cp "..." taskTrackerCli complete 999
```

### Actual Captured Output From the Walkthrough Above

```
added task #1: Buy groceries
added task #2: Write Scala mini-project
added task #3: Review pull request

[ ] #1 Buy groceries
[ ] #2 Write Scala mini-project
[ ] #3 Review pull request

completed task #2

[ ] #1 Buy groceries
[x] #2 Write Scala mini-project
[ ] #3 Review pull request

deleted task #1

[x] #2 Write Scala mini-project
[ ] #3 Review pull request

no task with id 999
```

(An SLF4J "no-operation logger" notice and a JVM native-access warning print to stderr on first driver load — harmless, same as Lesson 16.)

### Run the Tests

```bash
java -cp ".;<sqlite-jdbc-jar>;<slf4j-api-jar>;<munit-jars...>;<scala3-library_3-jar>;<scala-library-2.13-jar>" runTaskTrackerTests
```

### Actual Captured Test Output

```
PASS  add then list returns the added task
PASS  complete marks a task done
PASS  complete on a nonexistent id returns false
PASS  delete removes a task
PASS  delete on a nonexistent id returns false
PASS  multiple tasks preserve insertion order
PASS  a task description containing SQL-injection-shaped text is stored safely, not executed

7 tests run, 7 passed, 0 failed
```

### Design Notes

- **Persistence choice**: the CLI uses a file-backed SQLite database (`tasks.db`) so state survives across separate process invocations, matching how a real CLI tool is actually used (one command per terminal invocation); the test suite instead uses `jdbc:sqlite::memory:` for a fresh, isolated database per test, avoiding any test depending on another test's leftover state.
- **SQL-injection safety**: every method taking user-supplied data (`add`'s `description`, `complete`/`delete`/`findById`'s `id`) uses `PreparedStatement` parameter binding, never string concatenation — verified directly by a dedicated test that stores a description shaped like a SQL-injection payload and confirms it round-trips as inert data with the table fully intact.
- **Immutability**: `Task` is an immutable `case class`; the repository never mutates a `Task` in place, instead returning fresh `Task` values (via `list`/`findById`) that reflect the database's current state at query time — no cached, potentially-stale mutable state.
- **Error handling**: `complete`/`delete` on a nonexistent id return `false` (via checking `executeUpdate()`'s affected-row count) rather than throwing, and the CLI reports this to the user as an ordinary outcome, not a crash — consistent with Lesson 09's "expected failure should be an ordinary value" philosophy.

## Recommended Next

This is the final lesson of the Scala course. Return to the [course overview](../README.md) for the full table of contents, or revisit [20-Exercises](../20-Exercises/README.md) for further practice.
