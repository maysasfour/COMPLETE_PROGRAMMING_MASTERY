# Solutions to 20-Exercises. Every section below was run for real; output is documented
# in this folder's README.md, captured from an actual execution of this file.

Write-Output "=== 1) Case-sensitive role check ==="
function Test-RoleAccess {
    param([string]$Role)
    if ($Role -ceq "admin") { return "GRANTED" }
    return "DENIED"
}
'admin','Admin','ADMIN' | ForEach-Object { Write-Output "$_ -> $(Test-RoleAccess $_)" }

Write-Output "`n=== 2) Object pipeline report - average salary per department ==="
$employees = @(
    [PSCustomObject]@{ Name = "Ana";  Department = "Eng"; Salary = 90000 }
    [PSCustomObject]@{ Name = "Ben";  Department = "Eng"; Salary = 95000 }
    [PSCustomObject]@{ Name = "Cara"; Department = "Sales"; Salary = 70000 }
    [PSCustomObject]@{ Name = "Dee";  Department = "Sales"; Salary = 75000 }
)
$employees | Group-Object -Property Department | ForEach-Object {
    $avg = ($_.Group | Measure-Object -Property Salary -Average).Average
    Write-Output ("{0}: avg salary = {1:N0}" -f $_.Name, $avg)
}

Write-Output "`n=== 3) Safe file reader ==="
function Read-FileSafe {
    param([string]$Path)
    try {
        return Get-Content -Path $Path -Raw -ErrorAction Stop
    } catch {
        return "Could not read '$Path': file does not exist."
    }
}
Write-Output (Read-FileSafe -Path "C:\definitely-not-real-xyz.txt")

Write-Output "`n=== 4) A real class: Book ==="
class Book {
    [string]$Title
    [string]$Author
    [bool]$IsCheckedOut = $false

    Book([string]$title, [string]$author) { $this.Title = $title; $this.Author = $author }

    [void]CheckOut() {
        if ($this.IsCheckedOut) { throw "'$($this.Title)' is already checked out." }
        $this.IsCheckedOut = $true
    }
    [void]Return() {
        if (-not $this.IsCheckedOut) { throw "'$($this.Title)' was not checked out." }
        $this.IsCheckedOut = $false
    }
}
$book = [Book]::new("Dune", "Frank Herbert")
$book.CheckOut()
Write-Output "Checked out: $($book.Title), IsCheckedOut=$($book.IsCheckedOut)"
try { $book.CheckOut() } catch { Write-Output "Caught: $($_.Exception.Message)" }
$book.Return()
Write-Output "Returned: IsCheckedOut=$($book.IsCheckedOut)"

Write-Output "`n=== 5) Generic inventory ==="
$inventory = [System.Collections.Generic.Dictionary[string,int]]::new()
function Add-Stock { param($Name, $Qty) $inventory[$Name] = ($inventory[$Name] + $Qty) }
function Remove-Stock {
    param($Name, $Qty)
    if (-not $inventory.ContainsKey($Name) -or $inventory[$Name] -lt $Qty) {
        throw "Not enough stock of '$Name' to remove $Qty."
    }
    $inventory[$Name] -= $Qty
}
Add-Stock -Name "widgets" -Qty 10
Remove-Stock -Name "widgets" -Qty 4
Write-Output "widgets in stock: $($inventory['widgets'])"
try { Remove-Stock -Name "widgets" -Qty 100 } catch { Write-Output "Caught: $($_.Exception.Message)" }

Write-Output "`n=== 6) JSON round-trip verification ==="
function Save-Records { param($Records, $Path) $Records | ConvertTo-Json -Depth 5 | Set-Content -Path $Path }
function Load-Records { param($Path) @(Get-Content -Path $Path -Raw | ConvertFrom-Json) }
$original = @([PSCustomObject]@{ Id=1; Name="A" }, [PSCustomObject]@{ Id=2; Name="B" })
$jsonPath = "$env:TEMP\ps-ex6.json"
Save-Records -Records $original -Path $jsonPath
$reloaded = Load-Records -Path $jsonPath
$matches = ($original.Count -eq $reloaded.Count) -and (0..($original.Count-1) | ForEach-Object { $original[$_].Id -eq $reloaded[$_].Id -and $original[$_].Name -eq $reloaded[$_].Name }) -notcontains $false
Write-Output "Round-trip matches original: $matches"
Remove-Item $jsonPath -Force

Write-Output "`n=== 7) Higher-order retry ==="
function Invoke-WithRetry {
    param([scriptblock]$Action, [int]$MaxAttempts = 3)
    $attempt = 0
    while ($attempt -lt $MaxAttempts) {
        $attempt++
        try { return & $Action }
        catch {
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
