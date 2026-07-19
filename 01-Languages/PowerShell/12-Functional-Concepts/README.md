# 12 - Functional Concepts

[Back to course overview](../README.md) | Previous: [11 - Classes and OOP](../11-Classes-and-OOP/README.md) | Next: [13 - Generics](../13-Generics/README.md)

## What / Why / Where

Script blocks (`{ }`) are first-class values in PowerShell - they can be stored in
variables, passed as parameters, and invoked with `&` or `.Invoke()`. Combined with
`Where-Object`/`ForEach-Object`/`Sort-Object`, this enables genuine functional-style
composition.

## Verified Live: A Real Bug Found While Building This Lesson

A stored predicate written as `{ param($n) $n % 2 -eq 0 }` and passed to
`Where-Object $isEvenArg` **silently passed every item through**, instead of filtering to
evens - because `Where-Object` binds the current pipeline item to `$_`, not to a script
block's own `param()` names. With `$n` unbound (`$null`), `$null % 2 -eq 0` evaluates to
`True` for everything, with no error at all. The fix: predicates used with
`Where-Object`/`ForEach-Object` must reference `$_`, confirmed live to correctly filter
`1..10` down to `2,4,6,8,10` once fixed.

## Advantages / Disadvantages

- Advantage: script blocks as first-class values make higher-order functions (`Invoke-NTimes -Action { ... }`) natural to write.
- Advantage: `Where-Object`/`ForEach-Object`/`Sort-Object` compose cleanly for filter/map/sort pipelines.
- Disadvantage: the `$_`-vs-`param()` binding difference (documented above) is a genuine, silent-failure-prone gotcha specific to how `Where-Object`/`ForEach-Object` invoke script blocks.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Writing a predicate with `param($n)` and expecting `Where-Object`/`ForEach-Object` to bind it - they bind `$_`, not named parameters, verified live to fail silently rather than error.
- Not realizing a script block's `.GetType()` is `System.Management.Automation.ScriptBlock`, a real, storable, invokable object.
- Overusing script blocks where a named function would be clearer for anything reused more than once or twice.

## Best Practices

- Always use `$_` in predicates meant for `Where-Object`/`ForEach-Object`, never a custom `param()` name.
- Store frequently-reused predicates in a variable with a clear name (`$isEven`) for readability.
- Prefer named functions over script blocks for anything beyond a short, one-off predicate.

## Detailed Example

See [demo.ps1](demo.ps1) - the gotcha above, and its fix, were both captured from real runs. See also [Exercises](Exercises/README.md) and [Solutions](Solutions/solution.ps1).

## Interview Questions

1. **Are script blocks first-class values in PowerShell?** Yes - verified live: `{ }.GetType().FullName` returns `System.Management.Automation.ScriptBlock`, and the same script block was invoked two different ways (`& $block`, `$block.Invoke()`).
2. **What real bug can occur when passing a script block with `param()` to `Where-Object`?** `Where-Object` binds the pipeline item to `$_`, not to the block's own parameter names - verified live: a `param($n)`-based predicate silently passed every single item through the filter (since unbound `$n` was `$null`, and `$null % 2 -eq 0` is `True`), with no error raised at all.

## Recommended Next Lesson

[13 - Generics](../13-Generics/README.md)
