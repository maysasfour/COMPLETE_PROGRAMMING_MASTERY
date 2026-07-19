# 04-Operators: -eq/-ne/-lt/-gt (NOT ==/!=/</>), -and/-or/-not.
# Contrast: nearly every other course in this repo (C, C#, Java, Python, JS, Ruby, PHP...)
# uses C-style ==, !=, <, > for comparison. PowerShell deliberately does not, because
# < and > are reserved for redirection (like in Bash), so comparisons use word operators.

Write-Output "Comparison operators (word-based, not symbol-based):"
Write-Output ("5 -eq 5   -> " + (5 -eq 5))
Write-Output ("5 -ne 4   -> " + (5 -ne 4))
Write-Output ("3 -lt 10  -> " + (3 -lt 10))
Write-Output ("10 -gt 3  -> " + (10 -gt 3))
Write-Output ("3 -le 3   -> " + (3 -le 3))
Write-Output ("3 -ge 4   -> " + (3 -ge 4))

Write-Output "`nWhat happens if you try C-style operators PowerShell doesn't have for comparison:"
try {
    Invoke-Expression '5 == 5'
} catch {
    Write-Output ("'5 == 5' errors: " + $_.Exception.Message)
}

Write-Output "`n'>' and '<' ARE valid PowerShell syntax - but mean redirection, not comparison:"
Write-Output "5 > `$env:TEMP\ps-operator-demo.txt   # writes the text '5' to a file, does NOT compare"
5 > "$env:TEMP\ps-operator-demo.txt"
Write-Output ("File contents after '5 > file': '" + (Get-Content "$env:TEMP\ps-operator-demo.txt") + "'")
Remove-Item "$env:TEMP\ps-operator-demo.txt" -ErrorAction SilentlyContinue

Write-Output "`nLogical operators: -and / -or / -not"
$a = $true; $b = $false
Write-Output ("`$a -and `$b -> " + ($a -and $b))
Write-Output ("`$a -or `$b  -> " + ($a -or $b))
Write-Output ("-not `$a     -> " + (-not $a))
Write-Output ("!`$a         -> " + (!$a) + "  (! is a valid alias for -not)")

Write-Output "`n-eq is case-INSENSITIVE by default (see also 19-Command-Line-and-Operating-Systems/02):"
Write-Output ("'admin' -eq 'ADMIN'  -> " + ('admin' -eq 'ADMIN'))
Write-Output ("'admin' -ceq 'ADMIN' -> " + ('admin' -ceq 'ADMIN') + "  (case-sensitive variant)")

Write-Output "`n-in / -contains membership operators:"
Write-Output ("2 -in (1,2,3)        -> " + (2 -in (1,2,3)))
Write-Output ("(1,2,3) -contains 2  -> " + ((1,2,3) -contains 2))
