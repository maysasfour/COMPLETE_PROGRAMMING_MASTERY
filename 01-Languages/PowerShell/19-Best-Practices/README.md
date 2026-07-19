# 19 - Best Practices

[Back to course overview](../README.md) | Previous: [18 - Testing](../18-Testing/README.md) | Next: [20 - Exercises](../20-Exercises/README.md)

## What / Why / Where

`Get-Verb` reveals PowerShell's fixed, approved verb list; `[CmdletBinding()]` upgrades a
plain function into something that behaves like a real cmdlet (`-Verbose`, `-ErrorAction`,
etc.); and `Write-Host` should be avoided for anything meant to be captured or piped, since
it writes directly to the console and bypasses the output stream entirely.

## Verified Live: A Real Anti-Pattern/Fix Pair

```powershell
function Get-DoubleAntiPattern { param($N) Write-Host "Doubling $N..."; return $N * 2 }
$captured = Get-DoubleAntiPattern -N 5
# $captured is 10 - the Write-Host line is NOT captured, cannot be redirected or piped
```
Fixed version uses `[CmdletBinding()]` + `Write-Verbose` (only shown when `-Verbose` is
passed, never pollutes the pipeline) - confirmed live, `Get-DoubleFixed -N 5 -Verbose`
correctly showed the verbose message on the verbose stream while `$capturedFixed` cleanly
held just `10`.

Also verified live: `'Delete'` is **not** an approved verb (`Remove` is the correct approved
verb for that intent) - checked directly against `Get-Verb`'s real, fixed list.

## Advantages / Disadvantages

- Advantage: `[CmdletBinding()]` gives your own functions consistent, standard behavior (`-Verbose`, `-ErrorAction`, common parameters) for free.
- Advantage: the approved-verb constraint keeps a large ecosystem of cmdlets/functions predictable.
- Disadvantage: `Write-Host` is tempting for quick debugging output but actively breaks composability - a real, common anti-pattern in real-world scripts.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Using `Write-Host` for anything a caller might want to capture, pipe, or redirect - it bypasses the output stream entirely, verified live to leave a captured variable unaffected by its own message.
- Choosing an unapproved verb (`Delete-`, `Change-`) for a custom function name instead of the approved equivalent (`Remove-`, `Set-`).
- Omitting `[CmdletBinding()]`, losing access to common parameters like `-Verbose`/`-ErrorAction` on your own functions.

## Best Practices

- Add `[CmdletBinding()]` to any function meant to be used like a real cmdlet.
- Use `Write-Verbose`/`Write-Output`, never `Write-Host`, for anything that isn't purely for interactive console display.
- Check `Get-Verb` before naming a new function to confirm the verb is approved.

## Detailed Example

See [demo.ps1](demo.ps1) - the anti-pattern/fix pair and the approved-verb check were both captured from real runs.

## Interview Questions

1. **Why is `Write-Host` considered an anti-pattern in PowerShell scripts?** It writes directly to the console host, bypassing the standard output stream entirely, so its output cannot be captured, piped, or redirected - verified live: a function using `Write-Host` for a status message left the caller's captured variable holding only the return value, with the status message untouchable by the caller.
2. **What does `[CmdletBinding()]` actually add to a plain function?** Support for PowerShell's common parameters (`-Verbose`, `-ErrorAction`, `-Debug`, etc.), making a custom function behave like a real cmdlet - verified live: adding it enabled `-Verbose` to correctly surface a `Write-Verbose` message that would otherwise be silent.

## Recommended Next Lesson

[20 - Exercises](../20-Exercises/README.md)
