# Solution 01 — A `TrySplitName` Method with `out`

[Back to exercise](../Exercises/exercise-01.md)

## Explanation

- `fullName.Split(' ')` splits on spaces; checking `parts.Length != 2` catches both zero-space names (`"Madonna"`) and multi-space names (`"Mary Jane Watson"`) as failures, matching the exercise's "exactly one space" requirement.
- Both `out` parameters are assigned in **every** code path, including the failure path (`""`/`""`) — required by the compiler, since `out` parameters must be definitely assigned before the method returns on every branch.
- No exception is thrown for a malformed name; `false` communicates failure through the return value, matching the `TryParse` convention this lesson covers.

## Verification

Ran with `dotnet run Solutions/solution-01.cs`; actual output:

```
Ada / Lovelace
Split failed as expected
```

Matches the exercise's expected output exactly.
