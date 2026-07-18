# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Eight standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 — solve those first if you haven't, then come back here for problems that pull in sound null safety, the cascade operator, mixins, extension methods, reified generics, and `Future`/`async`/`await`/`Stream` — the features this course's [README](../README.md) calls out as genuinely distinctive to Dart.

Attempt each problem yourself in a scratch `.dart` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`Exercise 01` &harr; `solution-01.dart`).

## Exercise 01 — Null Safety & Validation (Beginner)

**Lessons used:** Variables and Data Types (03), Error Handling (09)

Define a class `UserProfile` with:
- `final String username` — never null, validated in the constructor
- `final String? bio` — optional, may be `null`
- `late final DateTime registeredAt` — set inside the constructor body, not the initializer list, to demonstrate `late` deferring initialization
- a constructor that throws a custom `InvalidUsernameException implements Exception` if `username` is empty or whitespace-only (check with `.trim().isEmpty`)
- a method `String displayBio()` that returns `bio` if set, or `'No bio provided'` otherwise, using `??` — not an `if` statement

Demonstrate: one profile built successfully with a bio, one built successfully with `bio: null` (confirm `displayBio()` falls back correctly), and one construction attempt with a blank username caught via `try`/`catch`, printing the exception message. Also show a `String?` narrowed to non-null via `?.` and `!` on a value you've already null-checked.

## Exercise 02 — Cascade Operator Fluent Builder (Beginner)

**Lessons used:** Operators (04)

Define a class `HttpRequestBuilder` with mutable fields `String method = 'GET'`, `String path = '/'`, `Map<String, String> headers = {}`, and methods `setMethod(String m)`, `setPath(String p)`, `addHeader(String key, String value)` (each returning `void`, not `this` — the point is to prove cascades work without fluent-chaining return values) and a `String build()` that renders something like `'GET /users\n  Authorization: Bearer xyz\n  Accept: application/json'`.

Construct **one** request using the cascade operator (`..`) to call `setMethod`, `setPath`, and two `addHeader` calls in a single chained expression on a freshly-constructed instance, then call `.build()` on the result. Then construct an equivalent request the verbose way (a local variable, four separate statements, each re-typing the variable name) and prove both produce identical output. Explain in a comment why the cascade works even though every method returns `void`.

## Exercise 03 — Mixins via `with` (Intermediate)

**Lessons used:** OOP (11)

Define two mixins: `mixin Flyable { String fly() => 'flies through the air'; }` and `mixin Swimmable { String swim() => 'swims through water'; }`. Define a class `Duck with Flyable, Swimmable` and a method `String describe()` that calls both `fly()` and `swim()`.

Then define a third mixin `mixin LoudFlyable on Flyable` (a mixin restricted to only apply to classes that already have `Flyable`, via the `on` clause) that overrides `fly()` to call `super.fly()` and append `' (loudly!)'`. Apply it to a second class `Goose with Flyable, LoudFlyable` and show that mixin application **order matters** — `with Flyable, LoudFlyable` resolves `fly()` to `LoudFlyable`'s override (since it comes last and its `super` refers to `Flyable`), and explain in a comment what would happen (a compile error) if the order were reversed.

## Exercise 04 — Extension Methods (Intermediate)

**Lessons used:** Functional Concepts (12)

Write three extension methods on types you don't own:
- `extension ListChunking<T> on List<T>` with a method `List<List<T>> chunked(int size)` that splits the list into sublists of at most `size` elements (a **generic extension**, parameterized over `T`)
- `extension DateOnly on DateTime` with a getter `String get isoDate` that formats as `YYYY-MM-DD` (zero-padded) without using `package:intl`
- `extension NumClamp on num` with a method `num clampPositive()` that returns `0` if the number is negative, otherwise the number itself

Demonstrate all three, including `chunked` on a `List<int>` of 7 elements with `size: 3` (should produce 3 sublists: two of length 3, one of length 1).

## Exercise 05 — Reified Generics: a Typed Cache (Intermediate/Advanced)

**Lessons used:** Generics (13)

Build a generic class `TypedCache<T>` wrapping a `Map<String, T>`, with `void put(String key, T value)`, `T? get(String key)`, and a getter `Type get valueType => T` (using Dart's reified type parameter directly, not `T.runtimeType` on an instance).

Create a `TypedCache<int>` and a `TypedCache<String>`, and prove **at runtime** (not just at compile time) that:
- `intCache is TypedCache<int>` is `true` and `intCache is TypedCache<String>` is `false`
- `intCache.valueType` prints `int`, genuinely reflecting the type argument the instance was constructed with
- a plain `Map<String, dynamic>` populated with mixed `int`/`String` values, when queried with `is List<int>`-style checks on `.values.toList()`, distinguishes correctly from a same-shaped `List<int>`

In a comment, explain briefly why the equivalent check (`cache instanceof TypedCache<Integer>`) would not even compile in Java, contrasting Java's erasure-based generics (covered earlier in this repository) with Dart's reified ones.

## Exercise 06 — Concurrent Futures (Advanced)

**Lessons used:** Async and Concurrency (14), Error Handling (09)

Write `Future<String> fetchAsync(String url, int delayMs, {bool shouldFail = false}) async` that simulates a network call with `await Future.delayed(Duration(milliseconds: delayMs))`, then either returns `'$url -> 200 OK'` or throws a custom `FetchFailedException implements Exception` if `shouldFail` is `true`.

Using `Future.wait(..., eagerError: false)`, kick off at least 4 simulated fetches concurrently (mixed delays, at least one `shouldFail: true`) wrapped so a single failure doesn't abort the batch. Measure and print total elapsed wall-clock time (via `DateTime.now()` before/after), proving it's close to the *slowest single* delay, not the *sum* of all delays — direct proof they ran concurrently, not sequentially. Report which fetches succeeded and which failed, without letting one failure silently swallow the others' results.

## Exercise 07 — Streams: Transform and Filter (Advanced)

**Lessons used:** Async and Concurrency (14)

Write a `Stream<int> numberStream(int max) async*` generator that `yield`s `1` through `max` with a small delay between each (`await Future.delayed(...)` before each `yield`). Using stream transformation methods (`.where()`, `.map()`, not a manual loop with `if`), build a pipeline that:
- filters to only even numbers
- maps each to its square
- collects the results into a `List<int>` via `.toList()`

Separately, build a `StreamController<int>` by hand, add a listener with `.listen(onData: ..., onError: ..., onDone: ...)`, manually `.add()` three values and one `.addError()` call, then `.close()` it — proving the `onError` callback fires without terminating the stream (the next `.add()` after the error still reaches `onData`).

## Exercise 08 — Capstone: JSON, Generics, and Null Safety Together (Advanced)

**Lessons used:** File Handling (10), Generics (13), Variables and Data Types (03)

Define `class Book` with `final String title`, `final String author`, `final int year`, `final double? rating` (nullable — not every book has been rated), plus `factory Book.fromJson(Map<String, dynamic> json)` and `Map<String, dynamic> toJson()` (pairing with `dart:convert`, per Lesson 10).

Write a generic function `List<T> parseJsonList<T>(String jsonText, T Function(Map<String, dynamic>) fromJson)` that decodes a JSON array and maps each element through the given factory — reusable for `Book` or any similarly-shaped type, proving generics compose with the `dart:convert` pattern from Lesson 10.

Build a `List<Book>` of at least 6 books (mix of rated and unrated), encode it to a JSON string with `jsonEncode`, write it to a temporary file, read it back, and decode it with `parseJsonList`. Then filter to books published after 2015 with `rating != null && rating! >= 4.0`, sorted by rating descending, and print them. Delete the temporary file at the end and confirm (via `File(path).existsSync()`) that cleanup succeeded.

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
