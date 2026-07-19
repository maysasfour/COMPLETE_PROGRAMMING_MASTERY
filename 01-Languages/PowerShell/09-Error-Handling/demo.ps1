# 09-Error-Handling: try/catch/finally, $Error, terminating vs. non-terminating errors.

Write-Output "Non-terminating error: script CONTINUES past it by default:"
Get-Item "C:\this-path-does-not-exist-xyz.txt" -ErrorAction Continue
Write-Output "-> execution reached this line despite the error above (non-terminating)."

Write-Output "`nA try/catch around that SAME call does NOT catch it - non-terminating errors don't throw:"
try {
    Get-Item "C:\this-path-does-not-exist-xyz.txt" -ErrorAction SilentlyContinue
    Write-Output "-> no exception was thrown, so this line runs; catch block below is skipped."
} catch {
    Write-Output "-> (this would only print if the error were terminating)"
}

Write-Output "`nThe fix: -ErrorAction Stop turns a non-terminating error into a real, catchable exception:"
try {
    Get-Item "C:\this-path-does-not-exist-xyz.txt" -ErrorAction Stop
} catch {
    Write-Output ("Caught it! Exception type: " + $_.Exception.GetType().FullName)
    Write-Output ("Message: " + $_.Exception.Message)
}

Write-Output "`ntry/catch/finally with a genuinely terminating error (divide by zero on integers):"
try {
    $x = 10
    $y = 0
    $z = $x / $y
} catch [System.DivideByZeroException] {
    Write-Output ("Caught a specific exception type: " + $_.Exception.Message)
} catch {
    Write-Output ("Caught a generic exception: " + $_.Exception.Message)
} finally {
    Write-Output "finally always runs, success or failure."
}

Write-Output "`n`$Error holds the automatic history of recent errors (most recent first):"
Write-Output ("Most recent error message: " + $Error[0].Exception.Message)
Write-Output ("Total errors recorded this session so far: " + $Error.Count)

Write-Output "`nThrowing and catching a custom error with a specific message:"
function Test-Age {
    param([int]$Age)
    if ($Age -lt 0) { throw "Age cannot be negative: $Age" }
    return $Age
}
try {
    Test-Age -Age -5
} catch {
    Write-Output ("Caught custom throw: " + $_.Exception.Message)
}
