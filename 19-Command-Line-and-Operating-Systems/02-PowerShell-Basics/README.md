# 02 — PowerShell Basics

[Back to module overview](../README.md) | [Previous: Bash Basics](../01-Bash-Basics/README.md)

## Beginner: PowerShell Pipes Real Objects, Not Text

The single biggest conceptual difference between PowerShell and Bash ([Lesson 01](../01-Bash-Basics/README.md)): PowerShell's pipeline passes **real, structured objects** between commands, not plain text. This lesson demonstrates that directly, then reveals a real, reproducible security-relevant gotcha specific to PowerShell's default comparison behavior.

## Filtering Real Objects by a Real Property

```powershell
$files = @(
    [PSCustomObject]@{ Name = "report.txt"; SizeBytes = 250 }
    [PSCustomObject]@{ Name = "photo.png";  SizeBytes = 50000 }
    [PSCustomObject]@{ Name = "notes.txt";  SizeBytes = 80 }
)
$files | Where-Object { $_.SizeBytes -gt 100 } | Sort-Object SizeBytes -Descending
```

Verified live — filtering and sorting happen against the real, numeric `SizeBytes` **property**, not parsed text:

```
Name       SizeBytes
----       ---------
photo.png      50000
report.txt       250
```

In Bash, achieving the equivalent (filter by a numeric column, sort descending) typically means parsing `ls -l`'s text output with `awk`/`sort` — fragile, and dependent on exact column formatting. Here, `SizeBytes` is a real integer property on a real object the whole way through the pipeline.

## The Violation: A Real, Reproducible Authorization Bug

```powershell
function Test-AdminAccessViolation($role) {
    if ($role -eq "admin") { return "GRANTED" }
    return "DENIED"
}
```

Verified live:

```
Role 'admin' -> GRANTED
Role 'Admin' -> GRANTED   <- BUG: should NOT match if roles are meant to be case-sensitive!
Role 'ADMIN' -> GRANTED   <- BUG: same issue
Role 'user'  -> DENIED
```

PowerShell's `-eq` operator is **case-insensitive by default** — a genuine, real surprise for anyone coming from most other languages (Java, Python, JavaScript, Bash's `[ "$a" = "$b" ]`), where string equality is case-sensitive unless explicitly relaxed. If a real system checked a role string this way, `"Admin"` and `"ADMIN"` would be wrongly granted the same access as `"admin"`.

## The Fix: `-ceq`, the Explicit Case-Sensitive Operator

```powershell
function Test-AdminAccessFixed($role) {
    if ($role -ceq "admin") { return "GRANTED" }
    return "DENIED"
}
```

Verified live — the identical inputs are now handled correctly:

```
Role 'admin' -> GRANTED
Role 'Admin' -> DENIED   <- correct: case mismatch now correctly denied
Role 'ADMIN' -> DENIED   <- correct: case mismatch now correctly denied
Role 'user'  -> DENIED
```

## Detailed Example

See [demo.ps1](demo.ps1) — every command above, runnable end-to-end.

## Run It

```powershell
powershell -File demo.ps1
```

## Expected Output

Real, structured objects filtered/sorted by a real numeric property (not text); a real authorization check incorrectly granting access regardless of case using `-eq`; the same check correctly enforcing exact case using `-ceq`.

## Common Mistakes

- Assuming `-eq` in PowerShell behaves like case-sensitive equality in most other languages — verified live to actually be case-insensitive by default, a real, surprising gotcha for anyone checking sensitive values (roles, tokens, filenames) case-sensitively.
- Treating PowerShell's pipeline as text-based like Bash's — verified live that filtering/sorting operates on real object properties (`SizeBytes` as an integer), not parsed text columns.
- Not knowing the case-sensitive comparison operators exist (`-ceq`, `-cne`, `-clike`, etc.) — every comparison operator in PowerShell has both a case-insensitive default and an explicit case-sensitive (`c`-prefixed) and case-insensitive (`i`-prefixed, for clarity) variant.

## Best Practices

- Use `-ceq` (or other `c`-prefixed operators) explicitly whenever case sensitivity actually matters — never rely on the case-insensitive default for security-relevant or exact-match comparisons.
- Take advantage of PowerShell's object pipeline — filter and sort by real properties (`Where-Object`, `Sort-Object`, `Select-Object`) rather than converting to text and parsing it back, which discards exactly the structure PowerShell provides for free.
- Use `Get-Member` on any object to discover its real, available properties before writing filtering/sorting logic against it.

## Real-World Usage

PowerShell's object pipeline is precisely why it's the standard automation shell for Windows and Azure administration — piping real `Process`, `Service`, or cloud-resource objects between cmdlets, filtering and sorting by real properties, is dramatically more robust than Bash-style text parsing for the same tasks. The case-insensitive `-eq` gotcha demonstrated here is a genuine, documented source of real security bugs in PowerShell scripts that assume case-sensitive comparison without realizing the default.

## Summary

- PowerShell's pipeline was shown, live, to filter and sort real objects by a real numeric property, without any text parsing.
- `-eq`'s default case-insensitive behavior was shown, live, to incorrectly grant access for role strings differing only in case (`"Admin"`, `"ADMIN"`) — a real, reproducible authorization bug.
- `-ceq` was shown, live, to correctly enforce exact-case matching, fixing the identical scenario.

## Key Terms

- **Object pipeline** — PowerShell's core design: commands pass real, structured objects to each other, not plain text.
- **`-eq`/`-ceq`** — PowerShell's equality operators; `-eq` is case-insensitive by default, `-ceq` is explicitly case-sensitive.
- **`Where-Object`/`Sort-Object`/`Select-Object`** — core pipeline cmdlets for filtering, sorting, and projecting object properties.

## Interview Questions

1. **How does PowerShell's pipeline fundamentally differ from Bash's, and how was this demonstrated concretely?**
   Bash pipes plain text between commands — anything structured (like a file size) must be parsed back out of formatted text using tools like `awk` or `cut`. PowerShell instead pipes real, structured .NET objects, preserving properties and their actual types throughout the pipeline. This was demonstrated concretely: a collection of `PSCustomObject`s with a real integer `SizeBytes` property was filtered (`Where-Object { $_.SizeBytes -gt 100 }`) and sorted (`Sort-Object SizeBytes -Descending`) directly by that numeric property — no text parsing was involved at any step, verified by the correctly numerically-sorted output.

2. **Why did `-eq` incorrectly grant access for `"Admin"` and `"ADMIN"` when checking against `"admin"`, and how was this fixed?**
   PowerShell's `-eq` operator performs case-insensitive string comparison by default — a design choice that differs from most other languages' default string equality. This was verified live: a role-check function using `if ($role -eq "admin")` returned `"GRANTED"` for the inputs `"admin"`, `"Admin"`, and `"ADMIN"` alike, a real, reproducible authorization bug if case-sensitivity was intended. Switching to `-ceq` (PowerShell's explicit case-sensitive equality operator) fixed this precisely: the identical three inputs then correctly returned `"GRANTED"` only for the exact-case `"admin"`, with `"Admin"` and `"ADMIN"` both correctly denied.

## Recommended Next Lesson

[03 — File Permissions and Processes](../03-File-Permissions-and-Processes/README.md)
