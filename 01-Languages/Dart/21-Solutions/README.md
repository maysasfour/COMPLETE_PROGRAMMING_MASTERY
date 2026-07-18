# 21 — Solutions

[Back to course overview](../README.md) | [Exercises](../20-Exercises/README.md)

Runnable solutions for every problem in [20-Exercises](../20-Exercises/README.md). Each `solution-0N.dart` matches Exercise N and is run directly with `dart run solution-0N.dart` — no `pubspec.yaml` needed, since none of these problems reach outside the Dart standard library (`dart:async`, `dart:convert`, `dart:io`, all built in). All eight have been actually executed against **Dart SDK 3.10.8 (stable)** (`dart --version`) from inside this exact folder — the output blocks below are pasted straight from the terminal, not predicted.

## Solution 01 — Null Safety & Validation

```
--- Profile with a bio ---
Mathematician and programmer.

--- Profile with bio: null ---
No bio provided

--- Blank username caught ---
Caught expected error: InvalidUsernameException: username cannot be blank

--- Narrowing String? via ?. and ! ---
maybeName?.toUpperCase(): MATHEMATICIAN AND PROGRAMMER.
definitelyName (after !): Mathematician and programmer.
```

`late final DateTime registeredAt` is declared without an initializer and assigned inside the constructor **body**, after the blank-username check has already had a chance to throw — proving `late` genuinely defers initialization rather than requiring it up front like a normal `final`. `??` only substitutes when `bio` is exactly `null` (not merely falsy), and `!` on `maybeName` is safe here specifically because the code above already guarantees non-null — using it on a value that *isn't* already known-safe is exactly the anti-pattern this repository's [19-Best-Practices](../19-Best-Practices/README.md) warns about.

## Solution 02 — Cascade Operator Fluent Builder

```
--- Built via cascade (..) ---
POST /users
  Authorization: Bearer xyz
  Accept: application/json

--- Built the verbose way ---
POST /users
  Authorization: Bearer xyz
  Accept: application/json

--- Both produce identical output: true ---
```

Every method on `HttpRequestBuilder` returns `void`, and the cascade still chains cleanly — `..` re-evaluates to the **original receiver** after each call regardless of what that call returned, unlike `.` chaining (which requires each method to return `this`). This is a genuine, distinctive difference from fluent-builder patterns in languages without a dedicated cascade operator, where returning `this` from every setter is the only way to get chaining at all.

## Solution 03 — Mixins via `with`

```
--- Duck: two independent mixins ---
Duck flies through the air and swims through water

--- Goose: LoudFlyable overrides Flyable via super ---
Goose flies through the air (loudly!)

(Reversing to "with LoudFlyable, Flyable" would fail: the `on Flyable`
 clause requires Flyable to already be applied before LoudFlyable is.)
```

**Verified live, not just asserted:** temporarily changing `class Goose with Flyable, LoudFlyable` to `class Goose with LoudFlyable, Flyable` and running it produced a real compile error:

```
Error: 'Object' doesn't implement 'Flyable' so it can't be used with 'LoudFlyable'.
Error: The class doesn't have a concrete implementation of the super-invoked member 'fly'.
Context: This is the super-access that doesn't have a concrete target.
```

Mixins apply left-to-right, each layering onto the chain built so far — `LoudFlyable`'s `on Flyable` clause requires `Flyable` to already be part of that chain by the time `LoudFlyable` is applied, so putting `LoudFlyable` first leaves nothing for its `on Flyable` constraint (and its `super.fly()` call) to resolve against.

## Solution 04 — Extension Methods

```
--- ListChunking<T>: a generic extension method ---
[[1, 2, 3], [4, 5, 6], [7]]
chunk count: 3, last chunk length: 1

--- DateOnly: extension getter on DateTime ---
2026-07-18

--- NumClamp: extension method on num ---
0
5
0
3.5
```

`extension ListChunking<T> on List<T>` parameterizes the whole extension block over `T`, so `chunked()` works identically on `List<int>`, `List<String>`, or any other element type without rewriting it — the same static-dispatch mechanism as Kotlin's/C#'s extension functions, resolved entirely at compile time (no runtime monkey-patching of `List` itself). `DateOnly` and `NumClamp` show the same mechanism applied to `DateTime` and `num`, types this code doesn't own and can't subclass to add behavior to.

## Solution 05 — Reified Generics: a Typed Cache

```
--- Reified generics: is-checks genuinely distinguish type arguments ---
intCache is TypedCache<int>: true
intCache is TypedCache<String>: false
intCache.valueType: int
stringCache.valueType: String

--- Same check style applied to plain generic Lists ---
mixedIntValues is List<int>: false
mixedIntValues.runtimeType: List<dynamic>
<int>[1, 2, 3] is List<int>: true
realStringList is List<int>: false

--- Contrast with Java (covered earlier in this repository) ---
In Java, generics are ERASED at compile time: at runtime a Cache<Integer>
and a Cache<String> are both just "Cache" -- the type argument no longer
exists to check against. `cache instanceof TypedCache<Integer>` (or any
parameterized-type instanceof check) is a COMPILE ERROR in Java, not just
false -- the language does not even let you ask the question, because the
information needed to answer it was thrown away after compilation. Dart's
is-checks above work because Dart genuinely keeps the type argument at runtime.
```

**A subtlety confirmed while verifying:** `mixed.values.toList()` came from a `Map<String, dynamic>`, so even though every runtime element happens to be an `int`, the *list's own* reified type argument is `dynamic` (confirmed: `mixedIntValues.runtimeType` prints `List<dynamic>`, and `is List<int>` is `false`) — reified generics check the **declared/constructed type argument of the container**, not "do all current elements happen to match right now". Only `<int>[1, 2, 3]`, built with an explicit `<int>` type argument, passes `is List<int>`.

## Solution 06 — Concurrent Futures

```
--- Kicking off 4 concurrent fetches ---
Elapsed: 516ms (slowest single delay was 500ms -- proves concurrency, not a ~1400ms sum)

--- per-fetch results ---
  OK: https://api.example.com/users -> 200 OK
  OK: https://api.example.com/orders -> 200 OK
  FAILED: FetchFailedException: https://api.example.com/broken failed
  OK: https://api.example.com/products -> 200 OK

3 succeeded, 1 failed -- no result silently dropped.
```

Elapsed time (516ms, varying slightly run to run) tracks the slowest individual delay (500ms) plus a small scheduling overhead, not the sum of all four delays (300+500+200+400 = 1400ms) — direct, measured proof the futures ran concurrently, not sequentially, matching this course's Lesson 14 example. `Future.wait` by default rethrows only the *first* future's error and abandons tracking the rest; wrapping each future in its own `.then(onValue, onError:)` before the `Future.wait` (rather than relying on `Future.wait`'s own error handling) is what lets every outcome — success or failure — survive to be inspected afterward, with `eagerError: false` reinforcing that the batch shouldn't short-circuit early.

## Solution 07 — Streams: Transform and Filter

```
--- Stream pipeline: where -> map -> toList ---
[4, 16, 36, 64, 100]

--- Hand-built StreamController: onError does NOT terminate the stream ---
[data:1, data:2, error:simulated failure, data:3, done]
Value added AFTER the error still arrived: true
```

`.where()` and `.map()` on a `Stream` behave like their `Iterable` counterparts but operate lazily over time rather than over an already-complete collection — each transformation only runs as values actually arrive from the underlying `async*` generator. The `StreamController` half confirms a genuinely easy-to-miss point: `addError()` delivers to the `onError` callback but does **not** close the stream by itself — `data:3`, added after the simulated error, still reached `onData`, and the stream only actually ended once `.close()` was called explicitly.

## Solution 08 — Capstone: JSON, Generics, and Null Safety Together

```
--- serializing 6 books to C:\Users\HP\AppData\Local\Temp/dart_books_exercise08.json ---

--- reading back and deserializing ---
Deserialized 6 books.

--- books after 2015 with rating >= 4.0, sorted by rating desc ---
  Atomic Habits (2018) by James Clear -- 4.8
  Effective Dart (2020) by Google -- 4.6
  Deep Work (2016) by Cal Newport -- 4.3

Cleanup check -- file still exists: false
```

`List<T> parseJsonList<T>(String, T Function(Map<String, dynamic>))` is a genuinely reusable generic function — the `Book.fromJson` factory is passed in as a value (Dart constructors/factories are first-class function values), so the same `parseJsonList` could decode any other `fromJson`-shaped type without modification. `rating` is `double?`, and both unrated books (`Dart in Action`, `The Pragmatic Programmer`) round-tripped through JSON as `null` cleanly with `as double?` in `fromJson` — no cast exception, and the `rating != null && rating! >= 4.0` filter correctly excludes both from the final list.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
