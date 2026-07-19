# Exercises: The Object Pipeline

1. Pipe `Get-Process` through `Where-Object`, `Sort-Object`, and `Select-Object` to list the 5 processes with the most threads, showing `Name` and `Threads` (thread count).
2. Build a custom array of `[PSCustomObject]` records (e.g. products with `Name`/`Price`/`Stock`) and use `Group-Object` to group by a computed "InStock" boolean.
3. Use `Get-Member` to prove that a string piped through the pipeline is a real `System.String` object with real methods, by calling one of its methods directly on a piped value inside `ForEach-Object`.
4. Compare `Measure-Object` on a numeric property from real objects (sum/average/max) against manually parsing equivalent text - explain in a comment why the object approach is more robust.
