# 07-The-Object-Pipeline: PowerShell's single most distinctive feature.
# The pipeline passes REAL .NET objects between cmdlets, not text - a direct,
# verified-live contrast with Bash's text-stream pipeline
# (see 19-Command-Line-and-Operating-Systems/01-Bash-Basics and /02-PowerShell-Basics).

Write-Output "Get-Process | Where-Object | Select-Object - real objects end to end:"
$top3 = Get-Process |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 3 -Property Name, Id, @{Name='WorkingSetMB'; Expression={ [math]::Round($_.WorkingSet64/1MB,1) }}
$top3 | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Proof these are real typed objects, not parsed text - inspect one member directly:"
$proc = Get-Process | Select-Object -First 1
Write-Output ("Type of a pipeline element: " + $proc.GetType().FullName)
Write-Output ("Its Id property, accessed directly (int): " + $proc.Id + "  (type: " + $proc.Id.GetType().Name + ")")

Write-Output "`nGet-Member reveals every real property/method on a pipeline object:"
Get-Process | Select-Object -First 1 | Get-Member -MemberType Property |
    Select-Object -First 5 -Property Name, MemberType |
    Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Contrast with Bash: 'ps aux | sort -k4 -n | head -3' must parse column-aligned TEXT."
Write-Output "Here, WorkingSet64 was sorted as a real Int64, never converted to or parsed from a string."

Write-Output "`nFiltering with Where-Object using a real numeric property (no text parsing):"
Get-Process | Where-Object { $_.Id -gt 0 -and $_.ProcessName -like 'pwsh*' -or $_.ProcessName -like 'powershell*' } |
    Select-Object -First 2 -Property ProcessName, Id | Format-Table -AutoSize | Out-String | Write-Output
