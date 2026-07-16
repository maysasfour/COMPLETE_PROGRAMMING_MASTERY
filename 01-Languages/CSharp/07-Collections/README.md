# 07 — Collections

[Back to course overview](../README.md) | [Previous: Functions](../06-Functions/README.md)

## Learning Objectives

- Use arrays, `List<T>`, and `Dictionary<K,V>`.
- Use LINQ (`Where`, `Select`, `OrderBy`, `Sum`) for collection transformations.
- Use collection expressions and object/collection initializers.

## Prerequisites

[06-Functions](../06-Functions/README.md)

## Concept

C#'s core generic collections are `T[]` (fixed-size arrays), `List<T>` (a resizable array, the everyday default), and `Dictionary<TKey, TValue>` (a hash map). **LINQ** (Language Integrated Query) provides a rich, chainable set of extension methods — `Where`, `Select`, `OrderBy`, `Sum`, and dozens more — directly analogous to JavaScript's `filter`/`map`/`sort`/`reduce`, but available on any `IEnumerable<T>`, including custom types, not just arrays.

## Arrays, `List<T>`, `Dictionary<K,V>`

```csharp
int[] numbers = { 1, 2, 3, 4, 5 }; // fixed size
var scores = new List<int> { 95, 88, 76 }; // resizable
scores.Add(100);

var ages = new Dictionary<string, int> {
    ["Ada"] = 30,
    ["Lin"] = 28,
};
Console.WriteLine(ages["Ada"]);
Console.WriteLine(ages.TryGetValue("Unknown", out int age) ? age.ToString() : "not found");
```

## LINQ

```csharp
var numbers = new List<int> { 1, 2, 3, 4, 5 };

var doubled = numbers.Select(n => n * 2).ToList();          // like .map()
var evens = numbers.Where(n => n % 2 == 0).ToList();          // like .filter()
int total = numbers.Sum();                                    // like .reduce() for a sum
int firstOver3 = numbers.First(n => n > 3);                    // first match, throws if none
bool hasEven = numbers.Any(n => n % 2 == 0);                    // like .some()
bool allPositive = numbers.All(n => n > 0);                     // like .every()
var sorted = numbers.OrderByDescending(n => n).ToList();
```

LINQ methods are **lazily evaluated** by default (an `IEnumerable<T>` query isn't actually executed until enumerated, e.g. via `.ToList()`, `foreach`, or another terminal operation) and, like JavaScript's array methods, never mutate the original collection — each returns a new sequence/value.

## Detailed Example

See [example.cs](example.cs).

## Expected Output

Running `dotnet run example.cs` prints array/list/dictionary usage (including `TryGetValue`'s safe lookup pattern) and a set of LINQ transformations mirroring the JavaScript/TypeScript courses' `map`/`filter`/`reduce` examples.

## Common Mistakes

- Using `ages["Unknown"]` directly instead of `TryGetValue` when a key might not exist — throws `KeyNotFoundException` instead of returning a safe default.
- Forgetting LINQ queries are lazy — iterating the same un-materialized query twice re-runs the underlying computation each time; call `.ToList()`/`.ToArray()` once if the result will be used more than once or the source might change between iterations.
- Confusing `First()` (throws if no match) with `FirstOrDefault()` (returns the type's default, e.g. `0` or `null`, if no match) — a very common source of unexpected exceptions.

## Best Practices

- Use `TryGetValue` for dictionary lookups where a missing key is a plausible outcome, not an error.
- Prefer LINQ method chains for data transformation over manual loops, mirroring the array-method idiom from the JavaScript/TypeScript courses.
- Materialize (`.ToList()`) a LINQ query once if you'll enumerate it multiple times, to avoid redundant re-computation.

## Real-World Usage

LINQ is used pervasively throughout C# codebases for querying in-memory collections and — via Entity Framework Core's LINQ provider — for building actual SQL queries from the same syntax, letting the same mental model (`Where`/`Select`/`OrderBy`) apply whether the data is in memory or in a database.

## Summary

- `T[]` is fixed-size; `List<T>` is the everyday resizable collection; `Dictionary<K,V>` is the hash map.
- LINQ (`Where`/`Select`/`OrderBy`/`Sum`/etc.) mirrors JavaScript's array methods, is lazily evaluated, and never mutates the source.
- `TryGetValue` is the safe dictionary-lookup pattern, avoiding `KeyNotFoundException`.

## Key Terms

- **LINQ (Language Integrated Query)** — a set of extension methods for querying/transforming any `IEnumerable<T>`.
- **Lazy evaluation** — a LINQ query isn't executed until enumerated (e.g., via `.ToList()` or `foreach`).

## Exercises

See [Exercises/](Exercises/).

## Solutions

See [Solutions/](Solutions/).

## Interview Questions

1. **What's the difference between `First()` and `FirstOrDefault()` in LINQ?**
   `First()` throws `InvalidOperationException` if no element matches the predicate (or the sequence is empty). `FirstOrDefault()` returns the type's default value (`0` for `int`, `null` for reference types) instead of throwing, making it the safer choice whenever "no match" is a plausible, non-exceptional outcome.

2. **Why is LINQ described as "lazily evaluated"?**
   Most LINQ operators (like `Where`/`Select`) build up a query description without actually running it — the underlying enumeration only happens when the result is materialized, such as by calling `.ToList()`, iterating with `foreach`, or calling another terminal operation like `.Sum()`. This means the same un-materialized query can re-execute its full logic every time it's enumerated, which matters if the source data can change between enumerations or if the computation is expensive.

## Recommended Next Lesson

[08 — Strings](../08-Strings/README.md)
