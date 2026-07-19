# 02-Syntax: Verb-Noun cmdlet naming, newline statement termination, comments.

# Statements are newline-terminated; semicolons are optional and only needed
# to put two statements on one line.
$a = 1; $b = 2
Write-Output "a=$a b=$b"

# Cmdlet names follow a strict Verb-Noun convention: Get-Process, Set-Location,
# New-Item, Remove-Item. PowerShell ships a fixed, approved verb list (see
# Get-Verb in 19-Best-Practices) so cmdlet behavior is predictable from its name.
$approvedSample = Get-Verb | Where-Object { $_.Verb -in @('Get','Set','New','Remove') }
$approvedSample | Format-Table -AutoSize | Out-String | Write-Output

# Line continuation: a trailing backtick continues a statement onto the next
# line (rarely needed - PowerShell is usually smart about continuing inside
# open parens/braces/pipes without it).
$sum = 1 + `
       2 + `
       3
Write-Output "sum=$sum"

# A pipeline spanning multiple lines needs no backtick if the line ends in a pipe:
$evens = 1..10 |
    Where-Object { $_ % 2 -eq 0 }
Write-Output "evens: $($evens -join ',')"
