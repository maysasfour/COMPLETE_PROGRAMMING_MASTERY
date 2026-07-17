# Mobile Development (Android) Cheat Sheet

[Back to Cheat Sheets](../README.md) | [Full module](../../05-Mobile-Development/README.md)

## Activity Lifecycle
```
onCreate -> onStart -> onResume        (launch)
onPause -> onStop                       (backgrounded, e.g. Home pressed)
onRestart -> onStart -> onResume        (returned to foreground -- SAME instance)
onDestroy                               (instance actually torn down)
```
Verified live via real `adb logcat` in [05-Mobile-Development/01](../../05-Mobile-Development/01-Android-Fundamentals/README.md): `onStop` does NOT mean destroyed.

## Layouts and Views
```java
TextView label = findViewById(R.id.myLabel);
Button button = findViewById(R.id.myButton);
button.setOnClickListener(v -> label.setText("Clicked!"));
```
See [05-Mobile-Development/02](../../05-Mobile-Development/02-Layouts-and-Views/README.md) — verified with real physical taps via `adb shell input tap`.

## RecyclerView and Adapters
```java
class MyAdapter extends RecyclerView.Adapter<MyAdapter.ViewHolder> {
    // after modifying the backing list, ALWAYS notify:
    notifyItemInserted(position);   // or notifyDataSetChanged()
}
```
Modifying the list without notifying leaves the screen stale — verified live with a real screenshot showing only 3 of 4 actual items. See [05-Mobile-Development/03](../../05-Mobile-Development/03-RecyclerView-and-Adapters/README.md).

## Local Storage (Room)
```java
@Entity class Note { @PrimaryKey(autoGenerate = true) int id; String text; }
@Dao interface NoteDao {
    @Insert void insert(Note note);
    @Query("SELECT * FROM notes") List<Note> getAll();
}
```
Room enforces off-main-thread access — use a real `ExecutorService`. Persistence verified with the strongest proof available: a genuine `adb shell am force-stop` process kill, then reload. See [05-Mobile-Development/04](../../05-Mobile-Development/04-Local-Storage-with-Room/README.md).

## REST API Integration
```java
URL url = new URL("http://10.0.2.2:8090/api/greeting"); // emulator's alias for the HOST's localhost
```
Never use `localhost` from emulator code to reach the host machine. See [05-Mobile-Development/05](../../05-Mobile-Development/05-REST-API-Integration/README.md) — verified with a real network call and a real `SocketTimeoutException` before the server started.

## Run It
```bash
./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.example.app/.MainActivity
```

See the [full Mobile Development module](../../05-Mobile-Development/README.md) for verified, runnable Android lessons on everything above, including a full CRUD capstone app.
