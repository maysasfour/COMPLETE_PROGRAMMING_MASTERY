# Solution 1 - Case-sensitive role check (see 20-Exercises/README.md, problem 1).
# -ceq forces a case-sensitive string comparison; the default -eq is case-INsensitive
# in PowerShell, a common surprise coming from other languages.
function Test-RoleAccess {
    param([string]$Role)
    if ($Role -ceq "admin") { return "GRANTED" }
    return "DENIED"
}

'admin', 'Admin', 'ADMIN' | ForEach-Object { Write-Output "$_ -> $(Test-RoleAccess $_)" }
