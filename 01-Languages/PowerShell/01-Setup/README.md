# 01 - Setup

[Back to course overview](../README.md) | Next: [02 - Syntax](../02-Syntax/README.md)

## What / Why / Where

Before writing PowerShell, you need to know which PowerShell you're running (Windows
PowerShell 5.1 vs. PowerShell 7+/Core), how the execution policy governs whether `.ps1`
scripts run at all, and what editor to use. This matters everywhere PowerShell is used -
Windows admin boxes almost always have only 5.1 preinstalled; CI/cross-platform pipelines
typically use 7+.

## Windows PowerShell 5.1 vs. PowerShell 7+ (Core)

| | Windows PowerShell 5.1 | PowerShell 7+ (Core) |
|---|---|---|
| Runtime | .NET Framework | .NET (Core/5+) |
| Platform | Windows only | Windows, Linux, macOS |
| `$PSVersionTable.PSEdition` | `Desktop` | `Core` |
| Ships with Windows | Yes, preinstalled | No, separate install |
| Default in this course | **Yes - verified live below** | Checked, not present here |

Verified live on this course's build machine:

```
$PSVersionTable.PSVersion  -> 5.1.22000.2538
$PSVersionTable.PSEdition  -> Desktop
where pwsh                -> not found
```

Every example in this entire course was run for real on **Windows PowerShell 5.1**. Where a
PowerShell 7+-only feature is mentioned, it is explicitly labeled as untested here.

## Execution Policy

PowerShell blocks running arbitrary untrusted scripts by default via an execution policy.

```powershell
Get-ExecutionPolicy -List   # scope-by-scope view
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Verified live, this environment's per-scope policy:

```
MachinePolicy       Undefined
UserPolicy          Undefined
Process             Bypass
CurrentUser         Undefined
LocalMachine        Undefined
```

`Bypass` at the `Process` scope means this specific invocation (`powershell -File demo.ps1`)
was allowed to run without prompting - a common, intentional pattern for automation/CI.

## Editors

- **VS Code** with the PowerShell extension - the modern standard, cross-platform, works with both 5.1 and 7+.
- **PowerShell ISE** - the older, Windows-only, Windows-PowerShell-5.1-only built-in editor.
- Any text editor + `powershell -File script.ps1` from a terminal, as used throughout this course.

## Advantages / Disadvantages

- Advantage: 5.1 requires zero install on any Windows machine.
- Advantage: 7+ is faster, cross-platform, and gets new language features first.
- Disadvantage: script portability across 5.1/7+ isn't automatic - some cmdlets/modules differ.
- Disadvantage: execution policy can silently block scripts for new users unfamiliar with it.

## Install Instructions

- 5.1: nothing to install on Windows 10/11.
- 7+: `winget install Microsoft.PowerShell` or download from the PowerShell GitHub releases page.

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Assuming `Set-ExecutionPolicy Unrestricted` is required/safe globally - prefer `RemoteSigned` at `CurrentUser` scope instead.
- Confusing the Desktop (5.1) and Core (7+) editions when a script uses cmdlets only available in one.
- Not checking `$PSVersionTable` before assuming a feature (like classes or certain operators) is available.

## Best Practices

- Check `$PSVersionTable.PSEdition` and `.PSVersion` at the top of scripts that depend on a specific edition/version.
- Use `RemoteSigned`, not `Unrestricted`, for the execution policy on personal machines.
- Prefer VS Code + the PowerShell extension for anything beyond a one-liner.

## Detailed Example

See [demo.ps1](demo.ps1).

## Interview Questions

1. **What's the difference between Windows PowerShell and PowerShell 7 (Core)?** Windows PowerShell 5.1 runs on .NET Framework and is Windows-only; PowerShell 7+ runs on modern .NET and is cross-platform. Verified live here: `$PSVersionTable.PSEdition` returned `Desktop` (5.1), and `pwsh` was not found on PATH.
2. **What does the execution policy actually protect against, and what doesn't it protect against?** It's a safety rail against accidentally running untrusted scripts, not a security boundary (it can be bypassed with `-ExecutionPolicy Bypass` or `Set-ExecutionPolicy`) - verified live: this session's `Process` scope was already `Bypass`.

## Recommended Next Lesson

[02 - Syntax](../02-Syntax/README.md)
