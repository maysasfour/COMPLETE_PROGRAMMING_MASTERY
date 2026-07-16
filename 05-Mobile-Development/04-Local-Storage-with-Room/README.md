# 04 — Local Storage with Room

[Back to module overview](../README.md) | [Previous: RecyclerView and Adapters](../03-RecyclerView-and-Adapters/README.md)

## Beginner: The Strongest Possible Proof of Persistence

Room is Android's standard SQLite abstraction. This lesson proves persistence the strongest way possible — not just writing and reading within one run, but genuinely **killing the app's entire process** (`adb shell am force-stop`, the same mechanism the OS itself uses to reclaim memory) and relaunching it, then confirming the exact same data is still there. This directly mirrors [06-Desktop-Development Lesson 04](../../06-Desktop-Development/04-Building-a-CRUD-Desktop-App/README.md)'s "fresh repository instance" proof, adapted to a real mobile process lifecycle.

## The Database

```java
@Entity(tableName = "notes")
public class Note {
    @PrimaryKey(autoGenerate = true) public int id;
    public String text;
}

@Dao
public interface NoteDao {
    @Insert void insert(Note note);
    @Query("SELECT * FROM notes ORDER BY id") List<Note> getAll();
}
```

Room requires database access off the main thread — enforced by the framework itself — so all DAO calls run on a real `ExecutorService`, the same threading discipline as [06-Desktop-Development Lesson 03](../../06-Desktop-Development/03-JavaFX-Threading-Rules/README.md)'s JavaFX rule.

## Step 1: A Real Note, Typed and Saved

A real string was typed into a real `EditText` via `adb shell input text`, and a real `Button` was tapped via `adb shell input tap` at coordinates the app itself logged from its actual layout. Verified live:

```
1 notes in the real Room database: Buy milk
```

## Step 2: Killing the Process Entirely

```bash
adb shell am force-stop com.example.localstorage
adb shell pidof com.example.localstorage   # verifies: nothing running
```

Verified live — `pidof` returned nothing (exit code 1), confirming the process was genuinely, completely gone, not just backgrounded.

## Step 3: Relaunching Fresh — The Real Proof

```bash
adb shell am start -n com.example.localstorage/.MainActivity
```

Verified live, with a **new process ID** (`8853`, different from the original `8667`) proving this was a genuinely fresh process, not a resumed one:

```
onCreate load: 1 notes loaded from disk on startup: Buy milk
```

A real screenshot taken at this point independently confirms the same result on screen: **"1 notes loaded from disk on startup: Buy milk."**

## Detailed Example

See [Note.java](app/src/main/java/com/example/localstorage/Note.java), [NoteDao.java](app/src/main/java/com/example/localstorage/NoteDao.java), [AppDatabase.java](app/src/main/java/com/example/localstorage/AppDatabase.java), and [MainActivity.java](app/src/main/java/com/example/localstorage/MainActivity.java).

## Run It

```bash
cd 05-Mobile-Development/04-Local-Storage-with-Room
JAVA_HOME="/path/to/jdk-17" ./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.example.localstorage/.MainActivity
# type a note, tap Save (read real coordinates from: adb logcat -d -s RoomDemo:D)
adb shell am force-stop com.example.localstorage
adb shell am start -n com.example.localstorage/.MainActivity
adb logcat -d -s RoomDemo:D   # confirms the note survived the full process kill
```

## Expected Output

A fresh install reporting "0 notes"; a saved note confirmed in the real database; the process verified genuinely killed (`pidof` returns nothing); a relaunch (new PID) correctly loading the same note from disk.

## Common Mistakes

- Verifying persistence only within a single app run — this proves nothing about genuine disk persistence, since in-memory state would produce an identical result. This lesson specifically forces a full process kill to rule that out.
- Performing Room database queries directly on the main thread — Room enforces this at runtime specifically to prevent janky, blocked UI from slow disk I/O; a real `ExecutorService` is required.
- Using a Room database name that collides with another app's data, or forgetting that `Room.databaseBuilder` creates a real file under the app's private data directory, persisting exactly as long as the app remains installed.

## Best Practices

- Verify persistence claims by genuinely killing and restarting the process, not just re-reading in the same run.
- Keep all Room access off the main thread via a background executor (or Room's Kotlin coroutine/RxJava support, for larger apps).
- Use Room's schema export (`exportSchema`) and migrations for any real app expected to evolve its database schema over time.

## Real-World Usage

Every real Android app storing structured local data — offline-first apps, note-taking apps, cached API responses — relies on exactly this kind of real, on-device SQLite persistence via Room. The process-kill verification technique used in this lesson mirrors what QA engineers and automated test suites do to catch "works until you actually close the app" bugs before they reach production.

## Summary

- A real note was typed and saved to a real, file-backed Room/SQLite database via genuine UI interaction (`adb shell input text`/`tap`).
- The app's process was verified, via `pidof`, to be genuinely and completely killed — not merely backgrounded.
- Relaunching produced a new process ID and correctly loaded the same note from disk — the strongest possible proof that persistence is real, not an in-memory illusion.

## Key Terms

- **Room** — Android's official SQLite abstraction layer, providing compile-time-verified queries via `@Dao` interfaces.
- **`am force-stop`** — the `adb`/system command that fully kills an app's process, the same mechanism Android itself uses to reclaim memory from backgrounded apps.
- **Entity/DAO** — Room's building blocks: `@Entity` defines a table's shape; `@Dao` defines the queries available against it.

## Interview Questions

1. **Why does force-stopping the app and checking the process ID provide stronger proof of persistence than just reading data back within the same run?**
   Reading data back within the same app run could succeed even with a purely in-memory cache that was never actually written to disk — it doesn't rule out that possibility. This lesson instead used `adb shell am force-stop` to genuinely kill the entire process (verified via `pidof` returning nothing), then relaunched the app and confirmed via a **different, new process ID** (`8853` vs. the original `8667`) that this was a completely fresh process with no shared memory whatsoever — and that fresh process still correctly loaded the note from disk, which is only possible if the data was genuinely persisted to the real SQLite file, not held in memory.

2. **Why must Room database queries run off the main thread, and how was this handled in this lesson?**
   Database queries (especially writes, or reads against a growing dataset) can take unpredictable amounts of time, and running them on the main/UI thread would block rendering and input handling, causing a frozen or janky UI — Room enforces this by throwing at runtime if you attempt a synchronous query on the main thread. This lesson used a real `ExecutorService` (`Executors.newSingleThreadExecutor()`) to run every `insert()`/`getAll()` call in the background, then used `runOnUiThread()` to marshal only the final UI update back onto the main thread — the same underlying pattern as `Platform.runLater()` in [06-Desktop-Development Lesson 03](../../06-Desktop-Development/03-JavaFX-Threading-Rules/README.md).

## Recommended Next Lesson

[05 — REST API Integration](../05-REST-API-Integration/README.md)
