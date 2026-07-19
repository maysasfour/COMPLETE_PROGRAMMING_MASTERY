# 08 - Strings

[Back to course overview](../README.md) | Previous: [07 - The Object Pipeline](../07-The-Object-Pipeline/README.md) | Next: [09 - Error Handling](../09-Error-Handling/README.md)

## What / Why / Where

String interpolation only happens in double quotes - a distinction shared with Perl. Single
quotes are always literal. Here-strings (`@"..."@` / `@'...'@`) preserve multi-line
formatting exactly, and the `-f` format operator mirrors .NET's composite formatting.

## Verified Live

```
"Hello, $name!"   -> Hello, Mays!            (interpolates)
'Hello, $name!'   -> Hello, $name!           (does not interpolate)
"{0} has {1} items worth {2:C}" -f $name,$count,29.997  -> Mays has 3 items worth $30.00
"{0:X}" -f 255    -> FF
```

## Advantages / Disadvantages

- Advantage: the single/double quote distinction makes it visually obvious, at a glance, whether a string will interpolate.
- Advantage: here-strings are genuinely convenient for embedded SQL/JSON/config templates.
- Disadvantage: forgetting the quote distinction (using single quotes and expecting interpolation) is a very common beginner bug.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Using single quotes and being confused when `$variable` doesn't interpolate.
- Forgetting `$(...)` is required for expressions (not just variables) inside double-quoted strings.
- Misaligning here-string closing delimiters (`"@`/`'@` must start at column 0 in the file).

## Best Practices

- Use single quotes by default for literal strings; switch to double quotes only when interpolation is actually needed.
- Use `-f` for anything with multiple substitutions or number/currency formatting, rather than string concatenation.
- Use here-strings for any multi-line template content instead of manual `\`n` concatenation.

## Detailed Example

See [demo.ps1](demo.ps1) - every example above was captured from a real run, including real .NET string methods (`Trim`, `ToUpper`, `Replace`, `Split`).

## Interview Questions

1. **Does PowerShell interpolate variables inside single-quoted strings?** No - verified live: `'Hello, $name!'` printed the literal text `$name`, while `"Hello, $name!"` correctly interpolated to `Hello, Mays!`.
2. **What does the `-f` operator do, and where does it come from?** PowerShell's composite string formatting operator, modeled on .NET's `String.Format` - verified live formatting a decimal as currency (`{2:C}` -> `$30.00`) and an integer as hex (`{0:X}` -> `FF`).

## Recommended Next Lesson

[09 - Error Handling](../09-Error-Handling/README.md)
