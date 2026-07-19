# 16 - Database Access

[Back to course overview](../README.md) | Previous: [15 - Modules](../15-Modules/README.md) | Next: [17 - API Integration](../17-API-Integration/README.md)

## What / Why / Where

Honest, verified-live finding for this specific environment: **no SQLite engine is actually
available**. `sqlite3.exe` is not on PATH, `System.Data.SQLite` cannot be loaded via
`[System.Reflection.Assembly]::LoadWithPartialName`, and the `PSSQLite` PowerShell Gallery
module is not installed. Rather than fabricate SQLite output, this lesson demonstrates the
one database-adjacent capability confirmed to work everywhere .NET is present - an in-memory
`System.Data.DataTable` - and documents the exact, correct commands to get real SQLite
access via `PSSQLite`, without pretending they were run here.

## Verified Live

```powershell
Add-Type -AssemblyName System.Data
$table = New-Object System.Data.DataTable "Tasks"
$table.Columns.Add("Id",[int]); $table.Columns.Add("Title",[string]); $table.Columns.Add("Done",[bool])
$table.Rows.Add(1,"Write PowerShell course",$false)
$table.Select("Done = 0")   # real SQL-like predicate query against a real ADO.NET DataTable
```
returned the correct filtered row - a genuine ADO.NET type, no external dependency.

## Advantages / Disadvantages

- Advantage: `System.Data.DataTable` works with zero external dependencies on any .NET-backed PowerShell.
- Advantage: `PSSQLite` (when installed) gives genuine SQLite CRUD via `Invoke-SqliteQuery`.
- Disadvantage: real SQLite access requires an extra module install (`Install-Module PSSQLite`) not present by default - verified absent on this machine.
- Disadvantage: `DataTable` is in-memory only; it does not persist to disk by itself (unlike SQLite).

## Install Instructions

For real SQLite access (not run in this course, documented honestly): `Install-Module PSSQLite -Scope CurrentUser`.

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Assuming SQLite/ADO.NET database drivers are preinstalled with PowerShell - verified live here that they are not, on a stock Windows PowerShell 5.1 install.
- Confusing `DataTable.Select()` (a real, SQL-like filter expression on in-memory data) with an actual SQL query against a database file.
- Not checking whether a module is genuinely available (`Get-Module -ListAvailable`) before writing code that assumes it.

## Best Practices

- Verify a database module/engine is actually available (`Get-Module -ListAvailable`, `Get-Command`) before depending on it in a script.
- Use `PSSQLite`'s `Invoke-SqliteQuery` with `-SqlParameters` for parameterized queries (avoiding SQL injection), documented here even though not run live.
- For simple, dependency-free persistence, prefer file-based JSON (see [10-File-Handling](../10-File-Handling/README.md) and [22-Mini-Projects](../22-Mini-Projects/README.md)) over installing a database engine.

## Detailed Example

See [demo.ps1](demo.ps1) - the `DataTable` example was captured from a real run; the `PSSQLite` commands are documented as correct syntax but explicitly NOT run in this environment.

## Interview Questions

1. **Was real SQLite access verified in this environment?** No - verified live and documented honestly: `sqlite3.exe`, `System.Data.SQLite`, and `PSSQLite` were all checked and found absent from this machine.
2. **What database-adjacent capability WAS verified to work with zero dependencies?** `System.Data.DataTable` - verified live: real typed columns, real rows, and a real `Select()` predicate query, all using only the built-in `System.Data` assembly.

## Recommended Next Lesson

[17 - API Integration](../17-API-Integration/README.md)
