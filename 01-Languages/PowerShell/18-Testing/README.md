# 18 - Testing

[Back to course overview](../README.md) | Previous: [17 - API Integration](../17-API-Integration/README.md) | Next: [19 - Best Practices](../19-Best-Practices/README.md)

## What / Why / Where

Pester is PowerShell's real, widely-used test framework - `Describe`/`It`/`Should` blocks.
Verified live via `Get-Module -ListAvailable Pester`: **Pester 3.4.0 is already installed**
on this machine, so no `Install-Module` was needed here. Pester 3.x uses `Should Be`
(no dash); Pester 4/5 use `Should -Be` - this course's tests target the verified-installed
3.4.0 syntax.

## Verified Live

`MathHelpers.ps1` (`Get-Square`, `Get-Average`) tested by `MathHelpers.Tests.ps1`:

```
Describing Get-Square
 [+] squares a positive number
 [+] squares zero
 [+] squares a negative number
Describing Get-Average
 [+] averages a normal set of numbers
 [+] throws on an empty collection
Passed: 5 Failed: 0 Skipped: 0 Pending: 0 Inconclusive: 0
```

All 5 assertions passed on a real `Invoke-Pester` run. The same approach is used for real
in [22-Mini-Projects](../22-Mini-Projects/README.md)'s Task Tracker, where it caught two
genuine bugs during development (see that lesson's README for details).

## Advantages / Disadvantages

- Advantage: Pester is the de facto standard, well-documented, and (as verified here) often already present on Windows machines.
- Advantage: `Should Throw` cleanly tests error/exception paths.
- Disadvantage: syntax differs meaningfully between Pester 3.x (`Should Be`) and 4/5 (`Should -Be`) - code written for one doesn't always run cleanly on the other without adjustment.

## Install Instructions

Already present in this environment (Pester 3.4.0). Elsewhere: `Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck`.

## How to Run

```powershell
powershell -File demo.ps1
```
or directly:
```powershell
Invoke-Pester -Script .\MathHelpers.Tests.ps1
```

## Common Beginner Mistakes

- Mixing Pester 3.x (`Should Be`) and Pester 5.x (`Should -Be`) syntax in the same test suite without checking which version is actually installed.
- Testing implementation details instead of behavior (e.g. asserting on internal variable state instead of function output).
- Not testing the error/throw path (`Should Throw`) alongside the happy path.

## Best Practices

- Check the installed Pester version (`Get-Module -ListAvailable Pester`) before writing tests, and match its syntax.
- Test both success and failure paths (`Should Be` and `Should Throw`).
- Isolate test state (unique temp files/paths per test) so tests never interfere with each other - used throughout [22-Mini-Projects](../22-Mini-Projects/README.md)'s test suite.

## Detailed Example

See [demo.ps1](demo.ps1), [MathHelpers.ps1](MathHelpers.ps1), and [MathHelpers.Tests.ps1](MathHelpers.Tests.ps1) - all output above was captured from a real `Invoke-Pester` run.

## Interview Questions

1. **What test framework does PowerShell use, and was it available in this environment?** Pester - verified live already installed at version 3.4.0 via `Get-Module -ListAvailable Pester`, requiring no additional install.
2. **How does Pester 3.x's assertion syntax differ from Pester 5.x's?** Pester 3.x uses `Should Be` (no dash); Pester 4/5 use `Should -Be` (dash-prefixed parameter). This course's tests target 3.4.0, the version verified installed here, and were confirmed to pass with that exact syntax (5/5 assertions, 0 failures).

## Recommended Next Lesson

[19 - Best Practices](../19-Best-Practices/README.md)
