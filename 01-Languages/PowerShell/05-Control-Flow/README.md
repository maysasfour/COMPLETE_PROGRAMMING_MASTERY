# 05 - Control Flow

[Back to course overview](../README.md) | Previous: [04 - Operators](../04-Operators/README.md) | Next: [06 - Functions](../06-Functions/README.md)

## What / Why / Where

`if`/`elseif`/`else`, `foreach`/`while`/`for` behave much like other C-family languages. The
standout is PowerShell's `switch` statement, which is genuinely more powerful than most
languages' switch: it supports wildcard matching, regex matching, and arbitrary script-block
conditions per case - and, unless you use `break`, it falls through to test **every** case,
not just the first match.

## Verified Live: `switch` Modes

```
switch -Wildcard ($file) { "*.txt" { ... } }     -> report.txt -> text file
switch -Regex ($input1)  { '^user-\d+$' { ... } } -> user-42 -> matches a user id pattern
switch ($n) { { $_ % 2 -eq 0 } { ... } }          -> 17 is odd
```

## Verified Live: Fallthrough Without `break`

```powershell
switch (2) {
    1 { "matched 1" }
    2 { "matched 2" }
    { $_ -lt 5 } { "matched 'less than 5' too" }
}
```
outputs **both** `matched 2` and `matched 'less than 5' too` - a real, distinctive contrast
with C-style switch statements, which only match once by default.

## Advantages / Disadvantages

- Advantage: one `switch` statement covers exact-match, wildcard, regex, and predicate logic - no separate `if`/`elseif` chain needed.
- Advantage: `foreach`/`while`/`for` are immediately familiar to anyone from a C-family language.
- Disadvantage: the fallthrough-by-default behavior of `switch` is a real, documented gotcha if you expect C-style single-match semantics.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Forgetting `break` inside a `switch` case and being surprised when multiple cases match the same input.
- Using `-Wildcard`/`-Regex` inconsistently - the default `switch` (no flag) does exact/type-based matching only.
- Writing script-block switch cases without realizing `$_` refers to the value being switched on.

## Best Practices

- Add `break` explicitly in each `switch` case unless you deliberately want fallthrough.
- Prefer `switch -Regex` over a chain of `-match` `if`/`elseif` for multi-pattern string classification.

## Detailed Example

See [demo.ps1](demo.ps1); [Exercises](Exercises/README.md) and [Solutions](Solutions/solution.ps1) for hands-on practice, run for real (FizzBuzz via script-block switch, a running-total `while` loop, and a demonstrated fallthrough case).

## Interview Questions

1. **How is PowerShell's `switch` more powerful than a typical C-style switch?** It supports `-Wildcard` and `-Regex` matching modes and arbitrary script-block predicate conditions per case, verified live matching a filename against `*.txt`, a string against a regex user-id pattern, and a number against an even/odd script-block condition.
2. **Does PowerShell's `switch` fall through to later cases by default?** Yes - verified live: `switch (2) { 1{} 2{} {$_ -lt 5}{} }` matched both case `2` and the script-block case, since neither used `break`.

## Recommended Next Lesson

[06 - Functions](../06-Functions/README.md)
