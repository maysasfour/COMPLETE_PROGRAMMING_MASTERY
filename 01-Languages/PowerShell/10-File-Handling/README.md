# 10 - File Handling

[Back to course overview](../README.md) | Previous: [09 - Error Handling](../09-Error-Handling/README.md) | Next: [11 - Classes and OOP](../11-Classes-and-OOP/README.md)

## What / Why / Where

`Get-Content`/`Set-Content`/`Add-Content`/`Out-File` cover reading and writing text.
PowerShell also has genuinely built-in JSON support - `ConvertTo-Json`/`ConvertFrom-Json` -
with zero external dependency, a positive contrast with languages like Java/C++/Lua that
need an external library for this (as documented in their own courses).

## Verified Live

```powershell
"Line one","Line two","Line three" | Set-Content notes.txt
Get-Content notes.txt          # -> 3 lines back, joined correctly
Add-Content notes.txt -Value "Line four (appended)"   # -> now 4 lines

$data | ConvertTo-Json         # -> real, correctly-nested JSON, including an array (Tags)
Get-Content data.json -Raw | ConvertFrom-Json   # -> a real PSCustomObject, properties directly accessible
```

Confirmed: `$loaded.GetType().FullName` after `ConvertFrom-Json` is
`System.Management.Automation.PSCustomObject` - a real, navigable object, not a generic map.

## Advantages / Disadvantages

- Advantage: built-in JSON round-tripping with no external dependency (`ConvertTo-Json`/`ConvertFrom-Json`).
- Advantage: `Get-Content`/`Set-Content` work identically for local files regardless of PowerShell edition.
- Disadvantage: `ConvertTo-Json`'s default `-Depth` (2 in older versions) can silently truncate deeply nested objects if not set explicitly.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Forgetting `-Raw` on `Get-Content` before `ConvertFrom-Json` - without it, content comes back as an array of lines, not one JSON string, and parsing can behave unexpectedly for multi-line JSON.
- Not setting `-Depth` on `ConvertTo-Json` for nested objects, silently losing inner data.
- Using `Out-File` and `Set-Content` interchangeably without knowing `Out-File` defaults to a different encoding on Windows PowerShell 5.1 than `Set-Content`.

## Best Practices

- Always use `-Raw` with `Get-Content` before `ConvertFrom-Json`.
- Set an explicit `-Depth` on `ConvertTo-Json` for anything beyond a flat object.
- Prefer `Set-Content`/`Add-Content` over `Out-File` for plain text unless you specifically need `Out-File`'s formatting behavior.

## Detailed Example

See [demo.ps1](demo.ps1) - all output above was captured from a real run; temp files were cleaned up by the script itself at the end.

## Interview Questions

1. **Does PowerShell need an external library for JSON?** No - `ConvertTo-Json`/`ConvertFrom-Json` are built in, verified live round-tripping a `PSCustomObject` (with a nested array `Tags`) to a JSON file and back into a real, property-accessible object.
2. **What's a common `Get-Content` mistake before parsing JSON?** Omitting `-Raw`, which returns an array of lines rather than a single string - verified correct usage in [demo.ps1](demo.ps1) using `Get-Content -Raw`.

## Recommended Next Lesson

[11 - Classes and OOP](../11-Classes-and-OOP/README.md)
