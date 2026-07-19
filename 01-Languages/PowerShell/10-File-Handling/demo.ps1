# 10-File-Handling: Get-Content/Set-Content/Out-File, built-in JSON support.

$dir = "$env:TEMP\ps-file-demo"
New-Item -ItemType Directory -Path $dir -Force | Out-Null
$txtPath = "$dir\notes.txt"
$jsonPath = "$dir\data.json"

Write-Output "Writing and reading plain text:"
"Line one", "Line two", "Line three" | Set-Content -Path $txtPath
$lines = Get-Content -Path $txtPath
Write-Output ("Read back " + $lines.Count + " lines: " + ($lines -join ' / '))

Write-Output "`nAppending with Add-Content, and Out-File as an alternative writer:"
Add-Content -Path $txtPath -Value "Line four (appended)"
(Get-Content $txtPath).Count | ForEach-Object { Write-Output "Now $_ lines" }

Write-Output "`nBuilt-in JSON support - ConvertTo-Json / ConvertFrom-Json (no external library needed):"
$data = [PSCustomObject]@{
    Name    = "Mays"
    Role    = "Author"
    Tags    = @("powershell", "automation")
    Active  = $true
}
$json = $data | ConvertTo-Json
Write-Output "Serialized JSON:"
Write-Output $json
$json | Set-Content -Path $jsonPath

$loaded = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json
Write-Output "`nDeserialized back into a real object - property access works directly:"
Write-Output ("Name: " + $loaded.Name + "  Tags: " + ($loaded.Tags -join ', ') + "  Active: " + $loaded.Active)
Write-Output ("Type after ConvertFrom-Json: " + $loaded.GetType().FullName)

Write-Output "`nContrast: languages like Java/C++/Lua need an external library for JSON;"
Write-Output "PowerShell (like Go/Dart/Ruby, covered in their own courses) has it built in."

# Cleanup this lesson's own scratch files immediately - keep the repo clean.
Remove-Item -Path $dir -Recurse -Force
Write-Output "`n(Temp demo files cleaned up.)"
