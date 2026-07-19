# 13-Generics: PowerShell can use real .NET generics directly - a genuine positive
# contrast with several other dynamic-language courses in this repo that have none at all.

Write-Output "A real generic .NET collection, instantiated directly from PowerShell:"
$list = [System.Collections.Generic.List[int]]::new()
$list.Add(1); $list.Add(2); $list.Add(3)
Write-Output ("Type: " + $list.GetType().FullName)
Write-Output ("Contents: " + ($list -join ','))

Write-Output "`nType safety is real and enforced - adding a wrong-typed item throws:"
try {
    $list.Add("not an int")
} catch {
    Write-Output ("Caught: " + $_.Exception.Message)
}

Write-Output "`nGeneric Dictionary[TKey,TValue]:"
$dict = [System.Collections.Generic.Dictionary[string,int]]::new()
$dict["apples"] = 5
$dict["oranges"] = 3
foreach ($key in $dict.Keys) { Write-Output ("$key -> " + $dict[$key]) }

Write-Output "`nGeneric with a custom class as the type parameter:"
class Point {
    [int]$X
    [int]$Y
    Point([int]$x, [int]$y) { $this.X = $x; $this.Y = $y }
    [string]ToString() { return "($($this.X),$($this.Y))" }
}
$points = [System.Collections.Generic.List[Point]]::new()
$points.Add([Point]::new(1,2))
$points.Add([Point]::new(3,4))
Write-Output ("Points: " + (($points | ForEach-Object { $_.ToString() }) -join ' '))

Write-Output "`nGeneric HashSet[T] - real set semantics, duplicates rejected:"
$set = [System.Collections.Generic.HashSet[string]]::new()
Write-Output ("Add 'a': " + $set.Add("a"))
Write-Output ("Add 'a' again: " + $set.Add("a") + "  (false - already present)")
Write-Output ("Set count: " + $set.Count)
