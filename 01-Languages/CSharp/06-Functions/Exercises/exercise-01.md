# Exercise 01 — A `TrySplitName` Method with `out`

[Back to lesson](../README.md)

## Task

Write `bool TrySplitName(string fullName, out string first, out string last)` that splits a "First Last" string into two `out` parameters, returning `true` on success. It should return `false` (with both `out` parameters set to empty strings) if `fullName` doesn't contain exactly one space.

## Constraints

- Must use `out` parameters, following the `TryParse` convention.
- No exceptions thrown for a malformed name — return `false` instead.

## Starter Code

```csharp
bool TrySplitName(string fullName, out string first, out string last) {
    // your logic here
}

if (TrySplitName("Ada Lovelace", out var f, out var l)) {
    Console.WriteLine($"{f} / {l}");
}
if (!TrySplitName("Madonna", out var f2, out var l2)) {
    Console.WriteLine("Split failed as expected");
}
```

## Expected Output

```
Ada / Lovelace
Split failed as expected
```

## Solution

See [Solutions/solution-01.md](../Solutions/solution-01.md) and [Solutions/solution-01.cs](../Solutions/solution-01.cs).
