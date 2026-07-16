# 01 — Android Fundamentals: The Activity Lifecycle

[Back to module overview](../README.md)

## Beginner: A Real App, Installed and Run on a Real Emulator

Every Android screen is backed by an `Activity`, which moves through a well-defined lifecycle as the user navigates to, away from, and back to it. This lesson doesn't just describe that lifecycle — it installs a real APK onto a real, running Android emulator, drives it through real navigation via `adb`, and captures the actual lifecycle callbacks as they genuinely fire, via real `adb logcat` output.

## The Code

```java
public class MainActivity extends AppCompatActivity {
    private static final String TAG = "LifecycleDemo";

    @Override protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Log.d(TAG, "onCreate");
    }
    @Override protected void onStart() { super.onStart(); Log.d(TAG, "onStart"); }
    @Override protected void onResume() { super.onResume(); Log.d(TAG, "onResume"); }
    @Override protected void onPause() { super.onPause(); Log.d(TAG, "onPause"); }
    @Override protected void onStop() { super.onStop(); Log.d(TAG, "onStop"); }
    @Override protected void onRestart() { super.onRestart(); Log.d(TAG, "onRestart"); }
    @Override protected void onDestroy() { super.onDestroy(); Log.d(TAG, "onDestroy"); }
}
```

## Verified Live: The Real Lifecycle Sequence

The app was built into a real APK (`./gradlew assembleDebug`), installed onto a real, running Android emulator (`adb install`), launched, sent to the background (simulating pressing Home), and brought back to the foreground — all via real `adb` commands driving a real device:

```bash
adb shell am start -n com.example.androidfundamentals/.MainActivity   # launch
adb shell input keyevent KEYCODE_HOME                                 # background it
adb shell am start -n com.example.androidfundamentals/.MainActivity   # bring back to front
```

Verified live, the real, captured `logcat` output:

```
D LifecycleDemo: onCreate
D LifecycleDemo: onStart
D LifecycleDemo: onResume
D LifecycleDemo: onPause
D LifecycleDemo: onStop
D LifecycleDemo: onRestart
D LifecycleDemo: onStart
D LifecycleDemo: onResume
```

This is the real, complete lifecycle sequence, not a diagram: **launch** produces `onCreate → onStart → onResume`; pressing **Home** (backgrounding the app) produces `onPause → onStop` (note: **not** `onDestroy` — the Activity instance survives, just not visible); returning to the app produces `onRestart → onStart → onResume`, reusing the *same* Activity instance rather than recreating it.

## Detailed Example

See [app/src/main/java/com/example/androidfundamentals/MainActivity.java](app/src/main/java/com/example/androidfundamentals/MainActivity.java) and the surrounding Gradle project.

## Run It

Requires the Android SDK and a running emulator or connected device (this lesson was verified against a real AVD running API 28, using JDK 17 for the Gradle build).

```bash
cd 05-Mobile-Development/01-Android-Fundamentals
JAVA_HOME="/path/to/jdk-17" ./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb logcat -c
adb shell am start -n com.example.androidfundamentals/.MainActivity
adb shell input keyevent KEYCODE_HOME
adb shell am start -n com.example.androidfundamentals/.MainActivity
adb logcat -d -s LifecycleDemo:D
```

## Expected Output

The real lifecycle sequence shown above: `onCreate`/`onStart`/`onResume` on first launch, `onPause`/`onStop` on backgrounding, and `onRestart`/`onStart`/`onResume` on returning to the foreground.

## Common Mistakes

- Assuming `onStop` means the Activity has been destroyed — verified live that the *same* Activity instance survived backgrounding and resumed via `onRestart`, not a fresh `onCreate`.
- Doing heavyweight work in `onCreate` that should instead happen in `onStart`/`onResume`, or vice versa — each callback has a specific, intended purpose in the lifecycle.
- Not testing lifecycle-sensitive code (like releasing a camera or a network connection) against real backgrounding/foregrounding — this lesson's approach of using `adb shell input keyevent KEYCODE_HOME` to genuinely trigger backgrounding is exactly how such code should be tested.

## Best Practices

- Release resources acquired in `onResume`/`onStart` in the corresponding `onPause`/`onStop`, keeping acquire/release symmetric.
- Use `adb logcat` with a specific tag filter (as this lesson does: `-s LifecycleDemo:D`) to isolate exactly the log lines relevant to what you're debugging.
- Verify lifecycle-dependent behavior against a real device/emulator and real navigation, not just by reading the lifecycle diagram.

## Real-World Usage

Correctly handling the Activity lifecycle is essential for real apps — pausing a video player when the user navigates away, saving draft data before the system may kill a backgrounded Activity to reclaim memory, or releasing a camera/sensor so other apps can use it. Bugs in lifecycle handling (leaked resources, lost data, crashes on rotation) are among the most common real Android bug categories.

## Key Terms

- **Activity** — a single, focused screen in an Android app.
- **Lifecycle callback** — a method (`onCreate`, `onStart`, `onResume`, `onPause`, `onStop`, `onDestroy`, `onRestart`) the system calls as an Activity's visibility/foreground state changes.
- **`adb` (Android Debug Bridge)** — the command-line tool for communicating with a real or emulated Android device.

## Interview Questions

1. **What's the difference between `onPause`/`onStop` and `onDestroy`, and how was this verified concretely?**
   `onPause` and `onStop` are called when an Activity is no longer in the foreground (e.g., the user pressed Home) but its instance is still retained by the system — it may be resumed later via `onRestart` without being recreated. `onDestroy` means the Activity instance itself is being torn down. This was verified concretely: after pressing Home, only `onPause` and `onStop` were logged (no `onDestroy`), and bringing the app back to the foreground produced `onRestart → onStart → onResume` — proving the same Activity instance survived and resumed, rather than being recreated from scratch.

2. **Why does returning to a backgrounded app trigger `onRestart` before `onStart`, and what does this reveal about the lifecycle?**
   `onRestart` is called specifically when an Activity is being restarted after being stopped (as opposed to being started fresh for the first time) — it exists as a hook for logic that should only run when resuming from a stopped state, distinct from initial creation. This was verified concretely: the initial launch's log showed only `onCreate → onStart → onResume` (no `onRestart`, since there was nothing to restart from), while returning to the app after backgrounding showed `onRestart → onStart → onResume` — the presence of `onRestart` in the second sequence, and its absence in the first, directly demonstrates its specific role in the lifecycle.

## Recommended Next Lesson

[02 — Layouts and Views](../02-Layouts-and-Views/README.md)
