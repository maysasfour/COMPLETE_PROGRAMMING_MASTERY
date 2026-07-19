# PowerShell Cheat Sheet

## Variables and Types

```powershell
$x = 5                  # System.Int32
$s = "hi"               # System.String
[int]$n = 10            # explicitly typed
$null                   # a real, distinct value
$x.GetType().FullName   # inspect the real .NET type
```

## Comparison Operators (word-based, NOT ==/!=/</>)

| Operator | Meaning | Case-sensitive variant |
|---|---|---|
| `-eq` | equal | `-ceq` |
| `-ne` | not equal | `-cne` |
| `-lt` / `-le` | less than / or equal | `-clt` / `-cle` |
| `-gt` / `-ge` | greater than / or equal | `-cgt` / `-cge` |
| `-like` | wildcard match | `-clike` |
| `-match` | regex match | `-cmatch` |
| `-in` / `-contains` | membership | - |

`-and` / `-or` / `-not` (or `!`) for logic. `<` and `>` are **redirection**, not comparison.

## Control Flow

```powershell
if ($x -gt 5) { } elseif ($x -eq 5) { } else { }

switch -Regex ($val) {
    '^\d+$'  { "number" }
    default  { "other" }
}

foreach ($i in 1..5) { }
while ($cond) { }
for ($i=0; $i -lt 5; $i++) { }
```

## Functions

```powershell
function Get-Square {
    param([int]$Number)
    $Number * $Number     # unassigned expr = implicit output (gotcha!)
}

function Test-Item {
    param([Parameter(ValueFromPipeline=$true)][int]$Number)
    process { $Number * 2 }   # runs once per pipeline item
}
```

## The Object Pipeline

```powershell
Get-Process | Where-Object { $_.Id -gt 100 } | Sort-Object CPU -Descending | Select-Object -First 5
Get-Member -InputObject $obj      # inspect real properties/methods
```

## Strings

```powershell
"Hello, $name"          # double quotes interpolate
'Hello, $name'           # single quotes do NOT
@"
multi-line
"@                       # here-string (interpolating)
'{0} is {1:C}' -f $name, 9.99   # -f format operator
```

## Error Handling

```powershell
try {
    Get-Item "x" -ErrorAction Stop   # -Stop makes it catchable
} catch [System.Exception] {
    $_.Exception.Message
} finally { }
$Error[0]                # most recent error
```

## File Handling / JSON

```powershell
Get-Content path.txt
Set-Content -Path path.txt -Value "text"
$obj | ConvertTo-Json | Set-Content data.json
Get-Content data.json -Raw | ConvertFrom-Json
```

## Classes

```powershell
class Account {
    [string]$Owner
    Account([string]$owner) { $this.Owner = $owner }
    [void]Greet() { Write-Output "Hi, $($this.Owner)" }
}
$a = [Account]::new("Mays")
```

## Generics

```powershell
[System.Collections.Generic.List[int]]::new()
[System.Collections.Generic.Dictionary[string,int]]::new()
[System.Collections.Generic.HashSet[string]]::new()
```

## Concurrency

```powershell
$job = Start-Job -ScriptBlock { Start-Sleep 1; "done" }
Wait-Job $job; Receive-Job $job; Remove-Job $job
```

## Modules

```powershell
Import-Module .\MyModule.psm1
Get-Module -ListAvailable
Install-Module -Name Pester -Scope CurrentUser
```

## API Calls

```powershell
Invoke-RestMethod -Uri $url                 # auto-parses JSON
Invoke-WebRequest -Uri $url                  # raw HTTP response
```

## Testing (Pester)

```powershell
Describe "Get-Square" {
    It "squares a number" { Get-Square 5 | Should Be 25 }   # Pester 3.x syntax
}
Invoke-Pester -Script .\Tests.ps1
```

## Best Practices Quick Reference

- `Get-Verb` for the approved verb list.
- `[CmdletBinding()]` for `-Verbose`/`-ErrorAction` support on your own functions.
- Never use `Write-Host` for values meant to be captured/piped - use `Write-Output`/`return`.
