# 19-Best-Practices: approved verbs, [CmdletBinding()], avoiding Write-Host, anti-pattern/fix.

Write-Output "PowerShell's fixed, approved verb list (a real constraint, not a style suggestion):"
Get-Verb | Where-Object { $_.Group -eq 'Common' } | Select-Object -First 6 -Property Verb, Group |
    Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Using an unapproved verb triggers a real warning when the function is loaded as part of a module:"
function Delete-TempFile { param($Path) Write-Output "would delete $Path" }
$warning = $null
Import-Module Microsoft.PowerShell.Utility -Verbose:$false
$check = Get-Verb | Where-Object { $_.Verb -eq 'Delete' }
Write-Output ("Is 'Delete' an approved verb? " + [bool]$check + "  (it is NOT - 'Remove' is the approved verb for this)")

Write-Output "`n[CmdletBinding()] makes a plain function behave like a real cmdlet (-Verbose, -ErrorAction, etc.):"
function Remove-TempFileAdvanced {
    [CmdletBinding()]
    param([string]$Path)
    Write-Verbose "Would remove: $Path"
    Write-Output "done"
}
Remove-TempFileAdvanced -Path "C:\temp\file.txt" -Verbose

Write-Output "`nANTI-PATTERN: Write-Host writes directly to the console, bypassing the output stream -"
Write-Output "its result CANNOT be captured, piped, or redirected:"
function Get-DoubleAntiPattern {
    param([int]$N)
    Write-Host "Doubling $N..."   # anti-pattern: this cannot be captured by the caller
    return $N * 2
}
$captured = Get-DoubleAntiPattern -N 5
Write-Output ("Captured variable only has the return value: $captured (the Write-Host line above bypassed capture entirely)")

Write-Output "`nFIX: use Write-Verbose/Write-Output so the caller controls what's captured and how:"
function Get-DoubleFixed {
    [CmdletBinding()]
    param([int]$N)
    Write-Verbose "Doubling $N..."   # only shown with -Verbose; never pollutes the pipeline
    return $N * 2
}
$capturedFixed = Get-DoubleFixed -N 5 -Verbose
Write-Output ("Captured with fix: $capturedFixed")
