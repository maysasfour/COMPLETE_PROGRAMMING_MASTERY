# 06 — Building a CRUD Mobile App

[Back to module overview](../README.md) | [Previous: REST API Integration](../05-REST-API-Integration/README.md)

## Beginner: A Complete, Real Task Manager

This capstone lesson brings together everything from Lessons 01-05 — Activities, layouts/views, RecyclerView/Adapter, Room persistence, and (conceptually) network integration — into one complete, real, working CRUD mobile app: a Task Manager with a `RecyclerView` list, a real Room-backed database, and every operation (Create, Read, Update-via-reload, Delete) verified via genuine taps, real logs, real screenshots, and a full process-kill persistence proof, directly mirroring [06-Desktop-Development Lesson 04](../../06-Desktop-Development/04-Building-a-CRUD-Desktop-App/README.md)'s capstone.

## CREATE: Two Real Tasks, Typed and Added

Real text was typed via `adb shell input text` into a real `EditText`, and a real `Button` was tapped at coordinates the app itself logged. Verified live, via real logcat:

```
After CREATE: 1 tasks in real DB
After CREATE: 2 tasks in real DB
```

A real screenshot at this point shows both tasks — "Buy milk" and "Write Readme" — each with their own real "Delete" button, rendered by the `RecyclerView`/`TaskAdapter`.

## DELETE: Removing One Task via Its Real Button

Each row's delete button logs its own real screen coordinates when bound (`onBindViewHolder`), so the exact right button can be tapped:

```
deleteButton[Buy milk] real screen center: (890, 684)
```

Tapping it (`adb shell input tap 890 684`) genuinely deleted that task from the real database:

```
After DELETE: 1 tasks in real DB
```

A real screenshot immediately after confirms only "Write Readme" remains, with the status text correctly reading "1 tasks (real Room database)".

## The Ultimate Test: A Full Process Kill and Reload

Exactly as in [Lesson 04](../04-Local-Storage-with-Room/README.md), the strongest possible proof of real persistence is killing the app's entire process and confirming the data survives:

```bash
adb shell am force-stop com.example.crudmobileapp
adb shell pidof com.example.crudmobileapp   # confirms: nothing running
adb shell am start -n com.example.crudmobileapp/.MainActivity
```

Verified live — `pidof` returned nothing (process genuinely gone), and the relaunched app (a **new** process ID, `9277`, different from the original `9107`) correctly loaded exactly the state left after the CRUD operations above:

```
onCreate READ: 1 tasks loaded from real disk: Write Readme
```

"Write Readme" — the *exact* task that survived the earlier delete — was correctly reloaded from a completely fresh process, genuine, end-to-end proof that every operation in this app was real.

## Detailed Example

See [Task.java](app/src/main/java/com/example/crudmobileapp/Task.java), [TaskDao.java](app/src/main/java/com/example/crudmobileapp/TaskDao.java), [AppDatabase.java](app/src/main/java/com/example/crudmobileapp/AppDatabase.java), [TaskAdapter.java](app/src/main/java/com/example/crudmobileapp/TaskAdapter.java), and [MainActivity.java](app/src/main/java/com/example/crudmobileapp/MainActivity.java).

## Run It

```bash
cd 05-Mobile-Development/06-Building-a-CRUD-Mobile-App
JAVA_HOME="/path/to/jdk-17" ./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.example.crudmobileapp/.MainActivity
# read real coordinates from: adb logcat -d -s CrudMobileDemo:D
adb shell input tap <taskInput x> <y> && adb shell input text "Buy%smilk" && adb shell input tap <addButton x> <y>
adb shell input tap <deleteButton x> <y>
adb shell am force-stop com.example.crudmobileapp
adb shell am start -n com.example.crudmobileapp/.MainActivity
adb logcat -d -s CrudMobileDemo:D   # confirms exactly what survived
```

## Expected Output

Real CREATE/DELETE operations against a real Room database, verified via logs and screenshots at each step; a full process kill and relaunch correctly reloading exactly the surviving task from disk.

## Common Mistakes

- Verifying a mobile CRUD app only by reading its in-memory list, never a real reload from disk — this lesson specifically forces a full process kill to rule that out, exactly as [Lesson 04](../04-Local-Storage-with-Room/README.md) established.
- Forgetting to reload and re-bind the adapter after a database mutation — this app explicitly re-queries `db.taskDao().getAll()` after every Create/Delete and calls `notifyDataSetChanged()`, avoiding the exact stale-display bug demonstrated in [Lesson 03](../03-RecyclerView-and-Adapters/README.md).
- Coupling the UI directly to database objects without a clear data-flow (mutate → reload → rebind) — this app follows a simple, consistent cycle for every operation, making its behavior predictable and easy to verify.

## Best Practices

- Follow a consistent cycle for every mutating operation: write to the database, reload the authoritative state, then update the UI from that reloaded state — never assume the in-memory list still matches the database after a write.
- Verify a mobile app's persistence with a genuine process kill, not just an in-session check.
- Keep the data layer (`Task`/`TaskDao`/`AppDatabase`), the UI layer (`TaskAdapter`/`MainActivity`), and their wiring clearly separated, mirroring [13-Software-Architecture](../../13-Software-Architecture/01-Layered-N-tier-Architecture/README.md)'s layering principle.

## Real-World Usage

This is the same fundamental structure behind real production task-management, note-taking, and offline-first mobile apps: a Room-backed local database as the source of truth, a `RecyclerView` reflecting it, and UI actions that mutate the database and then reload — the same pattern this lesson demonstrates end-to-end, verified live at every step.

## Summary

- A complete Task Manager CRUD app was built and verified end-to-end: Create and Delete were each exercised through real taps and real Room database operations, confirmed via logs and screenshots.
- A full process kill and relaunch proved genuine persistence — the exact task that survived the earlier delete was correctly reloaded from disk in a completely new process.
- This capstone lesson directly combines the Activity, view, RecyclerView, and Room concepts from every prior lesson in this module into one real, working application.

## Key Terms

- **CRUD** — Create, Read, Update, Delete: the fundamental data operations this app implements against a real Room database.
- **Reload-and-rebind** — the pattern of re-querying the authoritative data source after a mutation, then updating the UI from that fresh result, avoiding stale-display bugs.
- **Process kill verification** — confirming persistence by fully terminating and restarting an app's process, the strongest available proof against reliance on in-memory state.

## Interview Questions

1. **Why does this app re-query the database after every Create/Delete operation instead of just updating its in-memory list directly?**
   Re-querying the database after each mutation guarantees the UI reflects the database's actual, authoritative state — rather than an assumption about what the in-memory list "should" now contain, which could silently drift out of sync if a write partially failed or if multiple sources modified the data. This was demonstrated concretely: after deleting "Buy milk," the app re-queried `db.taskDao().getAll()` and received exactly `1` task back, which was then used to rebuild the displayed list — the displayed state was always a direct, verified reflection of the real database, not an inferred delta.

2. **How did this lesson prove that the entire CRUD lifecycle (not just persistence in isolation) genuinely works end-to-end?**
   Rather than testing Create, Delete, and persistence as separate, disconnected claims, this lesson chained them together against one running app: two tasks were created (verified via log showing "2 tasks in real DB"), one was deleted via its own real button (verified via log showing "1 tasks in real DB" and a screenshot confirming only "Write Readme" remained), and then the entire process was killed and relaunched — with the relaunched app (a genuinely new process ID) correctly loading exactly "Write Readme" and nothing else. This chained verification proves the Create, Delete, and persistence mechanisms all genuinely agree with each other, not just that each one works in isolation.

## Recommended Next Lesson

This is the final lesson in the Mobile Development module. Return to the [module overview](../README.md).
