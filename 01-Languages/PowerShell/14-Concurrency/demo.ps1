# 14-Concurrency: PowerShell background jobs (Start-Job/Receive-Job), with real measured timing.

Write-Output "Sequential baseline - three 1-second sleeps run one after another:"
$swSeq = [System.Diagnostics.Stopwatch]::StartNew()
1..3 | ForEach-Object { Start-Sleep -Seconds 1 }
$swSeq.Stop()
Write-Output ("Sequential elapsed: {0:N2}s" -f $swSeq.Elapsed.TotalSeconds)

Write-Output "`nSame work via background jobs - they run concurrently, in separate processes:"
$swJobs = [System.Diagnostics.Stopwatch]::StartNew()
$jobs = 1..3 | ForEach-Object {
    Start-Job -ScriptBlock { Start-Sleep -Seconds 1; "job done" }
}
$jobs | Wait-Job | Out-Null
$results = $jobs | Receive-Job
$jobs | Remove-Job
$swJobs.Stop()
Write-Output ("Job elapsed: {0:N2}s (should be close to 1s, not 3s, since jobs overlap)" -f $swJobs.Elapsed.TotalSeconds)
Write-Output ("Job results: " + ($results -join ' | '))

Write-Output "`nJobs run in fully separate PowerShell processes - they do NOT share variables with the caller:"
$myVar = "only in the main session"
$job = Start-Job -ScriptBlock { Get-Variable -Name myVar -ErrorAction SilentlyContinue }
$job | Wait-Job | Out-Null
$jobResult = $job | Receive-Job
$job | Remove-Job
Write-Output ("Job's view of `$myVar: [" + $jobResult + "] (empty - proves job isolation)")

Write-Output "`nPassing data INTO a job requires -ArgumentList explicitly:"
$job2 = Start-Job -ScriptBlock { param($x) "received: $x" } -ArgumentList $myVar
$job2 | Wait-Job | Out-Null
Write-Output ($job2 | Receive-Job)
$job2 | Remove-Job
