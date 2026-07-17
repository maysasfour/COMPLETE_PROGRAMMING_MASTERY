# 21 — Solutions

[Back to course overview](../README.md) | [Exercises](../20-Exercises/README.md)

Runnable solutions for every problem in [20-Exercises](../20-Exercises/README.md). Each `solution-0N.cs` matches Exercise N and is a file-based app — run it with `dotnet run solution-0N.cs` directly from this folder, no `.csproj` needed. All seven have been actually compiled and executed against .NET 10 (`dotnet --version` &rarr; `10.0.302`) — the "Verified output" blocks below are pasted straight from the terminal, not predicted.

## Solution 01 — Records vs. Classes

```
--- record value equality ---
p1 == p2 : True
p1.ToString() (auto-generated): Point3D { X = 1, Y = 2, Z = 3 }

--- class reference equality ---
m1 == m2 : False
m1 after Translate(1,1,1): (2, 3, 4)

--- 'with' expression (non-destructive mutation) ---
p3 (Z changed): Point3D { X = 1, Y = 2, Z = 99 }
p1 (unchanged, proving 'with' does not mutate the source): Point3D { X = 1, Y = 2, Z = 3 }
```

`record` auto-generates `Equals`, `GetHashCode`, `==`/`!=`, and `ToString()` based on the values of its properties; a plain `class` gets none of that for free, so `m1 == m2` compares references (different objects) and is `False` even though the coordinates match. `with` copies every property except the ones listed, producing a new instance — the original `p1` is never touched.

## Solution 02 — Pattern Matching Shape Calculator

```
--- switch expression with type + property patterns ---
Circle(3): 28.27
Rectangle(4,5): 20.00
  (detected a square: 4x4)
Rectangle(4,4) (square guard): 16.00
Triangle(6,2): 6.00
Caught expected error: Unrecognized shape: not a shape
```

Positional patterns like `Circle(var r)` deconstruct a record in the switch arm itself (records get a compiler-generated `Deconstruct` for free); the `when w == h` guard on the `Rectangle` property pattern only matches *before* the plain `Rectangle(var w, var h)` arm below it, since switch expression arms are evaluated top-to-bottom and the first match wins — order is significant, exactly like `if`/`else if` chains.

## Solution 03 — LINQ Sales Report

```
--- total revenue per product (descending) ---
  Gizmo: AED525.00
  Gadget: AED410.00
  Widget: AED365.00

--- highest-value single sale ---
  Gizmo in North: AED500.00

--- regions selling more than one distinct product ---
  North
  South
  East

--- average sale amount ---
  130.00
```

**Gotcha found while verifying:** `{total:C}` (the `C` currency format specifier) renders using the machine's current culture, not a fixed currency — on the machine this course was built on, that's `AED` (UAE dirham), not `$`. This is real, observed .NET behavior, not a typo: `:C` is locale-sensitive by design, and code that assumes it always prints `$` will silently render wrong on a machine with a different `CurrentCulture`. Production code that must show a specific currency regardless of locale should pass an explicit `CultureInfo` (e.g. `total.ToString("C", CultureInfo.GetCultureInfo("en-US"))`) instead of relying on the ambient default.

`GroupBy(s => s.Product)` produces one `IGrouping<string, Sale>` per distinct product; `g.Sum(s => s.Amount)` reduces each group to a total, and `MaxBy` (added in .NET 6) picks the single largest element by a key selector without a separate sort.

## Solution 04 — Custom Exception + Nullable Reference Types

```
withBio.DisplayBio(): Mathematician and programmer.
noBio.DisplayBio(): No bio provided
Caught expected error: Username cannot be null, empty, or whitespace.
```

File-based apps default `Nullable` to `disable`, so `#:property Nullable=enable` at the top of the file is required to get the same nullability warnings a `.csproj`-based project has by default — confirmed by temporarily assigning a `string?` to a `string` with the directive present, which produced `warning CS8600: Converting null literal or possible null value to non-nullable type` as expected, and produced no warning at all with the directive removed. `??` only substitutes on `null`, not on falsy-but-non-null values, which is why an explicitly empty (but non-null) bio would print as-is rather than falling back to the default message.

## Solution 05 — Generic `Result<T>` Type

```
--- Result<T> without exceptions for control flow ---
Parsed age: 42
Failed: 'not a number' is not a valid integer.
Failed: Age cannot be negative: -5.
```

`Result<T>` is a `readonly record struct` rather than a class hierarchy — no heap allocation per result, and record-generated equality means two identical `Success` results compare equal, which is convenient in tests. `Match` forces both the success and failure paths to be handled at the call site (the compiler requires both delegate arguments), giving the same "you can't forget the error case" discipline as a `try`/`catch`, but visible directly in the return type instead of hidden in control flow.

## Solution 06 — Concurrent Downloads Simulation

```
Elapsed: 517ms (slowest single delay was 500ms -- proves concurrency, not a ~1400ms sum)

--- per-task results ---
  OK: https://api.example.com/users -> 200 OK (300ms)
  OK: https://api.example.com/orders -> 200 OK (500ms)
  FAILED: https://api.example.com/broken -> request failed after 200ms
  OK: https://api.example.com/products -> 200 OK (400ms)
```

Elapsed time (517ms) tracks the slowest individual delay (500ms) plus a small scheduling overhead, not the sum of all four delays (300+500+200+400 = 1400ms) — direct proof the tasks ran concurrently. `Task.WhenAll` only rethrows the *first* task's exception from the `await`, so relying on that alone would hide any other failures; re-inspecting `task.IsFaulted`/`task.Exception` for every task afterward is what actually surfaces all of them (here, just the one `FetchFailedException`, unwrapped from the `AggregateException` `Task.Exception` always wraps faults in).

## Solution 07 — JSON Roundtrip with LINQ Filtering

```
--- serializing 6 books to C:\Users\HP\AppData\Local\Temp\tmpfm4bdq.tmp ---

--- reading back and deserializing ---
Deserialized 6 books.

--- books after 2015 with rating >= 4.0, sorted by rating desc ---
  Atomic Habits (2018) by James Clear -- 4.8
  C# in Depth (2019) by Jon Skeet -- 4.7
  Deep Work (2016) by Cal Newport -- 4.3

Cleanup check -- file still exists: False
```

**Gotcha found while verifying:** the first run of this solution threw `System.InvalidOperationException: Reflection-based serialization has been disabled for this application` at runtime — it compiled cleanly and only failed when executed. File-based apps in .NET 10 disable reflection-based `System.Text.Json` serialization by default (tuned for trimming/AOT publish scenarios), so `JsonSerializer.Serialize(books, ...)` needs `AppContext.SetSwitch("System.Text.Json.JsonSerializer.IsReflectionEnabledByDefault", true)` first. Lesson 10's `example.cs` hits this same quirk — this solution follows the same fix rather than introducing a second pattern. The IL2026/IL3050 trim-safety warnings shown above are expected noise from the reflection-based overload and don't affect correctness for a non-trimmed, non-AOT console run.

## Suggested Next Lesson

[22 — Mini Projects](../22-Mini-Projects/README.md)
