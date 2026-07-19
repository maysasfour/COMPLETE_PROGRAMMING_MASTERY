# 11 - Classes and OOP

[Back to course overview](../README.md) | Previous: [10 - File Handling](../10-File-Handling/README.md) | Next: [12 - Functional Concepts](../12-Functional-Concepts/README.md)

## What / Why / Where

PowerShell 5.0+ has a real `class` keyword producing genuine .NET types - constructors,
typed properties, methods, and inheritance. This is contrasted here with the older,
still-common `PSCustomObject` + `Add-Member -MemberType ScriptMethod` pattern, which predates
`class` and has no real type identity or enforced shape.

## Verified Live

```powershell
class BankAccount {
    [string]$Owner; [double]$Balance
    BankAccount([string]$owner, [double]$b) { $this.Owner=$owner; $this.Balance=$b }
    [void]Deposit([double]$amount) { ... }
}
$a = [BankAccount]::new("Mays", 100)
$a.GetType().FullName   # -> BankAccount (a real, first-class .NET type)
```

Inheritance (`class SavingsAccount : BankAccount`) works with a real `base()` constructor
call and `-is` type-checking - `$savings -is [BankAccount]` correctly returned `True`.
Withdrawing more than the balance correctly throws a real, catchable exception.

## Advantages / Disadvantages

- Advantage: real type identity, constructors, and inheritance - genuinely closer to C#/Java OOP than the older `PSCustomObject` pattern.
- Advantage: works seamlessly with .NET generics (see [13-Generics](../13-Generics/README.md)) as type parameters.
- Disadvantage: `class` was only added in PowerShell 5.0 - scripts needing 2.0-4.0 compatibility must use the older `PSCustomObject` pattern.
- Disadvantage: PowerShell classes don't support some C#-style OOP features (e.g. no true interfaces prior to newer versions, limited generic class support).

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md) - `class` requires PowerShell 5.0+ (confirmed present here: 5.1).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Using the older `PSCustomObject`+`Add-Member` pattern by habit/copy-paste when a real `class` would be clearer and safer.
- Forgetting `[void]` return type annotations on methods that shouldn't return a value, causing unintended pipeline output.
- Not realizing PowerShell classes are real .NET types usable directly as generic type parameters (see [13-Generics](../13-Generics/README.md)).

## Best Practices

- Prefer real `class` definitions over `PSCustomObject`+`ScriptMethod` for anything beyond a one-off data bag, in PowerShell 5.0+.
- Use `[void]` on methods with no meaningful return value.
- Validate inputs and `throw` inside methods rather than allowing invalid state.

## Detailed Example

See [demo.ps1](demo.ps1) - all output above was captured from a real run, including the older pattern for direct comparison.

## Interview Questions

1. **What's the difference between the `PSCustomObject`+`ScriptMethod` pattern and a real `class`?** `PSCustomObject` is just a property bag with attached script blocks and no real type identity; `class` (PS 5.0+) produces a genuine .NET type with constructors and enforced shape - verified live: `$account.GetType().FullName` for a `class`-based instance returned the real type name `BankAccount`, unlike the old-style object.
2. **Does PowerShell support inheritance?** Yes, via `class Derived : Base { ... }` with `base()` constructor calls - verified live: a `SavingsAccount : BankAccount` instance correctly passed `$savings -is [BankAccount]` -> `True`.

## Recommended Next Lesson

[12 - Functional Concepts](../12-Functional-Concepts/README.md)
