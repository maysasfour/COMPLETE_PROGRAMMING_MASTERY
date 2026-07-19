# Solutions: The Object Pipeline

Write-Output "1) Top 5 processes by thread count:"
Get-Process |
    Where-Object { $_.Threads.Count -gt 0 } |
    Sort-Object -Property @{Expression={$_.Threads.Count}} -Descending |
    Select-Object -First 5 -Property Name, @{Name='Threads';Expression={$_.Threads.Count}} |
    Format-Table -AutoSize | Out-String | Write-Output

Write-Output "2) Group-Object by a computed boolean property:"
$products = @(
    [PSCustomObject]@{ Name = "Widget"; Price = 9.99;  Stock = 12 }
    [PSCustomObject]@{ Name = "Gadget"; Price = 19.99; Stock = 0 }
    [PSCustomObject]@{ Name = "Gizmo";  Price = 4.99;  Stock = 5 }
    [PSCustomObject]@{ Name = "Doohickey"; Price = 2.99; Stock = 0 }
)
$products | Select-Object *, @{Name='InStock';Expression={$_.Stock -gt 0}} |
    Group-Object -Property InStock |
    ForEach-Object { Write-Output "InStock=$($_.Name): $($_.Group.Name -join ', ')" }

Write-Output "`n3) Get-Member proves a piped string is a real System.String object:"
'hello' | ForEach-Object {
    Write-Output ("Type: " + $_.GetType().FullName)
    Write-Output ("Calling a real method directly on the piped object: `$_.ToUpper() -> " + $_.ToUpper())
}

Write-Output "`n4) Measure-Object vs. manual text parsing:"
$prices = $products | Measure-Object -Property Price -Sum -Average -Maximum
Write-Output ("Sum=$($prices.Sum) Average=$([math]::Round($prices.Average,2)) Max=$($prices.Maximum)")
Write-Output "Why this is more robust: Measure-Object operates on the real System.Decimal/Double"
Write-Output "Price property directly. Parsing equivalent formatted text (e.g. from a report table)"
Write-Output "would require locale-aware number parsing, stripping currency symbols/padding, and would"
Write-Output "break silently on any column-width or formatting change - none of which applies here."
