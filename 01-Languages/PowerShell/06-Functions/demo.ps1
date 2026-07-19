# 06-Functions: function Verb-Noun {}, param() blocks, pipeline input, implicit return.

function Get-Square {
    param([int]$Number)
    $Number * $Number   # <- unassigned expression value: this becomes the function's output
}
Write-Output ("Get-Square 5 -> " + (Get-Square 5))

Write-Output "`nThe implicit-return gotcha: EVERY unassigned expression's value is emitted,"
Write-Output "not just the last one - a real, distinctive trap for anyone expecting a single 'return value':"
function Get-SquareNoisy {
    param([int]$Number)
    "about to square $Number"   # <- this ALSO becomes part of the output, not just a log line!
    $Number * $Number
}
$result = Get-SquareNoisy 4
Write-Output "Captured output has $($result.Count) items:"
$result | ForEach-Object { Write-Output "  item: $_" }

Write-Output "`nFixed version - use Write-Output/Write-Verbose for logging, not bare expressions:"
function Get-SquareClean {
    param([int]$Number)
    Write-Verbose "about to square $Number"   # goes to the verbose stream, not the output stream
    return $Number * $Number
}
$clean = Get-SquareClean 4
Write-Output "Captured output has $($clean.Count) item(s): $clean"

Write-Output "`nPipeline input via [Parameter(ValueFromPipeline)]:"
function Test-IsEven {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [int]$Number
    )
    process {
        # 'process' runs once PER pipeline item - essential for real pipeline functions.
        [PSCustomObject]@{ Number = $Number; IsEven = ($Number % 2 -eq 0) }
    }
}
1..5 | Test-IsEven | Format-Table -AutoSize | Out-String | Write-Output
