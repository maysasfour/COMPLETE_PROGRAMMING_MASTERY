# 07 - The Object Pipeline

[Back to course overview](../README.md) | Previous: [06 - Functions](../06-Functions/README.md) | Next: [08 - Strings](../08-Strings/README.md)

## What / Why / Where

This is PowerShell's single most distinctive feature, already introduced briefly in the
prerequisite lesson
[19-Command-Line-and-Operating-Systems/02-PowerShell-Basics](../../19-Command-Line-and-Operating-Systems/02-PowerShell-Basics/README.md):
the pipeline passes **real .NET objects** between cmdlets, not text. This lesson goes
further with `Get-Process`, `Get-Member`, and multi-stage real-world pipelines.

## Verified Live

```powershell
Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 3 -Property Name, Id, ...
```
returned real process objects, sorted by the genuine `Int64` `WorkingSet64` property - no
text parsing anywhere. `Get-Member` on a piped process object shows real properties/methods
(`BasePriority`, `ExitCode`, etc.) - proof it's a genuine `System.Diagnostics.Process`
instance, not a formatted string, confirmed via `.GetType().FullName`.

## Contrast with Bash

In Bash, the equivalent (`ps aux | sort -k4 -n | head -3`) parses column-aligned **text**.
Here, sorting happens on a real numeric property the entire way through - no risk of a
column-width or locale change silently breaking the sort.

## Advantages / Disadvantages

- Advantage: filtering/sorting/projecting operates on real typed properties, eliminating a huge class of shell-scripting bugs.
- Advantage: `Get-Member` gives you a full, live introspection of anything flowing through the pipeline.
- Disadvantage: pipeline objects can be heavier than plain text for very large datasets, and cross-machine/remote scenarios (unlike text) require serialization considerations.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Converting pipeline objects to strings (`Out-String`) too early, then trying to filter/sort the resulting text - discarding exactly the structure PowerShell provides for free.
- Not using `Get-Member` to discover what's actually available on an object before writing `Where-Object`/`Select-Object` logic against it.
- Assuming `Format-Table`'s output is still usable data - it isn't; formatting cmdlets are for display only, always last in a pipeline.

## Best Practices

- Filter and sort using `Where-Object`/`Sort-Object`/`Select-Object` on real properties, never on formatted text.
- Use `Get-Member` liberally when working with an unfamiliar object type.
- Keep `Format-*` cmdlets as the very last step in a pipeline - never pipe their output into more processing.

## Detailed Example

See [demo.ps1](demo.ps1); [Exercises](Exercises/README.md) and [Solutions](Solutions/solution.ps1), including `Group-Object`, `Measure-Object`, and a live proof that a piped string is a real `System.String` object.

## Interview Questions

1. **What is the single biggest architectural difference between PowerShell's pipeline and Bash's?** PowerShell passes real, typed .NET objects between commands; Bash passes plain text - verified live sorting real `Process` objects by the genuine numeric `WorkingSet64` property, with no text parsing involved.
2. **How do you discover what properties/methods an object flowing through the pipeline actually has?** `Get-Member` - verified live on a piped `Get-Process` object and on a piped string, both showing real, inspectable members.

## Recommended Next Lesson

[08 - Strings](../08-Strings/README.md)
