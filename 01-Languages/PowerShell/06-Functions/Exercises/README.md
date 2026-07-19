# Exercises: Functions

1. Write `Get-Factorial` (a properly named `Verb-Noun` function) that computes a factorial recursively.
2. Deliberately write a function with a "gotcha" bare-expression bug (an extra unassigned string in the middle), demonstrate the bug with captured output, then fix it.
3. Write a pipeline-input function `Test-IsPalindrome` using `[Parameter(ValueFromPipeline=$true)]` and a `process {}` block, and run several strings through it via the pipe.
4. Write a function with a default parameter value and a `switch` parameter (`[switch]$Verbose`).
