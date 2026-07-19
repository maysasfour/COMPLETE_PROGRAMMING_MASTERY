# 13 - Generics

[Back to course overview](../README.md) | Previous: [12 - Functional Concepts](../12-Functional-Concepts/README.md) | Next: [14 - Concurrency](../14-Concurrency/README.md)

## What / Why / Where

PowerShell can use real .NET generics directly - `[System.Collections.Generic.List[int]]::new()`
and friends - a genuine positive contrast with several other dynamic-language courses in this
repository that have no generics at all (e.g. Ruby, PHP, Python's runtime type system).

## Verified Live

```powershell
$list = [System.Collections.Generic.List[int]]::new()
$list.Add(1); $list.Add(2); $list.Add(3)
$list.Add("not an int")   # throws - real, enforced type safety
```
Confirmed: adding a non-`int` to `List[int]` throws a real, catchable
`System.Management.Automation.MethodInvocationException` wrapping a conversion error - not
a silent coercion. `Dictionary[string,int]`, a generic `List[Point]` (a real custom `class`
as the type parameter), and `HashSet[string]` (real set semantics, duplicate rejection) were
all demonstrated live.

## Advantages / Disadvantages

- Advantage: real, enforced generic type safety, unlike PowerShell's normally very permissive dynamic typing.
- Advantage: custom `class` types (see [11-Classes-and-OOP](../11-Classes-and-OOP/README.md)) work directly as generic type parameters.
- Disadvantage: the full generic type syntax (`[System.Collections.Generic.List[int]]`) is verbose compared to native array/hashtable literals.

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Defaulting to plain arrays/hashtables everywhere and not realizing generics are available and give real type safety.
- Forgetting generics are real .NET types and can be used with custom PowerShell `class` types as type parameters.
- Assuming `HashSet[T].Add()` behaves like a plain array's `+=` - it correctly rejects duplicates and returns a boolean indicating whether the add succeeded.

## Best Practices

- Use `List[T]`/`Dictionary[TKey,TValue]`/`HashSet[T]` when you want enforced type safety or set semantics that plain PowerShell collections don't give you.
- Check `HashSet[T].Add()`'s boolean return value when duplicate detection matters.

## Detailed Example

See [demo.ps1](demo.ps1) - all output above, including the real thrown exception, was captured from a real run.

## Interview Questions

1. **Does PowerShell support generics?** Yes, directly from .NET - verified live: `[System.Collections.Generic.List[int]]::new()` produced a real, type-enforced list that threw when a non-`int` value was added.
2. **Can a custom PowerShell `class` be used as a generic type parameter?** Yes - verified live: `[System.Collections.Generic.List[Point]]::new()` (with `Point` a real `class` from this course) worked directly, storing and retrieving real `Point` instances.

## Recommended Next Lesson

[14 - Concurrency](../14-Concurrency/README.md)
