# TaskTracker.psm1 - a small, real CLI task tracker module.
# Persistence: file-based JSON (ConvertTo-Json/ConvertFrom-Json), per the honest finding in
# 16-Database-Access that no SQLite engine is genuinely available in this environment.

function Get-TaskStorePath {
    param([string]$Path = "$env:TEMP\ps-tasktracker\tasks.json")
    return $Path
}

function Initialize-TaskStore {
    param([string]$Path = (Get-TaskStorePath))
    $dir = Split-Path -Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    if (-not (Test-Path $Path)) { "[]" | Set-Content -Path $Path }
}

function Get-TaskList {
    param([string]$Path = (Get-TaskStorePath))
    Initialize-TaskStore -Path $Path
    $raw = Get-Content -Path $Path -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) { return @() }
    $items = $raw | ConvertFrom-Json
    if ($null -eq $items) { return @() }
    # GOTCHA (found and fixed while building this project): 'return @($items)' still
    # unwraps a single-element array when it crosses the function's output pipeline -
    # PowerShell auto-enumerates arrays on output unless the comma operator suppresses it.
    # Without the leading comma, a store with exactly one task silently came back as a
    # bare PSCustomObject instead of a 1-element array, breaking '.Count' for callers.
    # But the comma must be applied ONLY for the single-element case - prepending it
    # unconditionally would instead wrap an already-correct multi-element array inside
    # an extra outer array (a second real bug caught while testing this fix).
    $arr = @($items)
    if ($arr.Count -eq 1) { return ,$arr } else { return $arr }
}

function Save-TaskList {
    # GOTCHA (found and fixed): a Mandatory [array] parameter cannot bind an empty array -
    # PowerShell treats binding an empty collection to a Mandatory parameter as if nothing
    # was supplied and throws ParameterBindingValidationException. [AllowEmptyCollection()]
    # is required for this to work when removing the last remaining task.
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [array]$Tasks,
        [string]$Path = (Get-TaskStorePath)
    )
    if ($Tasks.Count -eq 0) {
        "[]" | Set-Content -Path $Path
    } else {
        $Tasks | ConvertTo-Json -Depth 5 | Set-Content -Path $Path
    }
}

function Add-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Title,
        [string]$Path = (Get-TaskStorePath)
    )
    # NOTE: deliberately NOT wrapped in @() here - Get-TaskList already returns a
    # correctly-shaped array (see its own comma-operator fix); wrapping its result in
    # @() again at the call site was found, while testing, to re-nest a 1-element array
    # inside another array, breaking property/Count access on every element.
    $tasks = Get-TaskList -Path $Path
    $nextId = if ($tasks.Count -eq 0) { 1 } else { ($tasks | Measure-Object -Property Id -Maximum).Maximum + 1 }
    $newTask = [PSCustomObject]@{
        Id      = $nextId
        Title   = $Title
        Done    = $false
        Created = (Get-Date).ToString("s")
    }
    $tasks = $tasks + $newTask
    Save-TaskList -Tasks $tasks -Path $Path
    return $newTask
}

function Get-Task {
    param([string]$Path = (Get-TaskStorePath))
    return Get-TaskList -Path $Path
}

function Complete-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][int]$Id,
        [string]$Path = (Get-TaskStorePath)
    )
    # NOTE: deliberately NOT wrapped in @() here - Get-TaskList already returns a
    # correctly-shaped array (see its own comma-operator fix); wrapping its result in
    # @() again at the call site was found, while testing, to re-nest a 1-element array
    # inside another array, breaking property/Count access on every element.
    $tasks = Get-TaskList -Path $Path
    $found = $false
    foreach ($t in $tasks) {
        if ($t.Id -eq $Id) { $t.Done = $true; $found = $true }
    }
    if (-not $found) { throw "No task with Id $Id found." }
    Save-TaskList -Tasks $tasks -Path $Path
    return $tasks | Where-Object { $_.Id -eq $Id }
}

function Remove-Task {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][int]$Id,
        [string]$Path = (Get-TaskStorePath)
    )
    # NOTE: deliberately NOT wrapped in @() here - Get-TaskList already returns a
    # correctly-shaped array (see its own comma-operator fix); wrapping its result in
    # @() again at the call site was found, while testing, to re-nest a 1-element array
    # inside another array, breaking property/Count access on every element.
    $tasks = Get-TaskList -Path $Path
    if (-not ($tasks | Where-Object { $_.Id -eq $Id })) { throw "No task with Id $Id found." }
    $remaining = @($tasks | Where-Object { $_.Id -ne $Id })
    Save-TaskList -Tasks $remaining -Path $Path
    if ($remaining.Count -eq 1) { return ,$remaining } else { return $remaining }
}

Export-ModuleMember -Function Get-TaskStorePath, Initialize-TaskStore, Get-TaskList, Save-TaskList, Add-Task, Get-Task, Complete-Task, Remove-Task
