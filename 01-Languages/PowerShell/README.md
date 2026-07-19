# PowerShell

A full, from-scratch PowerShell course - .NET's object-oriented, cross-platform automation shell and scripting language, standard for Windows/Azure administration.

> **Prerequisite / related lesson**: this repo already has a focused, single-file lesson at
> [19-Command-Line-and-Operating-Systems/02-PowerShell-Basics](../../19-Command-Line-and-Operating-Systems/02-PowerShell-Basics/README.md)
> covering the object-pipeline-vs-Bash contrast and the `-eq` case-insensitivity gotcha. Read
> it first if you haven't - this course goes much deeper (functions, classes, error handling,
> generics, concurrency, testing, a full mini-project) and cross-references it rather than
> repeating it.

## What is PowerShell, and why does it exist?

PowerShell is a task-based command-line shell and scripting language built on .NET. Unlike
Bash or classic `cmd.exe`, its pipeline passes **real, structured .NET objects** between
commands rather than plain text - the single most distinctive design decision in the
language, covered in depth in [07-The-Object-Pipeline](07-The-Object-Pipeline/README.md).

## Where it's used

- Windows and Azure system administration and automation (the primary use case).
- DevOps/CI pipelines (Azure DevOps, GitHub Actions `pwsh` steps).
- Cross-platform scripting since PowerShell 6+/7+ ("PowerShell Core", built on .NET Core/.NET 5+).
- Desired State Configuration (DSC) for infrastructure-as-code on Windows.

## Advantages

- Deep, first-class access to the entire .NET class library from scripts.
- The object pipeline eliminates most text-parsing fragility common in shell scripting.
- Built-in JSON/XML/CSV support, a real `class` keyword, real .NET generics.
- Consistent `Verb-Noun` naming makes unfamiliar cmdlets guessable.

## Disadvantages

- Verbose compared to Bash/Python for one-off text-processing tasks.
- Windows PowerShell 5.1 (Desktop, .NET Framework) and PowerShell 7+ (Core, cross-platform)
  have real behavioral differences - see [01-Setup](01-Setup/README.md).
- Steeper learning curve for anyone coming from C-style comparison operators (`-eq` vs `==`).

## Install Instructions

- **Windows PowerShell 5.1**: preinstalled on Windows 10/11 (confirmed on this course's
  build machine: `$PSVersionTable.PSVersion` -> `5.1.22000.2538`, `PSEdition: Desktop`).
- **PowerShell 7+ ("pwsh")**: install separately from
  [github.com/PowerShell/PowerShell](https://github.com/PowerShell/PowerShell) or
  `winget install Microsoft.PowerShell`. **Not installed** on the machine this course was
  built and verified on (`where pwsh` found nothing) - every example here was run for real
  on Windows PowerShell 5.1, and this is noted explicitly wherever a 7+-only feature is discussed.

## How to Run Examples

Every lesson folder has a `demo.ps1` (or `example.ps1`). Run with:

```powershell
powershell -File demo.ps1
```

or, if you have PowerShell 7+ installed:

```powershell
pwsh -File demo.ps1
```

## Common Beginner Mistakes

- Using `==`, `!=`, `<`, `>` for comparisons instead of `-eq`, `-ne`, `-lt`, `-gt` (see [04-Operators](04-Operators/README.md)).
- Assuming `-eq` is case-sensitive - it is not, by default (see [04-Operators](04-Operators/README.md) and the linked prerequisite lesson).
- Writing a bare expression mid-function expecting it to just print - it silently becomes part of the function's *return value* (see [06-Functions](06-Functions/README.md)).
- Treating the pipeline as text, like Bash - it passes real objects (see [07-The-Object-Pipeline](07-The-Object-Pipeline/README.md)).
- Using `Write-Host` for anything meant to be captured or piped (see [19-Best-Practices](19-Best-Practices/README.md)).

## Best Practices

- Use approved verbs (`Get-Verb`) and `[CmdletBinding()]` for real cmdlet-like behavior.
- Prefer the object pipeline (`Where-Object`/`Sort-Object`/`Select-Object`) over string parsing.
- Use `-ErrorAction Stop` + `try/catch` for anything that must be reliably caught.
- Write Pester tests for anything beyond a one-off script (see [18-Testing](18-Testing/README.md)).

## Table of Contents

| # | Section |
|---|---|
| 01 | [Setup](01-Setup/README.md) |
| 02 | [Syntax](02-Syntax/README.md) |
| 03 | [Variables and Data Types](03-Variables-and-Data-Types/README.md) |
| 04 | [Operators](04-Operators/README.md) |
| 05 | [Control Flow](05-Control-Flow/README.md) |
| 06 | [Functions](06-Functions/README.md) |
| 07 | [The Object Pipeline](07-The-Object-Pipeline/README.md) |
| 08 | [Strings](08-Strings/README.md) |
| 09 | [Error Handling](09-Error-Handling/README.md) |
| 10 | [File Handling](10-File-Handling/README.md) |
| 11 | [Classes and OOP](11-Classes-and-OOP/README.md) |
| 12 | [Functional Concepts](12-Functional-Concepts/README.md) |
| 13 | [Generics](13-Generics/README.md) |
| 14 | [Concurrency](14-Concurrency/README.md) |
| 15 | [Modules](15-Modules/README.md) |
| 16 | [Database Access](16-Database-Access/README.md) |
| 17 | [API Integration](17-API-Integration/README.md) |
| 18 | [Testing](18-Testing/README.md) |
| 19 | [Best Practices](19-Best-Practices/README.md) |
| 20 | [Exercises](20-Exercises/README.md) |
| 21 | [Solutions](21-Solutions/README.md) |
| 22 | [Mini-Projects](22-Mini-Projects/README.md) |

See also: [CHEAT-SHEET.md](CHEAT-SHEET.md)

## Interview Questions

1. **How does PowerShell's pipeline fundamentally differ from Bash's?** It passes real, typed .NET objects between cmdlets, not text - see [07-The-Object-Pipeline](07-The-Object-Pipeline/README.md), verified live against `Get-Process`.
2. **Why does `-eq` sometimes surprise developers coming from other languages?** It's case-insensitive by default (`-ceq`/`-cne` are the explicit case-sensitive variants) - see [04-Operators](04-Operators/README.md).
3. **What is the difference between a terminating and non-terminating error?** Non-terminating errors (most cmdlet errors) do not stop the script and are not caught by `try/catch` unless `-ErrorAction Stop` is used - see [09-Error-Handling](09-Error-Handling/README.md).
4. **What's the "implicit return" gotcha in PowerShell functions?** Any unassigned expression's value inside a function becomes part of its output, not just the last line or an explicit `return` - see [06-Functions](06-Functions/README.md).
5. **How do you write real unit tests for PowerShell code?** Pester, PowerShell's de facto test framework - see [18-Testing](18-Testing/README.md).
