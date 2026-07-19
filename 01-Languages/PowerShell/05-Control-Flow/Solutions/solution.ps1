# Solutions: Control Flow

Write-Output "1) Classify strings:"
function Get-StringKind {
    param([string]$Value)
    switch -Regex ($Value) {
        '^\S+@\S+\.\S+$'   { "email"; break }
        '^[\d\-]+$'        { "phone number"; break }
        default            { "unknown" }
    }
}
'a@b.com','555-1234','hello' | ForEach-Object { Write-Output "$_ -> $(Get-StringKind $_)" }

Write-Output "`n2) FizzBuzz via script-block switch cases:"
$fizzbuzz = 1..20 | ForEach-Object {
    switch ($_) {
        { $_ % 15 -eq 0 } { "fizzbuzz"; break }
        { $_ % 3  -eq 0 } { "fizz"; break }
        { $_ % 5  -eq 0 } { "buzz"; break }
        default           { $_ }
    }
}
Write-Output ($fizzbuzz -join ' ')

Write-Output "`n3) Sum a queue with a while loop until it exceeds 100:"
$queue = 10,25,40,15,30,5
$total = 0
$idx = 0
while ($total -le 100 -and $idx -lt $queue.Count) {
    $total += $queue[$idx]
    Write-Output "added $($queue[$idx]) -> running total: $total"
    $idx++
}

Write-Output "`n4) switch fallthrough without break matches multiple cases:"
switch (6) {
    { $_ -gt 0 }  { Write-Output "matched: greater than 0" }
    { $_ -gt 5 }  { Write-Output "matched: greater than 5" }
    { $_ -lt 10 } { Write-Output "matched: less than 10" }
}
