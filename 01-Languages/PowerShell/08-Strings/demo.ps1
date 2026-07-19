# 08-Strings: interpolation (double quotes only), here-strings, -f format operator.

$name = "Mays"
$count = 3

Write-Output "Double quotes interpolate: Hello, $name! You have $count items."
Write-Output 'Single quotes do NOT interpolate: Hello, $name! You have $count items.'

Write-Output "`nExpressions need `$(...) inside double quotes:"
Write-Output "Doubled count: $($count * 2)"

Write-Output "`nHere-strings preserve exact multi-line formatting - useful for templates/SQL/JSON:"
$report = @"
Name:  $name
Count: $count
Line breaks and    spacing
are preserved exactly.
"@
Write-Output $report

Write-Output "`nSingle-quoted here-string - literal, no interpolation at all:"
$literal = @'
Raw text with $name NOT interpolated.
'@
Write-Output $literal

Write-Output "`nThe -f format operator (like .NET's String.Format / composite formatting):"
Write-Output ("{0} has {1} items worth {2:C}" -f $name, $count, 29.997)
Write-Output ("Zero-padded: {0:D4}" -f 42)
Write-Output ("Hex: {0:X}" -f 255)

Write-Output "`nCommon string methods (real .NET System.String methods):"
$s = "  Hello, World!  "
Write-Output ("Trim(): '" + $s.Trim() + "'")
Write-Output ("ToUpper(): " + $s.Trim().ToUpper())
Write-Output ("Replace(): " + $s.Trim().Replace("World", "PowerShell"))
Write-Output ("Split(','): " + ($s.Trim().Split(',') -join ' | '))
