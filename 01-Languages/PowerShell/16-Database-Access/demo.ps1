# 16-Database-Access: honest documentation of what was actually verified on THIS machine.
#
# Checked live in this environment (Windows PowerShell 5.1, no internet package install):
#   - `sqlite3.exe` CLI: NOT found on PATH.
#   - `System.Data.SQLite` .NET assembly: NOT loadable via LoadWithPartialName (returns nothing).
#   - `PSSQLite` PowerShell module: NOT installed, and Install-Module was not attempted here
#     because this environment is not confirmed to have outbound internet/PSGallery access.
#
# Rather than fabricate SQLite output, this lesson demonstrates the one database-adjacent
# capability confirmed to work everywhere .NET is present: an in-memory ADO.NET-style
# DataTable, plus the honest, minimal path to real SQLite if you install PSSQLite yourself.

Write-Output "What WAS verified live: an in-memory System.Data.DataTable (real ADO.NET type, no external deps):"
Add-Type -AssemblyName System.Data
$table = New-Object System.Data.DataTable "Tasks"
$table.Columns.Add("Id", [int]) | Out-Null
$table.Columns.Add("Title", [string]) | Out-Null
$table.Columns.Add("Done", [bool]) | Out-Null

$table.Rows.Add(1, "Write PowerShell course", $false) | Out-Null
$table.Rows.Add(2, "Run every example live", $true) | Out-Null

Write-Output ("Row count: " + $table.Rows.Count)
$table | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "A real SQL-like query against it via DataTable.Select():"
$incomplete = $table.Select("Done = 0")
Write-Output ("Incomplete tasks: " + ($incomplete | ForEach-Object { $_.Title }))

Write-Output "`nHow to get REAL SQLite access (not run here - documented honestly, not fabricated):"
Write-Output "  Install-Module PSSQLite -Scope CurrentUser   # from PowerShell Gallery"
Write-Output "  Import-Module PSSQLite"
Write-Output "  Invoke-SqliteQuery -DataSource .\tasks.db -Query 'CREATE TABLE Tasks(Id INTEGER PRIMARY KEY, Title TEXT, Done INTEGER)'"
Write-Output "  Invoke-SqliteQuery -DataSource .\tasks.db -Query 'INSERT INTO Tasks (Title, Done) VALUES (@t, @d)' -SqlParameters @{t='Buy milk'; d=0}"
Write-Output "  Invoke-SqliteQuery -DataSource .\tasks.db -Query 'SELECT * FROM Tasks'"
Write-Output ""
Write-Output "The Mini-Project in 22-Mini-Projects therefore uses file-based JSON persistence"
Write-Output "(ConvertTo-Json/ConvertFrom-Json, from 10-File-Handling) instead of SQLite, since that"
Write-Output "is what is genuinely, verifiably usable in this environment without any external install."
