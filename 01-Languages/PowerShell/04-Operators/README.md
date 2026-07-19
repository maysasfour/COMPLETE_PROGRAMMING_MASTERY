# 04 - Operators

[Back to course overview](../README.md) | Previous: [03 - Variables and Data Types](../03-Variables-and-Data-Types/README.md) | Next: [05 - Control Flow](../05-Control-Flow/README.md)

## What / Why / Where

PowerShell uses word-based comparison operators (`-eq`, `-ne`, `-lt`, `-gt`) instead of the
C-style symbols (`==`, `!=`, `<`, `>`) used by essentially every other language course in
this repository (C, C#, Java, Python, JavaScript, Ruby, PHP...). This is not arbitrary:
`<` and `>` are reserved for redirection in PowerShell, exactly as in Bash.

## Verified Live: Word Operators, Not Symbols

```
5 -eq 5   -> True
5 -ne 4   -> True
3 -lt 10  -> True
10 -gt 3  -> True
```

Trying `5 == 5` fails - it's parsed as an invalid assignment expression, not a comparison
(verified live via `Invoke-Expression` in [demo.ps1](demo.ps1)).

`5 > file.txt` is **valid** PowerShell - but it means redirection (write `5` to `file.txt`),
not "greater than". Verified live: the file's contents afterward were literally `5`.

## Logical Operators

`-and`, `-or`, `-not` (or `!`). No `&&`/`||`/`!` C-style equivalents for the first two.

## Case (In)Sensitivity

`-eq` is **case-insensitive by default** (`'admin' -eq 'ADMIN'` -> `True`, verified live);
`-ceq` is the explicit case-sensitive form. This is covered in depth, with a real
authorization-bug scenario, in the prerequisite lesson
[19-Command-Line-and-Operating-Systems/02-PowerShell-Basics](../../19-Command-Line-and-Operating-Systems/02-PowerShell-Basics/README.md).

## Advantages / Disadvantages

- Advantage: no ambiguity between comparison and redirection, unlike shells that overload `<`/`>` differently for different purposes.
- Advantage: word operators read more like natural language in longer conditions.
- Disadvantage: real friction for developers used to C-style syntax, and a real source of first-week bugs (`if ($a == $b)` silently fails to parse as expected).

## Install Instructions

None beyond [01-Setup](../01-Setup/README.md).

## How to Run

```powershell
powershell -File demo.ps1
```

## Common Beginner Mistakes

- Writing `==`/`!=`/`<`/`>` out of habit - `<`/`>` are silently valid but mean redirection, which is a much worse trap than an outright syntax error.
- Assuming `-eq` is case-sensitive like most other languages' default string equality.
- Forgetting `-in`/`-contains` exist for membership checks instead of manually looping.

## Best Practices

- Use `-ceq`/`-cne` explicitly whenever case sensitivity is security- or correctness-relevant.
- Never use bare `<`/`>` expecting comparison - always use `-lt`/`-gt`.
- Prefer `-in`/`-contains` over manual loops for membership tests.

## Detailed Example

See [demo.ps1](demo.ps1) - all output shown above was captured from a real run.

## Interview Questions

1. **Why doesn't PowerShell use `==`/`!=`/`</>`?** Because `<` and `>` are reserved for redirection (as in Bash) - verified live: `5 > file.txt` wrote the text `5` to a file rather than comparing, and `5 == 5` failed to parse as a comparison at all.
2. **Is `-eq` case-sensitive in PowerShell?** No, not by default - verified live: `'admin' -eq 'ADMIN'` returned `True`; `'admin' -ceq 'ADMIN'` (the explicit case-sensitive form) correctly returned `False`.

## Recommended Next Lesson

[05 - Control Flow](../05-Control-Flow/README.md)
