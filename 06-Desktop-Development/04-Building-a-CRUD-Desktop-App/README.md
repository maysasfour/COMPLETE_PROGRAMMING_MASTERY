# 04 — Building a CRUD Desktop App

[Back to module overview](../README.md) | [Previous: JavaFX Threading Rules](../03-JavaFX-Threading-Rules/README.md)

## Beginner: A Complete, Real, Working Task Manager

This lesson brings together everything from Lessons 01-03 — Stage/Scene/controls, property-based data binding, and safe UI updates — into a complete, working CRUD (Create, Read, Update, Delete) desktop application: a Task Manager with a real `TableView`, a real file-backed repository, and every operation verified against real, observed state.

## The Data Model: A Real JavaFX Bean

```java
public class Task {
    private final SimpleStringProperty name;
    private final SimpleBooleanProperty done;
    // getters, setters, and nameProperty()/doneProperty() accessors
}
```

Using `SimpleStringProperty`/`SimpleBooleanProperty` (not plain `String`/`boolean` fields) is what lets `TableColumn`'s `PropertyValueFactory` observe changes automatically — directly building on [Lesson 02](../02-Data-Binding-and-Observable-Collections/README.md)'s binding concepts.

## The Repository: Real File Persistence

```java
public class TaskRepository {
    public List<Task> load() throws IOException { /* reads "done|name" lines from a real file */ }
    public void save(List<Task> tasks) throws IOException { /* writes them back */ }
}
```

## CREATE, READ, UPDATE, DELETE — Each Verified Against Real State

Rather than requiring a human to click through the app to confirm it works, this lesson fires the exact same button actions a real user's clicks would trigger, and checks the actual resulting state after each one. Verified live:

```
=== CREATE ===
Tasks after adding 2: [[ ] Buy milk, [ ] Write JavaFX lesson]

=== READ ===
TableView's actual items: [[ ] Buy milk, [ ] Write JavaFX lesson]
Matches the underlying list: true

=== UPDATE ===
After toggling task 0's done status: [[x] Buy milk, [ ] Write JavaFX lesson]

=== DELETE ===
After deleting task 1: [[x] Buy milk]
```

Each operation used the real `Button`'s `fire()` method (genuinely invoking the same `setOnAction` handler a real click would) or the real `TableView` selection model — not a shortcut that bypasses the actual UI logic.

## The Real Test: A Full Persistence Round-Trip

The strongest possible proof that persistence actually works isn't just "the file was written" — it's loading the data back with a **completely separate, fresh repository instance** that shares no in-memory state with the original:

```java
repository.save(tasks);
TaskRepository freshRepository = new TaskRepository(dataFile); // a NEW instance
List<Task> reloaded = freshRepository.load();
```

Verified live, including the actual raw file contents:

```
Saved to real file: C:\Users\HP\AppData\Local\Temp\tasks12312908119955672020.txt
Raw file contents: true|Buy milk
Reloaded via a FRESH TaskRepository instance: [[x] Buy milk]
Persistence round-trip correct: true
```

The reloaded task correctly has both the right name **and** the right `done` status (`true`, from the earlier toggle) — genuinely read back from disk by an object with no memory of the original in-process list, proving real persistence rather than an in-memory illusion.

## Detailed Example

See [pom.xml](pom.xml), [Task.java](src/main/java/com/example/crudapp/Task.java), [TaskRepository.java](src/main/java/com/example/crudapp/TaskRepository.java), and [Main.java](src/main/java/com/example/crudapp/Main.java).

## Run It

```bash
cd 06-Desktop-Development/04-Building-a-CRUD-Desktop-App
mvn compile javafx:run
```

A real Task Manager window appears briefly (a few seconds), during which the full CRUD lifecycle and persistence round-trip run and print their real results, before the window closes itself.

## Expected Output

Real, verified Create/Read/Update/Delete operations against the actual `TableView` and its backing list, followed by a real save-to-file and reload-via-fresh-repository round trip confirming both the task's name and its done status persisted correctly.

## Common Mistakes

- Using plain `String`/`boolean` fields instead of JavaFX `Property` types in a class backing a `TableView` — this breaks the automatic UI-refresh behavior demonstrated in [Lesson 02](../02-Data-Binding-and-Observable-Collections/README.md).
- Testing persistence only by checking that a file was written, without actually reading it back with a fresh object — this lesson specifically verifies the reload with a brand-new `TaskRepository` instance, proving no in-memory state was silently relied upon.
- Performing file I/O directly inside a UI event handler on the FX Application Thread for anything beyond trivial, fast operations — for larger apps, this should move to a background thread with `Platform.runLater()` for the resulting UI update, per [Lesson 03](../03-JavaFX-Threading-Rules/README.md).

## Best Practices

- Keep the data model (`Task`), persistence (`TaskRepository`), and UI (`Main`) in separate classes — directly the [layered architecture](../../13-Software-Architecture/01-Layered-N-tier-Architecture/README.md) principle applied to a desktop app.
- Verify CRUD operations against real, observed state (the actual `TableView` items, the actual file contents) rather than assuming a button's handler does what its code appears to do.
- Test persistence with a genuine round-trip through a fresh object instance, not just a write-and-assume-it-worked check.

## Real-World Usage

This exact structure — a property-based data model, a persistence layer, and a UI wired together with real event handlers — is the foundation of real desktop CRUD applications (inventory systems, internal admin tools, personal productivity apps) built with JavaFX, and the same layered separation transfers directly to [04-Backend-Development](../../04-Backend-Development/README.md)'s web-based CRUD API, just with a desktop UI instead of HTTP endpoints as the presentation layer.

## Summary

- A complete, working Task Manager CRUD app was built and verified: Create, Read, Update, and Delete were each exercised through real button actions and real `TableView` state, not assumed from reading the code.
- A full persistence round-trip — save to a real file, then reload via a brand-new `TaskRepository` instance — was verified to correctly restore both a task's name and its done status, proving genuine persistence rather than reliance on in-memory state.

## Key Terms

- **CRUD** — Create, Read, Update, Delete: the four fundamental data operations most applications need.
- **Repository** — a class responsible for persisting and retrieving data, keeping storage details separate from business/UI logic.
- **`PropertyValueFactory`** — connects a `TableColumn` to a JavaFX bean's property, enabling automatic display updates.

## Interview Questions

1. **Why does this lesson verify persistence with a "fresh repository instance" rather than just checking that a file was written?**
   Checking only that a file was written can pass even if the application actually relies on some in-memory state that happens to still be present — it doesn't prove the data can be genuinely reconstructed from the file alone. This lesson instead created a brand-new `TaskRepository` instance (`freshRepository`), sharing no in-memory state whatsoever with the original, and called `.load()` on it — verified live to correctly reconstruct both the task's name and its `done` status purely from the real file's contents (`true|Buy milk`), proving the persistence layer genuinely round-trips data through disk rather than through any hidden in-memory shortcut.

2. **Why does the `Task` class use `SimpleStringProperty`/`SimpleBooleanProperty` instead of plain `String`/`boolean` fields, and how does this connect to earlier lessons in this module?**
   `TableColumn`'s `PropertyValueFactory` (and JavaFX data binding generally, covered in [Lesson 02](../02-Data-Binding-and-Observable-Collections/README.md)) relies on JavaFX's `Property` types to observe changes and automatically refresh the displayed UI — a plain field has no such change-notification mechanism, so a `TableView` bound to it would not reliably reflect later updates. This was demonstrated implicitly throughout this lesson's UPDATE step: toggling a task's `done` status via `selected.setDone(!selected.isDone())` correctly and automatically reflected in the underlying list's `toString()` output (`[x] Buy milk`), which depends on the property-based design working correctly.

## Recommended Next Lesson

This is the final lesson in the Desktop Development module. Return to the [module overview](../README.md).
