# 02 - Syntax

[Back to course overview](../README.md) | Previous: [01 - Setup](../01-Setup/README.md) | Next: [03 - Variables and Data Types](../03-Variables-and-Data-Types/README.md)

## What / Why / Where

PowerShell statements are newline-terminated (no required semicolons), and every built-in
command follows a strict `Verb-Noun` naming convention (`Get-Process`, `Set-Location`). This
predictability is central to how PowerShell is discoverable and scriptable at scale in
real admin/automation work.

## Verb-Noun Naming

Every cmdlet name is `Verb-Noun` - `Get-ChildItem`, `New-Item`, `Remove-Item`. The verb
comes from a fixed, approved list (`Get-Verb`, covered fully in
[19-Best-Practices](../19-Best-Practices/README.md)), verified live there.

## No Required Semicolons

```powershell
$a = 1
$b = 2
```
is complete and correct. `;` is only needed to separate two statements on one line.

## Comments

```powershell
# single-line comment
<# block
   comment #>
```

## Advantages / Disadvantages

- Advantage: `Verb-Noun` makes unfamiliar cmdlets guessable and greppable.
- Advantage: newline termination reads cleanly, closer to natural script flow.
- Disadvantage: the approved-verb constraint can feel restrictive for custom function names.
- Disadvantage: pipelines spanning multiple lines have specific rules about where a line can break (see [demo.ps1](demo.ps1)) that trip up newcomers.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Adding unnecessary trailing semicolons out of habit from C-style languages.
- Breaking a pipeline across lines in a way that doesn't end in a pipe/operator, causing PowerShell to treat it as two separate statements.
- Naming custom functions with unapproved verbs (see [19-Best-Practices](../19-Best-Practices/README.md)).

## Best Practices

- Follow `Verb-Noun` even for your own functions.
- End a line with a pipe (`|`) or operator when continuing a pipeline onto the next line - avoid the trailing backtick where possible.

## Detailed Example

See [demo.ps1](demo.ps1), run for real - verified output includes an approved-verb table sample, a backtick-continued arithmetic expression (`sum=6`), and a multi-line piped filter (`evens: 2,4,6,8,10`).

## Interview Questions

1. **Why does PowerShell enforce `Verb-Noun` naming for cmdlets?** For discoverability and predictability - a fixed, approved verb list (verified live via `Get-Verb` in [19-Best-Practices](../19-Best-Practices/README.md)) means the verb alone tells you the action's semantics across the entire ecosystem.
2. **Do you need semicolons in PowerShell?** No - statements are newline-terminated; semicolons are only needed to place multiple statements on one line, confirmed by running `$a = 1; $b = 2` successfully in [demo.ps1](demo.ps1).

## Recommended Next Lesson

[03 - Variables and Data Types](../03-Variables-and-Data-Types/README.md)
