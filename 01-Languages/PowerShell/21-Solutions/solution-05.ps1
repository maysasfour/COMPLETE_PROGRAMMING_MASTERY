# Solution 5 - Generic inventory (see 20-Exercises/README.md, problem 5).
# [System.Collections.Generic.Dictionary[string,int]] is a real generic type from .NET -
# unlike a plain @{} hashtable, it enforces the value type (int) at compile/bind time.
$inventory = [System.Collections.Generic.Dictionary[string, int]]::new()

function Add-Stock {
    param([string]$Name, [int]$Qty)
    if ($inventory.ContainsKey($Name)) { $inventory[$Name] += $Qty } else { $inventory[$Name] = $Qty }
}

function Remove-Stock {
    param([string]$Name, [int]$Qty)
    if (-not $inventory.ContainsKey($Name) -or $inventory[$Name] -lt $Qty) {
        throw "Not enough stock of '$Name' to remove $Qty."
    }
    $inventory[$Name] -= $Qty
}

Add-Stock -Name "widgets" -Qty 10
Remove-Stock -Name "widgets" -Qty 4
Write-Output "widgets in stock: $($inventory['widgets'])"
try { Remove-Stock -Name "widgets" -Qty 100 } catch { Write-Output "Caught: $($_.Exception.Message)" }
try { Remove-Stock -Name "gadgets" -Qty 1 } catch { Write-Output "Caught: $($_.Exception.Message)" }
