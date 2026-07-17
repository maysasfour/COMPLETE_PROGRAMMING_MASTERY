# 19 — Command Line and Operating Systems

[Back to repository root](../README.md)

## What Command Line and Operating Systems Covers

This module covers Bash scripting fundamentals, PowerShell fundamentals, and file permissions/process management — three lessons, each with real, captured terminal output from commands genuinely executed on this machine, including a runnable `demo.sh`/`demo.ps1` script per lesson so results can be reproduced independently.

## Why This Module Uses Real Shell Commands, Not a Programming Language

Like [17-Git-and-GitHub](../17-Git-and-GitHub/README.md), the subject of this module is the tooling itself, not a language used to build examples. Every command shown in every lesson's README was actually run, with its real output captured — including a genuine, reproducible word-splitting bug in Bash, a real authorization bug from PowerShell's default case-insensitive string comparison, and an honestly disclosed, real platform difference in how `chmod` behaves on this session's Windows/NTFS environment compared to native Linux.

## Why It Matters / Where It's Used

- **Shell scripting is a foundational, daily skill** for automation, deployment, and general development work, regardless of which specific language or framework a project uses.
- **Real, common shell gotchas are genuinely easy to reproduce and easy to miss** — this module demonstrates three of them (Bash word-splitting, PowerShell's case-insensitive `-eq`, and platform-dependent `chmod` behavior) with real, captured evidence rather than describing them abstractly.
- **Interviews**: "what's wrong with this Bash script," "how does PowerShell's pipeline differ from Bash's," and "how would you safely kill a specific process" are realistic command-line/OS interview questions, directly covered by this module's three lessons.

## Advantages of This Approach

- Every lesson includes a runnable `demo.sh`/`demo.ps1` script, independently verified end-to-end, so a learner can reproduce the exact same real output themselves.
- Lesson 03 is transparent about a genuine, real constraint discovered during verification (`chmod`'s non-enforcement on this Windows/NTFS environment) rather than glossing over it or fabricating Linux-only behavior that couldn't actually be verified here.
- Lesson 02's authorization-bug framing directly connects PowerShell's specific comparison-operator behavior to [16-Security](../16-Security/README.md)'s broader theme of real, verified exploitable bugs.

## Disadvantages / Trade-offs

- This module's Lesson 03 permission demonstration is explicitly platform-limited (Windows/NTFS + Git Bash) — a genuine Linux system or a properly configured WSL distribution with a native filesystem would be needed to verify real Unix permission *enforcement*, which this session's environment could not provide (this repository's `18-DevOps-and-Cloud` module is similarly blocked by an environment-specific Docker issue, documented in [06-Desktop-Development](../06-Desktop-Development/README.md)'s Completed Sections entry).
- This module covers Bash/PowerShell fundamentals and process/permission basics only — deeper shell scripting (functions, arrays, traps, advanced parameter expansion) and OS-level topics (scheduling, memory management) are covered more by [20-Computer-Science-Fundamentals](../20-Computer-Science-Fundamentals/README.md) (if built) than here.

## How to Run the Examples

Each lesson includes a runnable script reproducing its exact commands.

```bash
bash 19-Command-Line-and-Operating-Systems/01-Bash-Basics/demo.sh
```

```powershell
powershell -File 19-Command-Line-and-Operating-Systems/02-PowerShell-Basics/demo.ps1
```

Requires Bash (Git Bash on Windows, or any POSIX shell) and PowerShell (built into Windows; PowerShell Core on other platforms). No other dependencies are required.

## Common Beginner Mistakes

- **Parsing `ls` output or leaving variable expansions unquoted in Bash** — verified live in Lesson 01 to word-split real filenames containing spaces into incorrect pieces.
- **Assuming PowerShell's `-eq` is case-sensitive** — verified live in Lesson 02 to incorrectly grant access to role strings differing only in case.
- **Assuming `chmod` enforces identical restrictions on every platform** — verified live in Lesson 03 to behave differently on this session's Windows/NTFS environment than it would on native Linux.
- **Killing processes by name instead of by a verified, exact PID** — Lesson 03 demonstrates the safer, PID-based approach used throughout this repository.

## Best Practices

- Prefer shell globbing over parsing command output in Bash; always quote variable expansions.
- Use PowerShell's explicit case-sensitive operators (`-ceq`, etc.) whenever exact-case comparison matters.
- Verify actual platform behavior (permission enforcement, command semantics) rather than assuming textbook behavior applies identically everywhere.
- Always target an exact, verified PID when managing processes programmatically.

## Interview Questions

1. Why does unquoted `$(ls ...)` in a Bash `for` loop break on filenames containing spaces, and how do you avoid it?
2. How does PowerShell's object pipeline differ fundamentally from Bash's text pipeline?
3. Why is PowerShell's `-eq` operator case-insensitive by default, and when would that matter?
4. Why can file permission behavior differ across platforms/filesystems?
5. Why is killing a process by exact PID safer than killing by name?

(Detailed, verified answers live in each lesson's own README.)

## Table of Contents

| # | Lesson | Covers |
|---|--------|--------|
| 01 | [Bash Basics](01-Bash-Basics/README.md) | A real, reproducible word-splitting bug; globbing; pipes and redirection |
| 02 | [PowerShell Basics](02-PowerShell-Basics/README.md) | The object pipeline; a real authorization bug from case-insensitive `-eq` |
| 03 | [File Permissions and Processes](03-File-Permissions-and-Processes/README.md) | `chmod`, a real disclosed platform difference; safe, PID-verified process management |

## Suggested Path

Work through 01 → 03 in order. See also [17-Git-and-GitHub](../17-Git-and-GitHub/README.md) for the same real-command-execution discipline applied to git specifically, and [16-Security](../16-Security/README.md) for more on the authorization-bug theme touched on in Lesson 02.

**Previous module:** [18-DevOps-and-Cloud](../18-DevOps-and-Cloud/README.md)
