# 05-Control-Flow: if/elseif/else, switch (wildcards/regex/script blocks), foreach/while/for.

$score = 82
if ($score -ge 90) { Write-Output "Grade: A" }
elseif ($score -ge 80) { Write-Output "Grade: B" }
else { Write-Output "Grade: C or below" }

Write-Output "`nswitch with wildcard matching:"
$file = "report.txt"
switch -Wildcard ($file) {
    "*.txt" { Write-Output "$file -> text file" }
    "*.png" { Write-Output "$file -> image file" }
    default { Write-Output "$file -> unknown type" }
}

Write-Output "`nswitch with regex matching:"
$input1 = "user-42"
switch -Regex ($input1) {
    '^user-\d+$' { Write-Output "$input1 -> matches a user id pattern" }
    default { Write-Output "$input1 -> no match" }
}

Write-Output "`nswitch with a script-block condition (evaluated per case, most powerful form):"
$n = 17
switch ($n) {
    { $_ % 2 -eq 0 } { Write-Output "$n is even"; break }
    { $_ % 2 -ne 0 } { Write-Output "$n is odd"; break }
}

Write-Output "`nswitch without -break falls through to every matching case (distinct from C-style switch):"
switch (2) {
    1 { Write-Output "matched 1" }
    2 { Write-Output "matched 2" }
    { $_ -lt 5 } { Write-Output "matched 'less than 5' too - multiple cases can match!" }
}

Write-Output "`nforeach / while / for:"
foreach ($i in 1..3) { Write-Output "foreach: $i" }
$i = 0
while ($i -lt 3) { Write-Output "while: $i"; $i++ }
for ($j = 0; $j -lt 3; $j++) { Write-Output "for: $j" }
