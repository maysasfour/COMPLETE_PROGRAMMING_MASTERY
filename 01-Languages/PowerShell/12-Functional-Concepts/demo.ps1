# 12-Functional-Concepts: script blocks ({ }) as first-class values,
# Where-Object/ForEach-Object/Sort-Object with custom predicates.

Write-Output "A script block is a real, storable, first-class value - not just inline syntax:"
$isEvenArg = { param($n) $n % 2 -eq 0 }
Write-Output ("Type of `$isEvenArg: " + $isEvenArg.GetType().FullName)
Write-Output ("Invoking it directly with & : " + (& $isEvenArg 4))
Write-Output ("Invoking it via .Invoke(): " + $isEvenArg.Invoke(7))

Write-Output "`nGOTCHA found while writing this lesson: Where-Object binds the pipeline item to"
Write-Output "`$_, NOT to a script block's own param() names. A param(`$n)-based block silently"
Write-Output "receives `$n = `$null inside Where-Object, so '0 % 2 -eq 0' is always true - EVERY"
Write-Output "item passes the filter, with no error at all:"
$numbers = 1..10
$brokenEvens = $numbers | Where-Object $isEvenArg
Write-Output ("Broken filter result (bug - passes everything): " + ($brokenEvens -join ','))

Write-Output "`nThe fix: predicates used with Where-Object/ForEach-Object must reference `$_, not param():"
$isEven = { $_ % 2 -eq 0 }
$evens = $numbers | Where-Object $isEven
Write-Output ("Fixed filter result: " + ($evens -join ','))

Write-Output "`nForEach-Object with a custom transformation script block (like .map):"
$squared = $numbers | ForEach-Object { $_ * $_ }
Write-Output ("Squared: " + ($squared -join ','))

Write-Output "`nSort-Object with a custom comparison expression (sort by a derived key):"
$words = "banana","kiwi","apple","fig"
$byLength = $words | Sort-Object -Property { $_.Length }
Write-Output ("Sorted by length: " + ($byLength -join ','))

Write-Output "`nChaining Where-Object | ForEach-Object | Sort-Object - functional style composition:"
$result = 1..20 |
    Where-Object { $_ % 3 -eq 0 } |
    ForEach-Object { $_ * 10 } |
    Sort-Object -Descending
Write-Output ("Multiples of 3, times 10, descending: " + ($result -join ','))

Write-Output "`nA function that accepts a script block parameter (higher-order function):"
function Invoke-NTimes {
    param([int]$Times, [scriptblock]$Action)
    1..$Times | ForEach-Object { & $Action $_ }
}
Invoke-NTimes -Times 3 -Action { param($i) Write-Output "iteration $i" }
