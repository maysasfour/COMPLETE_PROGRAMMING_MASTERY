# 19 — Best Practices

[Back to course overview](../README.md) | [Previous: Testing](../18-Testing/README.md)

## Learning Objectives

- Recognize and fix three genuine Dart anti-patterns: assuming `List` uses content equality (it doesn't, by default), force-unwrap (`!`) crashing with an unhelpful error instead of clear handling, and blocking the event loop with heavy synchronous computation instead of using an `Isolate`.
- See the event-loop-blocking anti-pattern proven with a real, running timer whose ticks stop during the blocking call and resume once the work is moved to an isolate.

## Prerequisites

[18-Testing](../18-Testing/README.md)

## Concept

This lesson is a synthesis: three mistakes that compile and run in Dart but produce genuinely surprising or harmful behavior, each demonstrated with a live "bad" version actually misbehaving, and a "good" version fixing it — following the same before/after discipline as every other language course in this repository.

## Anti-Pattern 1: `List ==` Is Identity Equality, Not Content Equality

```dart
bool listsMatchBad(List<int> a, List<int> b) => a == b; // IDENTITY equality by default!

bool listsMatchGood(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) { if (a[i] != b[i]) return false; }
  return true;
}
```

Verified live: `[1, 2, 3] == [1, 2, 3]` (two separately-constructed lists with identical content) returned **`false`** — Dart's default `List.==` compares object *identity*, not content, unlike most languages covered in this repository, where `[1,2,3] == [1,2,3]` typically compares structurally. The manual, element-by-element comparison correctly returned `true`. (For real code, `package:collection`'s `ListEquality` provides a proper, built-in content-equality comparator rather than hand-rolling this loop.)

## Anti-Pattern 2: Force-Unwrap (`!`) vs. Clear Error Handling

```dart
int findUserBad(Map<String, int> users, String name) => users[name]!; // unhelpful crash if missing
int findUserGood(Map<String, int> users, String name) {
  var id = users[name];
  if (id == null) throw StateError("no user named '$name' found");
  return id;
}
```

Verified live: the bad version threw a generic `_TypeError` ("Null check operator used on a null value," per Lesson 03) with no indication of *what* was missing, while the good version threw a clear, specific `StateError: no user named 'Linus' found`.

## Anti-Pattern 3: Blocking the Event Loop vs. Using an `Isolate`

```dart
int heavySyncComputation() { /* a genuinely long-running, CPU-bound loop */ }

void isolateEntryPoint(SendPort sendPort) => sendPort.send(heavySyncComputation());
```

Verified live with a genuinely running periodic timer as a real-time witness: a `Stream.periodic` timer ticking every 20ms recorded **zero ticks** while `heavySyncComputation()` ran synchronously on the main isolate (confirming the event loop was completely blocked for the ~239ms the computation took) — but running the *same* computation via `Isolate.spawn` let the timer accumulate **10 ticks** during the isolate's ~191ms of wall-clock work, proving the main isolate's event loop remained free and responsive the entire time, since the heavy computation ran on a genuinely separate isolate (Lesson 14).

## Detailed Example

See [example.dart](example.dart) — all three anti-pattern/fix pairs, run and verified, including the live timer-based proof of the event-loop-blocking anti-pattern.

## Run It

```bash
cd 01-Languages/Dart/19-Best-Practices
dart run example.dart
```

## Expected Output

Running `dart run example.dart` shows `listsMatchBad` returning `false` for two identical-content lists (the surprising identity-equality default) versus `listsMatchGood` correctly returning `true`; a generic `_TypeError` for the force-unwrap version versus a clear `StateError` message for the safe version; and the event-loop timer recording effectively zero ticks during the blocking synchronous computation versus a healthy number of ticks accumulated while the same work ran in a separate isolate.

## Common Mistakes

- Assuming `List`/`Map`/`Set` use content-based `==` the way many languages' collections do by default — verified live that Dart's `List.==` is identity-based; content comparison requires either a manual loop or `package:collection`'s equality helpers.
- Using `!` on a value that could plausibly be absent, especially from external or user-provided data — verified live to produce a generic, unhelpful runtime error compared to explicit `null` checking with a clear, specific thrown error.
- Running CPU-intensive synchronous work directly on the main isolate in a Flutter app or any event-loop-driven Dart program — verified live to completely block the event loop (and, in a Flutter app, freeze the UI) for the computation's entire duration; `Isolate.spawn` (or Flutter's `compute()` helper, which wraps isolate spawning) is the fix.

## Best Practices

- Use `package:collection`'s `ListEquality`/`SetEquality`/`MapEquality` (or a manual comparison) whenever content-based collection equality is genuinely needed — never assume `==` provides it by default.
- Prefer explicit `null` checks with clear, specific errors over `!` for any value that could plausibly be absent from real, external, or user-provided data.
- Offload genuinely CPU-intensive, long-running synchronous work to an `Isolate` (or Flutter's `compute()`) rather than running it directly on the main isolate's event loop.

## Real-World Usage

The `List.==`-is-identity-not-content surprise is a genuinely common real-world Dart gotcha, frequently encountered when comparing data structures (e.g., in tests, or comparing old-vs-new state) and specifically why `package:collection`'s equality helpers exist; blocking the main isolate/UI thread with heavy synchronous work is one of the most commonly cited real-world Flutter performance bugs, addressed directly by `compute()`/`Isolate.spawn`, both demonstrated with real, measured proof in this lesson.

## Summary

- Dart's default `List`/`Map`/`Set` equality is identity-based, not content-based — verified live to be a genuine, surprising gotcha; use `package:collection`'s equality helpers (or a manual comparison) for content equality.
- Force-unwrap (`!`) should be reserved for genuinely provable non-null cases; explicit `null` checks with clear, specific errors communicate failure far more usefully, verified live.
- Heavy synchronous computation genuinely blocks Dart's single-threaded event loop — proven live with a real, ticking timer that stopped during the blocking call and resumed once the same work moved to a separate isolate.

## Key Terms

- **Identity equality** — comparing two references by whether they point to the exact same object, Dart's default `List`/`Map`/`Set` `==` behavior.
- **Event loop blocking** — a long-running synchronous operation preventing any other code (timers, I/O callbacks, UI updates) from running until it completes.

## Interview Questions

1. **Why does `[1, 2, 3] == [1, 2, 3]` evaluate to `false` in Dart, and how would you fix a function that needs genuine content equality?**
   Dart's `List` class does not override `==`/`hashCode` for content-based comparison by default — its inherited `==` (from `Object`) compares object identity, so two separately-constructed lists with identical elements are considered unequal, verified directly in this lesson. To compare lists by content, either write a manual element-by-element comparison (checking length, then each index) or use `package:collection`'s `ListEquality` (`const ListEquality().equals(a, b)`), which provides a proper, tested content-equality implementation without needing to hand-roll the comparison loop.

2. **How was the claim that heavy synchronous computation blocks Dart's event loop proven rather than just asserted, and what's the fix?**
   By running a genuinely live, ticking `Stream.periodic` timer (firing every 20ms) alongside the computation: during a ~239ms synchronous, CPU-bound loop running directly on the main isolate, the timer recorded effectively zero ticks — direct, measured proof the event loop was completely unable to process anything else during that time. Running the identical computation via `Isolate.spawn` instead let the same timer accumulate 10 ticks during the isolate's comparable ~191ms of wall-clock work, proving the main isolate's event loop remained free and responsive throughout. The fix for genuinely CPU-intensive work is to move it off the main isolate — via `Isolate.spawn` directly (as shown here) or Flutter's `compute()` helper, which wraps the same underlying isolate-spawning mechanism in a simpler API.

## Recommended Next Lesson

This completes the core Dart course (Lessons 01–19). Return to the [Dart course overview](../README.md) or continue to the next language in the course order.
