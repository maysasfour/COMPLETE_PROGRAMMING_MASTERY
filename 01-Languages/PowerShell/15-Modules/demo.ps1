# 15-Modules: Import-Module, $PSModulePath, PowerShell Gallery (conceptually).

Write-Output "`$PSModulePath - the search path for modules (semicolon-separated on Windows):"
$env:PSModulePath -split ';' | ForEach-Object { Write-Output "  $_" }

Write-Output "`nModules already available in this session (sample):"
Get-Module -ListAvailable | Select-Object -First 5 -Property Name, Version | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "Writing and importing a tiny real module of our own:"
$moduleDir = "$env:TEMP\ps-module-demo\MathHelpers"
New-Item -ItemType Directory -Path $moduleDir -Force | Out-Null
$modulePath = "$moduleDir\MathHelpers.psm1"
@'
function Get-Cube {
    param([int]$Number)
    return $Number * $Number * $Number
}
Export-ModuleMember -Function Get-Cube
'@ | Set-Content -Path $modulePath

Import-Module $modulePath -Force
Write-Output ("Get-Cube 3 (from our own imported module) -> " + (Get-Cube 3))
Write-Output ("Module now loaded: " + (Get-Module MathHelpers).Name)

Remove-Module MathHelpers -Force
Remove-Item "$env:TEMP\ps-module-demo" -Recurse -Force
Write-Output "`n(Module unloaded and temp files cleaned up.)"

Write-Output "`nThe PowerShell Gallery (powershellgallery.com) is PowerShell's package registry - conceptually"
Write-Output "like npm/PyPI/RubyGems. Real modules are installed with:"
Write-Output "  Install-Module -Name Pester -Scope CurrentUser"
Write-Output "(Actually used for real in 18-Testing, where Pester availability is checked live.)"
