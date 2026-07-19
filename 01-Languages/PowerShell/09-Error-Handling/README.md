# 09 - Error Handling

[Back to course overview](../README.md) | Previous: [08 - Strings](../08-Strings/README.md) | Next: [10 - File Handling](../10-File-Handling/README.md)

## What / Why / Where

PowerShell distinguishes **terminating** and **non-terminating** errors - a genuinely
distinctive concept most other languages don't have. Most cmdlet errors (a missing file,
for example) are non-terminating by default: the script keeps running, and `try/catch`
around the same call does **not** catch it, unless `-ErrorAction Stop` is used to promote
it into a real, catchable exception.

## Verified Live

```powershell
Get-Item "C:\missing.txt" -ErrorAction Continue   # prints an error, script CONTINUES
try { Get-Item "C:\missing.txt" -ErrorAction SilentlyContinue } catch { ... }  # catch NEVER runs
try { Get-Item "C:\missing.txt" -ErrorAction Stop } catch { ... }  # NOW it's caught
```

Confirmed: the identical cmdlet call, same missing path, behaves completely differently
depending only on `-ErrorAction`. `$Error[0]` also holds the automatic history of the most
recent error, regardless of whether it was caught.

## Advantages / Disadvantages

- Advantage: non-terminating errors let a script continue processing a batch (e.g. copying 100 files) even if a few individually fail.
- Advantage: `-ErrorAction Stop` gives you precise, per-call control over which errors must be handled.
- Disadvantage: the terminating/non-terminating distinction is a genuine, well-documented source of "why didn't my catch block run?" bugs for newcomers.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Wrapping a cmdlet call in `try/catch` and being confused when the catch block never executes - because the error was non-terminating.
- Not knowing `-ErrorAction Stop` exists, and instead manually checking `$?`/`$Error` after every call.
- Forgetting `finally` always runs regardless of whether the error was caught or the try block succeeded.

## Best Practices

- Add `-ErrorAction Stop` to any cmdlet call you intend to handle with `try/catch`.
- Catch specific exception types (`catch [System.DivideByZeroException]`) before falling back to a generic `catch`.
- Use `throw` with a clear message for your own function's validation failures.

## Detailed Example

See [demo.ps1](demo.ps1) - all output above was captured from a real run, including a genuinely terminating divide-by-zero error and a custom `throw`.

## Interview Questions

1. **What is the difference between a terminating and non-terminating error in PowerShell?** Terminating errors stop execution and are catchable by `try/catch`; non-terminating errors (the default for most cmdlets) log to the error stream and let the script continue, and are NOT caught by `try/catch` unless promoted. Verified live: the identical `Get-Item` call against a missing path was silently passed over by a `try/catch` with `-ErrorAction SilentlyContinue`, but was correctly caught once `-ErrorAction Stop` was added.
2. **What does `$Error` hold?** An automatic, session-wide history of recent errors (most recent first), regardless of whether they were caught - verified live via `$Error[0].Exception.Message` reflecting the most recent error even after a caught divide-by-zero exception.

## Recommended Next Lesson

[10 - File Handling](../10-File-Handling/README.md)
