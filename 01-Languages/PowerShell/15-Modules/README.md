# 15 - Modules

[Back to course overview](../README.md) | Previous: [14 - Concurrency](../14-Concurrency/README.md) | Next: [16 - Database Access](../16-Database-Access/README.md)

## What / Why / Where

`Import-Module` loads reusable `.psm1` module files; `$PSModulePath` is the search path
PowerShell uses to auto-discover installed modules; the PowerShell Gallery
(powershellgallery.com) is PowerShell's package registry, conceptually like npm/PyPI/RubyGems.

## Verified Live

`$env:PSModulePath` on this machine resolves to 5 real search directories (user modules,
Program Files, the Windows PowerShell system directory, and two SQL Server tooling paths).
`Get-Module -ListAvailable` confirmed `Pester 3.4.0` already present - used for real in
[18-Testing](../18-Testing/README.md). A tiny real module (`MathHelpers.psm1`, exporting
`Get-Cube`) was written to a temp folder, imported with `Import-Module`, and its exported
function called successfully (`Get-Cube 3` -> `27`), then unloaded with `Remove-Module`.

## Advantages / Disadvantages

- Advantage: `$PSModulePath` auto-discovery means installed modules "just work" with no manual path wiring.
- Advantage: `Export-ModuleMember` gives explicit control over a module's public surface.
- Disadvantage: `Install-Module` from the PowerShell Gallery requires network access and (on older PS versions) sometimes manual `-SkipPublisherCheck`/trust prompts - not exercised live here beyond checking what's already installed.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md) for this lesson's own demo module. Real third-party modules: `Install-Module -Name <ModuleName> -Scope CurrentUser`.

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Forgetting `Export-ModuleMember` in a `.psm1` file, so functions defined in it aren't actually usable after import.
- Not knowing `$PSModulePath` exists and can be inspected/extended for custom module locations.
- Confusing `-Scope CurrentUser` vs. the default (often requiring admin rights) when installing from the Gallery.

## Best Practices

- Always call `Export-ModuleMember` explicitly rather than relying on "everything is exported" default behavior for clarity.
- Use `-Scope CurrentUser` for `Install-Module` unless system-wide installation is genuinely required.
- Check `Get-Module -ListAvailable` before assuming a module needs installing.

## Detailed Example

See [demo.ps1](demo.ps1) - the module creation, import, function call, and cleanup were all captured from a real run.

## Interview Questions

1. **What is `$PSModulePath`?** The list of directories PowerShell searches to auto-discover installed modules - verified live listing 5 real paths on this machine, including the user modules directory and system module directory.
2. **What confirms a module's functions are actually usable after `Import-Module`?** `Export-ModuleMember` - verified live: a real module (`MathHelpers.psm1`) exporting `Get-Cube` was imported and its function called successfully, returning `27` for `Get-Cube 3`.

## Recommended Next Lesson

[16 - Database Access](../16-Database-Access/README.md)
