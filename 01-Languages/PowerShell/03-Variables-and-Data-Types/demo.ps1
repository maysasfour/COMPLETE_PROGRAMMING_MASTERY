# 03-Variables-and-Data-Types: $variables, the real .NET type system underneath, $null.

$name = "Mays"
$age = 30
$pi = 3.14
$isActive = $true
$nothing = $null

Write-Output "name=$name age=$age pi=$pi isActive=$isActive nothing=[$nothing]"

Write-Output "`nReal .NET types underneath every PowerShell value:"
Write-Output ("$name -> " + $name.GetType().FullName)
Write-Output ("$age -> "  + $age.GetType().FullName)
Write-Output ("$pi -> "   + $pi.GetType().FullName)
Write-Output ("$isActive -> " + $isActive.GetType().FullName)

# Explicit typing constrains a variable to one .NET type.
[int]$count = 5
try {
    $count = "not a number"
} catch {
    Write-Output "`nAssigning a non-numeric string to [int]`$count failed as expected:"
    Write-Output $_.Exception.Message
}

# $null is a real, distinct value/type - not the same as an empty string or 0.
Write-Output "`n`$null comparisons:"
Write-Output ("`$null -eq `$null    -> " + ($null -eq $null))
Write-Output ("`$null -eq ''        -> " + ($null -eq ''))
Write-Output ("`$null -eq 0         -> " + ($null -eq 0))
Write-Output ("`$null.GetType()     -> throws, since `$null has no type - proven below")
try { $null.GetType() } catch { Write-Output ("  Error: " + $_.Exception.Message) }

# Arrays and hashtables - also real .NET types (Object[] and Hashtable).
$nums = 1,2,3
$map = @{ Name = "Mays"; Role = "Author" }
Write-Output "`nCollections:"
Write-Output ("`$nums.GetType().FullName -> " + $nums.GetType().FullName)
Write-Output ("`$map.GetType().FullName  -> " + $map.GetType().FullName)
Write-Output ("`$map['Name']             -> " + $map['Name'])
