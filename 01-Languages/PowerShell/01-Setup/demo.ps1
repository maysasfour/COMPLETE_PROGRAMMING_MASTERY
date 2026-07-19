# 01-Setup: environment, execution policy, and edition checks.
# Run with: powershell -File demo.ps1   (Windows PowerShell 5.1)
# or:       pwsh -File demo.ps1         (PowerShell 7+, if installed)

Write-Output "PSVersion table:"
$PSVersionTable | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Current execution policy (per scope):"
Get-ExecutionPolicy -List | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Is this PowerShell Core (7+) or Windows PowerShell (5.1)?"
if ($PSVersionTable.PSEdition -eq 'Core') {
    Write-Output "-> PowerShell Core (cross-platform, 7+)"
} else {
    Write-Output "-> Windows PowerShell (5.1, Windows-only, .NET Framework based)"
}
