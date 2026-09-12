# 21 - Solutions

[Back to course overview](../README.md) | [Previous: Exercises](../20-Exercises/README.md)

Worked, verified solutions to all eight [20-Exercises](../20-Exercises/README.md) problems.
Each `.ps1`/`.Tests.ps1` file was actually run with Windows PowerShell 5.1 (`powershell -File`,
per [01-Setup](../01-Setup/README.md) - `pwsh`/PowerShell 7+ is not present in this
environment); the captured output below is real, copied from those runs, not hand-computed.

## Solution 1 - Case-Sensitive Role Check

[solution-01.ps1](solution-01.ps1)

```
admin -> GRANTED
Admin -> DENIED
ADMIN -> DENIED
```

`-ceq` forces case-sensitive comparison; PowerShell's default `-eq` is case-*insensitive*,
a common surprise for anyone coming from a case-sensitive language.

## Solution 2 - Object Pipeline Report

[solution-02.ps1](solution-02.ps1)

```
Eng: avg salary = 92,500
Sales: avg salary = 72,500
```

`Group-Object -Property Department` buckets the `[PSCustomObject]` records; each bucket's
`.Group` is fed to `Measure-Object -Average` to compute the per-department average.

## Solution 3 - Safe File Reader

[solution-03.ps1](solution-03.ps1)

```
Could not read 'C:\definitely-not-real-xyz.txt': file does not exist.
real content
```

`Get-Content -ErrorAction Stop` is required - without it, a missing-file error from
`Get-Content` is a *non-terminating* error by default and will not be caught by `try/catch`
at all. Run against both a genuinely missing path and a real temp file created for this run.

## Solution 4 - A Real Class: Book

[solution-04.ps1](solution-04.ps1)

```
Checked out: Dune, IsCheckedOut=True
Caught: 'Dune' is already checked out.
Returned: IsCheckedOut=False
Caught: 'Dune' was not checked out.
```

**Genuine bug found and fixed while building this solution:** the first draft named the
return method `Return()`. PowerShell classes fail to *parse* that at all -  `Return` is a
reserved language keyword, and using it as a method name produces a real parse-time error,
reproduced here with a minimal repro:

```
class Foo { [void]Return() { Write-Output "ok" } }
```
```
Missing a property name or method definition.
Missing closing '}' in statement block or type definition.
An expression was expected after '('.
Unexpected token '{' in expression or statement.
```

This is not a runtime exception - it stops the entire script from loading. Fixed by naming
the method `ReturnBook()` instead (also corrected in
[20-Exercises/README.md](../20-Exercises/README.md), whose problem 4 originally specified
`Return()`). The class is defined at script scope (no wrapping function) so
[solution-08.Tests.ps1](solution-08.Tests.ps1) can dot-source this exact file and reuse the
class directly for Pester coverage - a top-level `if ($MyInvocation.InvocationName -ne '.')`
guard keeps this file's own demo/output block from re-running when it's dot-sourced that way.

## Solution 5 - Generic Inventory

[solution-05.ps1](solution-05.ps1)

```
widgets in stock: 6
Caught: Not enough stock of 'widgets' to remove 100.
Caught: Not enough stock of 'gadgets' to remove 1.
```

`[System.Collections.Generic.Dictionary[string,int]]` is a real .NET generic type - unlike a
plain `@{}` hashtable, the value type (`int`) is enforced by the CLR, not just convention.
Both the insufficient-stock and unknown-item error paths are exercised.

## Solution 6 - JSON Round-Trip

[solution-06.ps1](solution-06.ps1)

```
Reloaded: 1=A, 2=B
Round-trip matches original: True
```

`ConvertTo-Json`/`ConvertFrom-Json` are PowerShell's built-in serializer pair. The
verification is a genuine field-by-field comparison of the reloaded objects against the
originals (`Id` and `Name` on every element), not just "the file was written without error."

## Solution 7 - Higher-Order Retry

[solution-07.ps1](solution-07.ps1)

```
Attempt 1 failed: not ready yet (try 1)
Attempt 2 failed: not ready yet (try 2)
Final result: succeeded on try 3
Attempt 1 failed: permanent failure
Attempt 2 failed: permanent failure
Gave up after retries, final error: permanent failure
```

`Invoke-WithRetry` takes a `[scriptblock]` as ordinary data and invokes it with the `&` call
operator - `&` is required to actually *execute* a scriptblock stored in a variable, rather
than just returning the scriptblock object itself. Both the eventual-success path (fails
twice, then a controlled counter lets it succeed on the 3rd attempt) and the give-up path (a
block that always fails re-throws once `MaxAttempts` is exhausted) are verified live.

## Solution 8 - Pester Coverage for Book

[solution-08.Tests.ps1](solution-08.Tests.ps1)

Run with Pester 3.4.0 (the version genuinely installed in this environment -
`Get-Module -ListAvailable Pester` confirmed it; Pester 3's legacy `Should Be`/`Should Throw`
syntax is used throughout, matching what [18-Testing](../18-Testing/README.md) already
established for this course, rather than the newer `Should -Be` syntax from Pester 5+):

```powershell
Invoke-Pester -Script '.\solution-08.Tests.ps1'
```

```
Describing Book
 [+] starts not checked out 1.28s
 [+] can be checked out 243ms
 [+] throws when checking out an already-checked-out book 140ms
 [+] can be returned after being checked out 67ms
 [+] throws when returning a book that was never checked out 109ms
Tests completed in 1.84s
Passed: 5 Failed: 0 Skipped: 0 Pending: 0 Inconclusive: 0
```

All 5 tests pass: the happy path (starts unchecked-out, checks out, returns) and both error
paths (double check-out, returning a book never checked out) from exercise 4's `Book` class.

## Run Them All

```powershell
cd 01-Languages\PowerShell\21-Solutions
Get-ChildItem solution-*.ps1 | ForEach-Object { Write-Output "=== $($_.Name) ==="; powershell -NoProfile -ExecutionPolicy Bypass -File $_.FullName }
Invoke-Pester -Script '.\solution-08.Tests.ps1'
```

## Recommended Next Lesson

[22 - Mini-Projects](../22-Mini-Projects/README.md)
