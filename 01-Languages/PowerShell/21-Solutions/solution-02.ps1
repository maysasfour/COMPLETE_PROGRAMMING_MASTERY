# Solution 2 - Object pipeline report (see 20-Exercises/README.md, problem 2).
# Group-Object buckets the [PSCustomObject] records by Department, and Measure-Object
# -Average computes the average Salary within each bucket's .Group.
$employees = @(
    [PSCustomObject]@{ Name = "Ana";  Department = "Eng";   Salary = 90000 }
    [PSCustomObject]@{ Name = "Ben";  Department = "Eng";   Salary = 95000 }
    [PSCustomObject]@{ Name = "Cara"; Department = "Sales"; Salary = 70000 }
    [PSCustomObject]@{ Name = "Dee";  Department = "Sales"; Salary = 75000 }
)

$employees | Group-Object -Property Department | ForEach-Object {
    $avg = ($_.Group | Measure-Object -Property Salary -Average).Average
    Write-Output ("{0}: avg salary = {1:N0}" -f $_.Name, $avg)
}
