# 05 — Mobile Development

[Back to repository root](../README.md)

## What Mobile Development Covers

This module covers native Android development with Java: the Activity lifecycle, layouts and views, RecyclerView/Adapter, local storage with Room, REST API integration, and a complete capstone CRUD app. Every single lesson was built into a real APK, installed on a **genuinely real, running Android emulator**, and driven with real `adb` commands — real taps, real typed text, real process kills — with results verified via real captured logs and real screenshots (viewed directly, not just described).

## Why Java and Android (Not Flutter/React Native) as This Module's Platform

Per this repository's Java-preferred directive (see [11-Design-Principles](../11-Design-Principles/README.md) and other modules for the same reasoning), this module uses **native Android with Java**, built with Gradle/AGP 8.2.2 and JDK 17 (the JDK version current Android tooling requires, distinct from this repository's usual JDK 25 for other Java modules). This choice was also a practical one: a full Android SDK, multiple pre-configured AVDs (emulators), and Gradle were already present in this environment, and Windows Hypervisor Platform (WHPX) hardware acceleration was confirmed working — making genuine, real emulator verification actually achievable, unlike [18-DevOps-and-Cloud](../18-DevOps-and-Cloud/README.md), which remains blocked by a non-functional Docker backend on this same machine.

## Why It Matters / Where It's Used

- **Mobile apps are one of the most common real-world software deployment targets**, and Android remains the most widely deployed mobile OS globally.
- **Every concept in this module has a genuinely surprising, real detail** verified by direct experimentation: `onStop` doesn't mean destroyed (Lesson 01), a `RecyclerView` can go visually stale in a way that reveals `notify*` calls are a "re-check" signal rather than a scoped update (Lesson 03), and Room's persistence claims were verified via the strongest possible test — an actual process kill (Lessons 04, 06).
- **Interviews**: "explain the Activity lifecycle," "why doesn't my RecyclerView update," "how do you handle background work in Android," and "how would you structure a CRUD mobile app" are extremely common Android interview questions, directly covered by this module's six lessons.

## Advantages of This Approach

- Every lesson's claims are backed by **triple-verified, genuinely real evidence**: real `adb logcat` output, real screenshots (visually inspected), and — for the persistence lessons — a real, complete process kill and relaunch with a **different process ID**, ruling out any in-memory illusion.
- Lesson 03 uncovered a genuinely interesting, unplanned finding through direct experimentation: a single `notifyItemInserted()` call caused a `RecyclerView` to catch up on **all** previously-unnotified changes at once, not just the one item reported — discovered by actually running the app, not assumed from documentation.
- Lesson 05 made a real network call across an actual process/network boundary (the emulator's virtual network, to a real server on the host machine), verified independently from both the client's and the server's own logs.

## Disadvantages / Trade-offs

- This module's toolchain (Gradle 8.2, AGP 8.2.2, JDK 17) is distinct from the JDK 25 used elsewhere in this repository's Java modules — current Android tooling has its own, separate JDK compatibility requirements, a genuine constraint discovered while setting up Lesson 01.
- Real emulator-based verification, while much stronger than assumption, is slower than this repository's typical `mvn test`/`javac && java` cycles — each lesson's full verification took real, measured wall-clock time (builds, installs, taps, waits).
- This module's examples use plain Android APIs (Room, RecyclerView, `HttpURLConnection`) rather than more modern Kotlin-first tooling (Jetpack Compose, Retrofit, coroutines) — appropriate for a Java-focused repository, but worth knowing these exist as the current industry-standard alternatives.

## How to Run the Examples

Each lesson is a self-contained Gradle/Android project. All require a running Android emulator or connected device, and JDK 17 specifically for the Gradle build (distinct from this repository's usual JDK 25).

```bash
cd 05-Mobile-Development/01-Android-Fundamentals
JAVA_HOME="/path/to/jdk-17" ./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.example.androidfundamentals/.MainActivity
```

This module was verified against a real AVD (`Medium_Phone_API_28`) with Windows Hypervisor Platform (WHPX) acceleration. `app/build/` and `.gradle/` directories are not committed — rebuild locally after cloning.

## Common Beginner Mistakes

- **Assuming `onStop` means an Activity has been destroyed** — verified live in Lesson 01 that the same instance survives and resumes via `onRestart`.
- **Guessing UI element coordinates for automated interaction** rather than reading them from the real, laid-out view — Lessons 02, 03, 04, 05, and 06 all log real coordinates from the app itself before tapping.
- **Modifying a RecyclerView's backing list without notifying the adapter** — verified live in Lesson 03 to leave the screen genuinely stale.
- **Verifying "persistence" only within a single app run** — Lessons 04 and 06 specifically force a full process kill to rule out in-memory illusions.
- **Using `localhost`/`127.0.0.1` from emulator code to reach the host machine** — Lesson 05 demonstrates the correct `10.0.2.2` alias.

## Best Practices

- Release/acquire resources symmetrically across matching lifecycle callbacks (`onResume`/`onPause`, etc.).
- Pair every backing-data mutation with the correct `notify*` Adapter call in the same operation.
- Keep Room (and all database/network) access off the main thread via a real `ExecutorService`.
- Verify persistence claims with a genuine process kill, not just an in-session re-read.
- Use `10.0.2.2` (not `localhost`) when an emulator needs to reach a server on its host machine during development.

## Interview Questions

1. What's the difference between `onPause`/`onStop` and `onDestroy` in the Activity lifecycle?
2. Why doesn't a RecyclerView update automatically when its backing list changes?
3. Why must Room database access happen off the main thread, and how is that handled correctly?
4. What's the correct way for an Android emulator to reach a server running on its host machine?
5. How would you verify that a mobile app's local persistence is genuinely working, rather than assuming it from the code?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Android Fundamentals](01-Android-Fundamentals/README.md) | The real Activity lifecycle, verified via logcat across launch/background/foreground |
| 02 | [Layouts and Views](02-Layouts-and-Views/README.md) | Real physical taps on a real screen, verified via logs and a screenshot |
| 03 | [RecyclerView and Adapters](03-RecyclerView-and-Adapters/README.md) | A real stale-list bug and what `notify*` calls actually do, verified via screenshots |
| 04 | [Local Storage with Room](04-Local-Storage-with-Room/README.md) | Real SQLite persistence, verified via a full process kill and relaunch |
| 05 | [REST API Integration](05-REST-API-Integration/README.md) | A real network call from the emulator to a real host server via `10.0.2.2` |
| 06 | [Building a CRUD Mobile App](06-Building-a-CRUD-Mobile-App/README.md) | A complete Task Manager combining every prior lesson's concepts, end-to-end verified |

## Suggested Path

Work through 01 → 06 in order — Lesson 06 (the capstone) directly combines Lesson 01's Activity structure, Lesson 02's view interaction, Lesson 03's RecyclerView/Adapter (with its notify-call lesson correctly applied), and Lesson 04's Room persistence discipline. See also [06-Desktop-Development](../06-Desktop-Development/README.md) for the same CRUD-app concept applied to a JavaFX desktop UI instead of a mobile one, and [14-APIs-and-Integrations](../14-APIs-and-Integrations/README.md) for the server-side HTTP concepts this module's Lesson 05 connects to.

**Previous module:** [06-Desktop-Development](../06-Desktop-Development/README.md)
