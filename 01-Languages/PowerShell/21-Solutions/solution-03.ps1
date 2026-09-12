# Solution 3 - Safe file reader (see 20-Exercises/README.md, problem 3).
# -ErrorAction Stop is required for a non-terminating cmdlet error (a missing file, by
# default) to actually be catchable by try/catch at all.
function Read-FileSafe {
    param([string]$Path)
    try {
        return Get-Content -Path $Path -Raw -ErrorAction Stop
    } catch {
        return "Could not read '$Path': file does not exist."
    }
}

Write-Output (Read-FileSafe -Path "C:\definitely-not-real-xyz.txt")
Set-Content -Path "$env:TEMP\ps-ex3-real.txt" -Value "real content"
Write-Output (Read-FileSafe -Path "$env:TEMP\ps-ex3-real.txt")
Remove-Item "$env:TEMP\ps-ex3-real.txt" -Force
