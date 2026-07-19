# Solutions: Functions

Write-Output "1) Get-Factorial (recursive):"
function Get-Factorial {
    param([int]$N)
    if ($N -le 1) { return 1 }
    return $N * (Get-Factorial ($N - 1))
}
Write-Output ("Get-Factorial 5 -> " + (Get-Factorial 5))

Write-Output "`n2) Bare-expression gotcha, buggy then fixed:"
function Get-DoubleBuggy {
    param([int]$N)
    "processing $N"   # BUG: leaks into the output stream
    $N * 2
}
$buggyResult = Get-DoubleBuggy 3
Write-Output "Buggy call returned $($buggyResult.Count) item(s): $($buggyResult -join ' | ')"

function Get-DoubleFixed {
    param([int]$N)
    Write-Verbose "processing $N"   # verbose stream, not output
    return $N * 2
}
$fixedResult = Get-DoubleFixed 3
Write-Output "Fixed call returned $($fixedResult.Count) item(s): $fixedResult"

Write-Output "`n3) Pipeline-input Test-IsPalindrome:"
function Test-IsPalindrome {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [string]$Text
    )
    process {
        $clean = ($Text.ToLower() -replace '[^a-z0-9]', '')
        $chars = $clean.ToCharArray()
        [Array]::Reverse($chars)
        $reversed = -join $chars
        [PSCustomObject]@{ Text = $Text; IsPalindrome = ($clean -eq $reversed) }
    }
}
'racecar','hello','A man a plan a canal Panama' | Test-IsPalindrome | Format-Table -AutoSize | Out-String | Write-Output

Write-Output "4) Default parameter + [switch]:"
function Show-Greeting {
    param(
        [string]$Name = "World",
        [switch]$Verbose
    )
    if ($Verbose) { Write-Output "[verbose] building greeting for '$Name'" }
    Write-Output "Hello, $Name!"
}
Show-Greeting
Show-Greeting -Name "Mays" -Verbose
