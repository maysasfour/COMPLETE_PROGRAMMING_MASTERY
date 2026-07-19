# tracker.ps1 - the actual CLI entry point for the Task Tracker mini-project.
# Usage:
#   powershell -File tracker.ps1 add "Buy milk"
#   powershell -File tracker.ps1 list
#   powershell -File tracker.ps1 complete 1
#   powershell -File tracker.ps1 remove 2

param(
    [Parameter(Mandatory, Position = 0)]
    [ValidateSet('add', 'list', 'complete', 'remove')]
    [string]$Command,

    [Parameter(Position = 1)]
    [string]$Argument
)

Import-Module "$PSScriptRoot\TaskTracker.psm1" -Force

switch ($Command) {
    'add' {
        if (-not $Argument) { throw "Usage: tracker.ps1 add <title>" }
        $task = Add-Task -Title $Argument
        Write-Output "Added task #$($task.Id): $($task.Title)"
    }
    'list' {
        $tasks = Get-Task
        if ($tasks.Count -eq 0) { Write-Output "No tasks yet."; break }
        $tasks | ForEach-Object {
            $status = if ($_.Done) { "x" } else { " " }
            Write-Output "[$status] #$($_.Id) $($_.Title)"
        }
    }
    'complete' {
        if (-not $Argument) { throw "Usage: tracker.ps1 complete <id>" }
        $task = Complete-Task -Id ([int]$Argument)
        Write-Output "Completed task #$($task.Id): $($task.Title)"
    }
    'remove' {
        if (-not $Argument) { throw "Usage: tracker.ps1 remove <id>" }
        Remove-Task -Id ([int]$Argument) | Out-Null
        Write-Output "Removed task #$Argument"
    }
}
