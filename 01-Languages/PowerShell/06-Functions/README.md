# 06 - Functions

[Back to course overview](../README.md) | Previous: [05 - Control Flow](../05-Control-Flow/README.md) | Next: [07 - The Object Pipeline](../07-The-Object-Pipeline/README.md)

## What / Why / Where

Functions are `function Verb-Noun { param() ... }`. Two things make PowerShell functions
genuinely distinctive: pipeline input support via `[Parameter(ValueFromPipeline=$true)]` and
a `process {}` block, and the **implicit return of every unassigned expression's value** -
not just the last line, and not only an explicit `return`.

## Verified Live: The Implicit-Return Gotcha

```powershell
function Get-SquareNoisy {
    param([int]$Number)
    "about to square $Number"   # <- this ALSO becomes output, not just a log line!
    $Number * $Number
}
```
Captured output has **2 items**: `"about to square 4"` and `16` - a real, reproducible trap
for anyone expecting a single "return value" like most other languages. Fixed by using
`Write-Verbose` for logging and `return` for the actual result, verified live to produce
exactly 1 captured item.

## Verified Live: Pipeline Input

```powershell
function Test-IsEven {
    param([Parameter(ValueFromPipeline = $true)][int]$Number)
    process { [PSCustomObject]@{ Number = $Number; IsEven = ($Number % 2 -eq 0) } }
}
1..5 | Test-IsEven
```
correctly emits one result object per pipeline item, because `process {}` runs once per item.

## Advantages / Disadvantages

- Advantage: pipeline-aware functions integrate with the rest of PowerShell's ecosystem for free.
- Advantage: no need for an explicit `return` for simple value-producing functions.
- Disadvantage: the implicit-return behavior is a genuine, well-documented source of bugs when a function has any bare expression statement meant only as a log/status line.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Writing a bare string as a "comment-like" status line inside a function, not realizing it leaks into the output stream.
- Forgetting the `process {}` block when writing a pipeline-input function, causing it to run only once (on the last pipeline item) instead of per-item.
- Using `param($n)` without matching the pipeline's `$_` binding expectations elsewhere (see the related gotcha documented live in [12-Functional-Concepts](../12-Functional-Concepts/README.md)).

## Best Practices

- Use `Write-Verbose`/`Write-Output` explicitly rather than relying on bare expressions for anything that isn't the intended return value.
- Always include a `process {}` block for any function meant to accept pipeline input per-item.
- Name functions with approved verbs (`Get-Verb`, see [19-Best-Practices](../19-Best-Practices/README.md)).

## Detailed Example

See [demo.ps1](demo.ps1); [Exercises](Exercises/README.md) and [Solutions](Solutions/solution.ps1), including a recursive `Get-Factorial`, a deliberately-buggy-then-fixed function, and a `Test-IsPalindrome` pipeline function, all run for real.

## Interview Questions

1. **What is PowerShell's "implicit return" gotcha, and how do you avoid it?** Every unassigned expression's value inside a function becomes part of its output - verified live: a function with a stray bare string mid-body returned 2 captured items instead of 1, fixed by switching the stray line to `Write-Verbose`.
2. **How does a function accept one pipeline item at a time?** Via `[Parameter(ValueFromPipeline=$true)]` on a parameter plus a `process {}` block, verified live piping `1..5` through `Test-IsEven` and getting 5 separate result objects.

## Recommended Next Lesson

[07 - The Object Pipeline](../07-The-Object-Pipeline/README.md)
