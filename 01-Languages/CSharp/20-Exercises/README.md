# 20 — Exercises

[Back to course overview](../README.md) | [Previous: Best Practices](../19-Best-Practices/README.md)

Seven standalone practice problems spanning the whole course, roughly ordered from easier to harder. Each is self-contained — you don't need to solve them in order, but earlier ones lean on earlier lessons only, while later ones combine several topics. These are deliberately different problems from the `Exercises/` folders already inside Lessons 05, 06, and 07 — solve those first if you haven't, then come back here for problems that pull in records, LINQ, pattern matching, generics, nullable reference types, and async.

Attempt each problem yourself in a scratch `.cs` file before looking at [21-Solutions](../21-Solutions/README.md). Solutions are numbered to match (`exercise-01` &harr; `solution-01.cs`).

## Exercise 01 — Records vs. Classes (Beginner)

**Lessons used:** OOP (11)

Define an immutable `record Point3D(double X, double Y, double Z)` and a mutable `class MutablePoint3D` with the same three properties (`X`, `Y`, `Z`) plus a settable method `Translate(double dx, double dy, double dz)`.

- Show that two `Point3D` records built from identical coordinates compare equal with `==` (value equality) and print the same auto-generated `ToString()`.
- Show that two `MutablePoint3D` instances built from identical coordinates do **not** compare equal with `==` (reference equality) unless you explicitly override it.
- Add a `with` expression that produces a new `Point3D` with only `Z` changed, and prove the original is untouched.

## Exercise 02 — Pattern Matching Shape Calculator (Beginner/Intermediate)

**Lessons used:** Control Flow (05), OOP (11)

Define a `record` hierarchy (or a discriminated set of types) for shapes: `Circle(double Radius)`, `Rectangle(double Width, double Height)`, `Triangle(double Base, double Height)`. Write a function `double Area(object shape)` that uses a **switch expression with type patterns and property patterns** (not a chain of `if`/`is`) to compute area, including:
- a guard clause (`when`) that treats a `Rectangle` with `Width == Height` as a "square" and prints a different message before returning the same area formula
- a discard pattern (`_`) that throws a custom exception (see Exercise 04's pattern) for any unrecognized shape

## Exercise 03 — LINQ Sales Report (Intermediate)

**Lessons used:** Collections (07), Functional Concepts (12)

Given a `record Sale(string Product, string Region, decimal Amount)` and a hardcoded `List<Sale>` of at least 10 entries across 3+ products and 2+ regions, use LINQ method syntax (no manual loops) to produce:
- total revenue per product, sorted descending by revenue (`GroupBy` + `Sum` + `OrderByDescending`)
- the single highest-value sale (`OrderByDescending(...).First()` or `MaxBy`)
- the set of distinct regions that sold more than one product (`GroupBy` + `Where` + `Select`)
- the average sale amount, formatted to 2 decimal places

## Exercise 04 — Custom Exception + Nullable Reference Types (Intermediate)

**Lessons used:** Error Handling (09), Variables and Data Types (03)

With `<Nullable>enable</Nullable>` in effect, define a class `UserProfile` with:
- `string Username` (never null — validated in the constructor)
- `string? Bio` (optional — may be null)
- a constructor that throws a custom `InvalidUsernameException : Exception` if `Username` is null, empty, or whitespace-only
- a method `string DisplayBio()` that returns `Bio` if set, or `"No bio provided"` if `Bio` is `null`, using the null-coalescing operator (`??`) — not an `if` statement

Demonstrate: one profile built successfully with a bio, one built successfully with `Bio: null` (confirm `DisplayBio()` falls back correctly), and one construction attempt with an empty username caught via `try`/`catch`, printing the exception message.

## Exercise 05 — Generic `Result<T>` Type (Advanced)

**Lessons used:** Generics (13), Pattern Matching (05)

Model the "railway-oriented" `Result<T>` pattern (similar to Rust's `Result` or F#'s) as a generic type in C#:
- `readonly record struct Result<T>` (or a sealed class hierarchy — your choice, document why) with a way to represent success (carrying a `T` value) or failure (carrying a `string` error message), without using exceptions for control flow
- a static factory `Result<T>.Success(T value)` and `Result<T>.Failure(string error)`
- a method `Match<TOut>(Func<T, TOut> onSuccess, Func<string, TOut> onFailure)` that pattern-matches internally and calls the right delegate

Use it to implement `Result<int> ParseAge(string input)` (fails if not a valid non-negative integer) and call `Match` on both a valid and an invalid input to print different messages.

## Exercise 06 — Concurrent Downloads Simulation (Advanced)

**Lessons used:** Async and Concurrency (14), Error Handling (09)

Write an `async Task<string> FetchAsync(string url, int delayMs, bool shouldFail)` that simulates a network call with `await Task.Delay(delayMs)`, then either returns `$"{url} -> 200 OK"` or throws a custom `FetchFailedException` if `shouldFail` is `true`.

Using `Task.WhenAll`, kick off at least 4 simulated fetches concurrently (mixed delays, at least one `shouldFail: true`), and:
- measure and print total elapsed wall-clock time, proving it's close to the *slowest single* delay, not the *sum* of all delays (proving they ran concurrently, not sequentially)
- handle the fact that `Task.WhenAll` only surfaces the *first* exception by re-inspecting each individual `Task`'s `Exception`/`IsFaulted` state afterward so no failure is silently swallowed

## Exercise 07 — JSON Roundtrip with LINQ Filtering (Advanced)

**Lessons used:** File Handling (10), Collections/LINQ (07, 12)

Define `record Book(string Title, string Author, int Year, double Rating)`. Write a program that:
- builds a `List<Book>` of at least 6 books
- serializes it to a temporary JSON file using `System.Text.Json` (`JsonSerializer.Serialize`, indented)
- reads the file back and deserializes it into a new `List<Book>`
- uses LINQ on the deserialized list to print books published after 2015 with a rating &ge; 4.0, sorted by rating descending
- deletes the temporary file at the end, and confirms (via `File.Exists`) that cleanup succeeded

## Suggested Next Lesson

[21 — Solutions](../21-Solutions/README.md) — but only after you've attempted each exercise yourself.
