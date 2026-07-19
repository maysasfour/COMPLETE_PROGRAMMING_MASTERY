# Pester tests for the TaskTracker mini-project.
# Each test uses an isolated temp JSON file per test so tests never interfere with each
# other or with the real CLI state a user may have built up via tracker.ps1.

Import-Module "$PSScriptRoot\TaskTracker.psm1" -Force

Describe "TaskTracker" {

    BeforeEach {
        $script:TestPath = "$env:TEMP\ps-tasktracker-tests\$([guid]::NewGuid()).json"
    }

    AfterEach {
        Remove-Item $script:TestPath -Force -ErrorAction SilentlyContinue
    }

    It "starts with an empty list" {
        (Get-TaskList -Path $script:TestPath).Count | Should Be 0
    }

    It "adds a task and assigns Id 1" {
        $t = Add-Task -Title "First task" -Path $script:TestPath
        $t.Id | Should Be 1
        $t.Done | Should Be $false
    }

    It "increments Id for successive tasks" {
        Add-Task -Title "One" -Path $script:TestPath | Out-Null
        $second = Add-Task -Title "Two" -Path $script:TestPath
        $second.Id | Should Be 2
    }

    It "marks a task complete" {
        $t = Add-Task -Title "Complete me" -Path $script:TestPath
        $updated = Complete-Task -Id $t.Id -Path $script:TestPath
        $updated.Done | Should Be $true
    }

    It "throws when completing a nonexistent task" {
        { Complete-Task -Id 999 -Path $script:TestPath } | Should Throw "No task with Id 999 found."
    }

    It "removes a task" {
        $t = Add-Task -Title "Remove me" -Path $script:TestPath
        $remaining = Remove-Task -Id $t.Id -Path $script:TestPath
        $remaining.Count | Should Be 0
    }

    It "persists tasks across separate Get-TaskList calls (real file-based persistence)" {
        Add-Task -Title "Persisted" -Path $script:TestPath | Out-Null
        (Get-TaskList -Path $script:TestPath).Count | Should Be 1
    }
}
