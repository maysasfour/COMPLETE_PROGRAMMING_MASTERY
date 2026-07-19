# Code under test for the Pester examples below.
function Get-Square {
    param([int]$Number)
    return $Number * $Number
}

function Get-Average {
    param([double[]]$Numbers)
    if ($Numbers.Count -eq 0) { throw "Cannot average an empty collection." }
    return ($Numbers | Measure-Object -Average).Average
}
