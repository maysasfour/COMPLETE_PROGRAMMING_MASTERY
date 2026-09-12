# Solution 6 - JSON round-trip (see 20-Exercises/README.md, problem 6).
# ConvertTo-Json/ConvertFrom-Json are the built-in serializer pair; the round-trip is
# verified with a real field-by-field comparison, not just "it didn't throw."
function Save-Records {
    param($Records, [string]$Path)
    $Records | ConvertTo-Json -Depth 5 | Set-Content -Path $Path
}

function Load-Records {
    param([string]$Path)
    @(Get-Content -Path $Path -Raw | ConvertFrom-Json)
}

$original = @(
    [PSCustomObject]@{ Id = 1; Name = "A" }
    [PSCustomObject]@{ Id = 2; Name = "B" }
)
$jsonPath = "$env:TEMP\ps-ex6.json"
Save-Records -Records $original -Path $jsonPath
$reloaded = Load-Records -Path $jsonPath

$matches = $original.Count -eq $reloaded.Count
for ($i = 0; $i -lt $original.Count; $i++) {
    if ($original[$i].Id -ne $reloaded[$i].Id -or $original[$i].Name -ne $reloaded[$i].Name) { $matches = $false }
}
$summary = ($reloaded | ForEach-Object { "$($_.Id)=$($_.Name)" }) -join ', '
Write-Output "Reloaded: $summary"
Write-Output "Round-trip matches original: $matches"
Remove-Item $jsonPath -Force
