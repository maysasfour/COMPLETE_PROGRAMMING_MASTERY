# 03 - Variables and Data Types

[Back to course overview](../README.md) | Previous: [02 - Syntax](../02-Syntax/README.md) | Next: [04 - Operators](../04-Operators/README.md)

## What / Why / Where

PowerShell variables are prefixed with `$` and are dynamically typed, but every value is a
real .NET object underneath - `$x.GetType()` always reveals a genuine .NET type. This matters
because it means the entire .NET class library's behavior (methods, type coercion,
exceptions) is available on ordinary PowerShell values, not just a PowerShell-specific model.

## Verified Live: Real .NET Types Underneath

```
$name -> System.String
$age -> System.Int32
$pi -> System.Double
$isActive -> System.Boolean
```

Explicit typing (`[int]$count = 5`) constrains a variable and throws a real, catchable
`System.Management.Automation.PSInvalidCastException`-family error if an incompatible value
is assigned - verified live in [demo.ps1](demo.ps1) by assigning `"not a number"` to an
`[int]`-typed variable.

## `$null`

`$null` is a real, distinct value/type marker, not `0` or `""`:

```
$null -eq $null    -> True
$null -eq ''       -> False
$null -eq 0        -> False
$null.GetType()    -> throws (null has no type to call a method on)
```

## Collections

Arrays are `System.Object[]`; hashtables (`@{ }`) are `System.Collections.Hashtable` -
both real .NET types, verified live in [demo.ps1](demo.ps1).

## Advantages / Disadvantages

- Advantage: full .NET type system access from dynamically-typed scripts - no separate "PowerShell type model" to learn.
- Advantage: explicit typing (`[int]$x`) is available when you want stricter guarantees.
- Disadvantage: type coercion surprises are possible (e.g. string-to-number conversion attempts) if not explicit about types.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Assuming `$null` behaves like an empty string or zero in comparisons - verified live that it does not.
- Forgetting that explicitly-typed variables (`[int]$x`) throw on incompatible assignment rather than silently coercing.
- Not realizing every PowerShell value has a real, inspectable .NET type via `.GetType()`.

## Best Practices

- Use `.GetType()` or `Get-Member` when unsure what a value really is.
- Use explicit types (`[int]`, `[string]`, `[bool]`) for function parameters to get automatic validation for free.
- Compare against `$null` with `$null` on the left (`$null -eq $x`), which is also PowerShell's own documented style guidance, since it avoids surprises if `$x` happens to be a collection.

## Detailed Example

See [demo.ps1](demo.ps1) - all output above was captured from a real run.

## Interview Questions

1. **Is PowerShell dynamically or statically typed?** Dynamically typed by default (variables aren't declared with a fixed type), but every value carries a real, inspectable .NET type - verified live via `.GetType()` in [demo.ps1](demo.ps1) showing `System.String`, `System.Int32`, etc.
2. **Is `$null` the same as an empty string or zero in PowerShell?** No - verified live: `$null -eq ''` and `$null -eq 0` both evaluated to `False`; only `$null -eq $null` is `True`.

## Recommended Next Lesson

[04 - Operators](../04-Operators/README.md)
