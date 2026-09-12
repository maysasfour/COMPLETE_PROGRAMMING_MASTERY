# Solution 7 - Higher-order retry (see 20-Exercises/README.md, problem 7).
# Invoke-WithRetry takes a [scriptblock] as data and re-invokes it with '& $Action' -
# the '&' call operator is required to actually execute a scriptblock variable.
function Invoke-WithRetry {
    param([scriptblock]$Action, [int]$MaxAttempts = 3)
    $attempt = 0
    while ($attempt -lt $MaxAttempts) {
        $attempt++
        try {
            return & $Action
        } catch {
            Write-Output "Attempt $attempt failed: $($_.Exception.Message)"
            if ($attempt -eq $MaxAttempts) { throw }
        }
    }
}

$script:tries = 0
$result = Invoke-WithRetry -MaxAttempts 3 -Action {
    $script:tries++
    if ($script:tries -lt 3) { throw "not ready yet (try $script:tries)" }
    "succeeded on try $script:tries"
}
Write-Output "Final result: $result"

# Also verify the give-up path: a block that always fails re-throws after MaxAttempts.
try {
    Invoke-WithRetry -MaxAttempts 2 -Action { throw "permanent failure" }
} catch {
    Write-Output "Gave up after retries, final error: $($_.Exception.Message)"
}
