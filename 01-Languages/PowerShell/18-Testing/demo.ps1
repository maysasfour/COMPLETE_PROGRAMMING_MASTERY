# 18-Testing: Pester, PowerShell's real, widely-used test framework.
# Verified live: Get-Module -ListAvailable Pester (see 15-Modules) found Pester 3.4.0
# already installed in this environment, so no Install-Module was needed here.

Write-Output "Pester version available in this environment:"
Get-Module -ListAvailable Pester | Select-Object Name, Version | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Running MathHelpers.Tests.ps1 against MathHelpers.ps1 (both in this folder):"
Import-Module Pester -RequiredVersion 3.4.0 -Force
$result = Invoke-Pester -Script "$PSScriptRoot\MathHelpers.Tests.ps1" -PassThru -Quiet
Write-Output ""
Write-Output ("Passed: {0}  Failed: {1}  Total: {2}" -f $result.PassedCount, $result.FailedCount, $result.TotalCount)

Write-Output "`nIf Pester is NOT installed elsewhere, install with:"
Write-Output "  Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck"
Write-Output "(Newer Pester versions default to 'Should -Be' with a dash; this course's tests"
Write-Output "use the 'Should Be' no-dash syntax that matches Pester 3.4.0, verified live above.)"
