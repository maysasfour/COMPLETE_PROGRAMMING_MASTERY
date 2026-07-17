# demo.ps1 - run this in PowerShell to reproduce every real command and output
# shown in this lesson's README: PowerShell's object pipeline (distinct from
# Bash's text pipeline), and a real, reproducible authorization bug caused by
# -eq's default case-INSENSITIVE behavior.

Write-Output "=== PowerShell pipes REAL OBJECTS, not text ==="
$files = @(
    [PSCustomObject]@{ Name = "report.txt"; SizeBytes = 250 }
    [PSCustomObject]@{ Name = "photo.png";  SizeBytes = 50000 }
    [PSCustomObject]@{ Name = "notes.txt";  SizeBytes = 80 }
)
Write-Output "All files:"
$files | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Files over 100 bytes, filtered by the REAL numeric SizeBytes property (not text parsing):"
$files | Where-Object { $_.SizeBytes -gt 100 } | Sort-Object SizeBytes -Descending | Select-Object Name, SizeBytes | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "=== Violation: -eq is case-INSENSITIVE by default -- a real authorization bug ==="
function Test-AdminAccessViolation($role) {
    if ($role -eq "admin") {
        return "GRANTED"
    }
    return "DENIED"
}
Write-Output "Role 'admin' -> $(Test-AdminAccessViolation 'admin')"
Write-Output "Role 'Admin' -> $(Test-AdminAccessViolation 'Admin')   <- BUG: should NOT match if roles are meant to be case-sensitive!"
Write-Output "Role 'ADMIN' -> $(Test-AdminAccessViolation 'ADMIN')   <- BUG: same issue"
Write-Output "Role 'user'  -> $(Test-AdminAccessViolation 'user')"

Write-Output ""
Write-Output "=== Fixed: -ceq is the explicit, case-SENSITIVE comparison operator ==="
function Test-AdminAccessFixed($role) {
    if ($role -ceq "admin") {
        return "GRANTED"
    }
    return "DENIED"
}
Write-Output "Role 'admin' -> $(Test-AdminAccessFixed 'admin')"
Write-Output "Role 'Admin' -> $(Test-AdminAccessFixed 'Admin')   <- correct: case mismatch now correctly denied"
Write-Output "Role 'ADMIN' -> $(Test-AdminAccessFixed 'ADMIN')   <- correct: case mismatch now correctly denied"
Write-Output "Role 'user'  -> $(Test-AdminAccessFixed 'user')"
