# 20 - Exercises

[Back to course overview](../README.md) | Previous: [19 - Best Practices](../19-Best-Practices/README.md) | Next: [21 - Solutions](../21-Solutions/README.md)

Course-spanning exercises. Matching, fully-run solutions are in [21-Solutions](../21-Solutions/README.md).

1. **Case-sensitive role check.** Write a function `Test-RoleAccess` that takes a role string and grants access only for an exact-case match of `"admin"`, using `-ceq` (see [04-Operators](../04-Operators/README.md)).
2. **Object pipeline report.** Build an array of `[PSCustomObject]` "employee" records (`Name`, `Department`, `Salary`) and produce a `Group-Object`-based summary of average salary per department, using `Measure-Object`.
3. **Safe file reader.** Write a function that reads a file's content with `try/catch`, using `-ErrorAction Stop`, and returns a clear custom message (not a raw stack trace) if the file doesn't exist.
4. **A real class.** Write a `class Book` with `Title`/`Author`/`IsCheckedOut`, and methods `CheckOut()`/`Return()` that throw if called in the wrong state (e.g. checking out an already-checked-out book).
5. **Generic inventory.** Use `[System.Collections.Generic.Dictionary[string,int]]` to track an inventory of item-name -> quantity, with functions to add stock and remove stock (throwing if it would go negative).
6. **JSON round-trip.** Write a function that serializes an array of custom objects to a JSON file and a second function that reads it back, verifying (with a real comparison) that the reloaded data matches the original.
7. **Higher-order retry.** Write a function `Invoke-WithRetry` that takes a `[scriptblock]` and a retry count, and re-invokes the block on failure up to that many times before giving up, using `try/catch`.
8. **Pester coverage.** Write Pester tests (`Should Be`/`Should Throw`) for the `Book` class from exercise 4, covering both the happy path and the error path.
